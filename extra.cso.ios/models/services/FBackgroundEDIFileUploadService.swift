import Foundation

class FBackgroundEDIFileUploadService {
    var mqttService = FDI.mqttService
    var notificationService = FDI.notificationService
    var commonService = FDI.commonService
    var azureBlobService = FDI.azureBlobService
    var ediListService = FDI.ediListService
    private let sasKeyQ = QueueLockModel<EDISASKeyQueueModel>("sasQ \(FExtensions.ins.getToday().toString("yyyyMMdd_HHmmss")) \(UUID().uuidString)")
    private let azureQ = QueueLockModel<EDIAzureQueueModel>("azureQ \(FExtensions.ins.getToday().toString("yyyyMMdd_HHmmss")) \(UUID().uuidString)")
    private let resultQ = QueueLockModel<EDIFileResultQueueModel>("resultQ \(FExtensions.ins.getToday().toString("yyyyMMdd_HHmmss")) \(UUID().uuidString)")
    private var resultQRun = false
    func sasKeyEnqueue(_ data: EDISASKeyQueueModel) {
        sasKeyQ.enqueue(data, true, { self.sasKeyThreadStart() })
    }
    private func azureEnqueue(_ data: EDIAzureQueueModel) {
        azureQ.enqueue(data, true, { self.azureThreadStart() })
    }
    private func resultEnqueue(_ data: EDIFileResultQueueModel) {
        resultQ.locking()
        if let findBuff = resultQ.findQ(false, { $0.uuid == data.uuid }) {
            findBuff.appendItemPath(data.currentMedia, data.itemIndex)
        } else {
            if data.itemIndex == -1 {
                resultQ.enqueue(data, false)
            }
        }
        resultThreadStart(resultQRun)
        resultQRun = true
        resultQ.unlocking()
    }
    private func resultDequeue() -> EDIFileResultQueueModel {
        resultQ.locking()
        let ret: EDIFileResultQueueModel
        if let retBuff = resultQ.findQ(false, { $0.readyToSend() }) {
            ret = retBuff
            _ = resultQ.removeQ(retBuff, false)
        } else {
            ret = EDIFileResultQueueModel()
            ret.uuid = "-1"
        }
        resultQ.unlocking()
        return ret
    }
    private func resultBreak(_ uuid: String) {
        resultQ.locking()
        if let findBuff = resultQ.findQ(false, { $0.uuid == uuid }) {
            _ = resultQ.removeQ(findBuff, false)
        }
        resultQ.unlocking()
    }
    private func sasKeyThreadStart() {
        sasKeyQ.threadStart {
            self.checkSASKeyQ(self.sasKeyQ.dequeue())
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
    private func azureThreadStart() {
        azureQ.threadStart {
            self.checkAzureQ(self.azureQ.dequeue())
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
    private func resultThreadStart(_ resultQRun: Bool) {
        resultQ.threadStart({
            while self.resultQ.isNotEmpty() {
                self.postResultData(self.resultDequeue())
                Thread.sleep(forTimeInterval: 0.5)
            }
            self.resultQRun = false
        }, resultQRun)
    }
    private func checkSASKeyQ(_ data: EDISASKeyQueueModel?) {
        guard let data = data else {
            notificationCall(FAppLocalString.ediFileUploadFail, "data is null")
            return
        }
        Task {
            for (_, pharma) in data.ediUploadModel.pharmaList.enumerated() {
                let uuid = UUID().uuidString
                let resultQ = EDIFileResultQueueModel()
                resultQ.uuid = uuid
                resultQ.ediPK = pharma.ediPK
                resultQ.ediPharmaPK = pharma.thisPK
                resultQ.itemIndex = -1
                resultQ.itemCount = pharma.uploadItems.count
                resultQ.ediUploadModel = data.ediUploadModel
                resultEnqueue(resultQ)
                progressNotificationCall(uuid)
                let blobName = data.blobName(pharma)
                let ret = await commonService.postGenerateSasList(blobName.map { $0.1 })
                guard let retData = ret.data,
                      let retResult = ret.result, retResult == true else {
                    notificationCall(FAppLocalString.ediFileUploadFail, ret.msg)
                    resultBreak(uuid)
                    progressNotificationCall(uuid, true)
                    return
                }
                for (index, x) in retData.enumerated() {
                    guard let queue = EDIAzureQueueModel().parse(pharma, blobName, x) else {
                        continue
                    }
                    queue.uuid = uuid
                    queue.ediPK = pharma.ediPK
                    queue.ediPharmaPK = pharma.thisPK
                    queue.mediaIndex = index
                    azureEnqueue(queue)
                }
            }
        }
    }
    private func checkAzureQ(_ data: EDIAzureQueueModel?) {
        guard let data = data else {
            notificationCall(FAppLocalString.ediFileUploadFail, "data is null")
            return
        }
        Task {
            guard let url = data.media.mediaUrl else { notificationCall(FAppLocalString.ediFileUploadFail, "mediaUrl is null"); return }
            let cachedFile = FImageUtils.urlToFile(url, data.media.mediaName, data.media.originSize)
            let ret = await azureBlobService.upload(data.ediPharmaFileUploadModel.blobUrlKey, cachedFile, data.ediPharmaFileUploadModel.mimeType)
            FImageUtils.fileDelete(cachedFile)
            FImageUtils.fileDelete(url)
            if ret.result == true {
                let resultQ = EDIFileResultQueueModel()
                resultQ.uuid = data.uuid
                resultQ.ediPK = data.ediPK
                resultQ.ediPharmaPK = data.ediPharmaPK
                resultQ.currentMedia = data.ediPharmaFileUploadModel
                resultQ.itemIndex = data.mediaIndex
                resultEnqueue(resultQ)
            } else {
                progressNotificationCall(data.uuid, true)
                notificationCall(FAppLocalString.ediFileUploadFail)
                resultBreak(data.uuid)
            }
        }
    }
    private func postResultData(_ data: EDIFileResultQueueModel) {
        if data.uuid == "-1" {
            return
        }
        Task {
            let ret = await ediListService.postPharmaFile(data.ediPK, data.ediPharmaPK, data.medias)
            if ret.result == true {
                notificationCall(FAppLocalString.ediFileUploadComp, data.ediPK)
                _ = await mqttService.postEDIRequest(data.ediPK, data.ediUploadModel.orgName)
            } else {
                notificationCall(FAppLocalString.ediFileUploadFail, ret.msg)
            }
            progressNotificationCall(data.uuid, true)
        }
    }
    
    private func notificationCall(_ title: String, _ message: String? = nil, _ thisPK: String = "") {
        notificationService.sendNotify(NotifyIndex.EDI_FILE_UPLOAD, title, message ?? "", thisPK)
        FEventBus.ins.emit(EDIUploadEvent(thisPK))
    }
    private func progressNotificationCall(_ uuid: String, _ isCancel: Bool = false) {
        if isCancel {
            notificationService.updateNotification(uuid, "", "", 0, isCancel)
        } else {
            notificationService.makeProgressNotify(uuid, FAppLocalString.ediFileUpload)
        }
    }
}
