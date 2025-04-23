import Foundation

class FBackgroundQnAUploadService {
    var mqttService = FDI.mqttService
    var notificationService = FDI.notificationService
    var commonService = FDI.commonService
    var azureBlobService = FDI.azureBlobService
    var qnaListService = FDI.qnaListService
    
    let sasKeyQ = QueueLockModel<QnASASKeyQueueModel>("sasQ \(FExtensions.ins.getToday().toString("yyyyMMdd_HHmmss")) \(UUID().uuidString)")
    let azureQ = QueueLockModel<QnAAzureQueueModel>("azureQ \(FExtensions.ins.getToday().toString("yyyyMMdd_HHmmss")) \(UUID().uuidString)")
    let resultQ = QueueLockModel<QnAResultQueueModel>("resultQ \(FExtensions.ins.getToday().toString("yyyyMMdd_HHmmss")) \(UUID().uuidString)")
    private var resultQRun = false
    
    func sasKeyEnqueue(_ data: QnASASKeyQueueModel) {
        sasKeyQ.enqueue(data, true, { self.sasKeyThreadStart() })
    }
    private func azureEnqueue(_ data: QnAAzureQueueModel) {
        azureQ.enqueue(data, true, { self.azureThreadStart() })
    }
    private func resultEnqueue(_ data: QnAResultQueueModel) {
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
    private func resultDequeue() -> QnAResultQueueModel {
        resultQ.locking()
        let ret: QnAResultQueueModel
        if let retBuff = resultQ.findQ(false, { $0.readyToSend() }) {
            ret = retBuff
            _ = resultQ.removeQ(ret, false)
        } else {
            ret = QnAResultQueueModel()
            ret.uuid = "-1"
        }
        resultQ.unlocking()
        return ret
    }
    private func resultBreak(_ uuid: String) {
        resultQ.locking()
        if let retBuff = resultQ.findQ(false, { $0.uuid == uuid }) {
            _ = resultQ.removeQ(retBuff, false)
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
    private func checkSASKeyQ(_ data: QnASASKeyQueueModel?) {
        guard let data = data else {
            notificationCall(FAppLocalString.qnaUploadFail, "data is null")
            return
        }
        let blobName = data.blobName()
        Task {
            let ret = await commonService.postGenerateSasList(blobName.map { $0.1 })
            guard let retData = ret.data,
                  let retResult = ret.result, retResult == true else {
                notificationCall(FAppLocalString.qnaUploadFail, ret.msg)
                return
            }
            let uuid = UUID().uuidString
            let resultQ = QnAResultQueueModel()
            resultQ.itemIndex = -1
            resultQ.itemCount = data.medias.count
            resultQ.qnaPK = data.qnaPK
            resultQ.title = data.title
            resultQ.content = data.content
            resultEnqueue(resultQ)
            for (index, x) in retData.enumerated() {
                guard let queue = QnAAzureQueueModel().parse(data, blobName, x) else {
                    continue
                }
                queue.uuid = uuid
                queue.qnaPK = data.qnaPK
                queue.mediaIndex = index
                azureEnqueue(queue)
            }
            progressNotificationCall(uuid)
        }
    }
    private func checkAzureQ(_ data: QnAAzureQueueModel?) {
        guard let data = data else {
            notificationCall(FAppLocalString.qnaUploadFail, "data is null")
            return
        }
        Task {
            guard let url = data.media.mediaUrl else { notificationCall(FAppLocalString.qnaUploadFail, "mediaUrl is null"); return }
            let cachedFile = FImageUtils.urlToFile(url, data.media.mediaName, data.media.originSize)
            let ret = await azureBlobService.upload(data.qnaFileModel.blobUrlKey, cachedFile, data.qnaFileModel.mimeType)
            FImageUtils.fileDelete(cachedFile)
            FImageUtils.fileDelete(url)
            if ret.result == true {
                let resultQ = QnAResultQueueModel()
                resultQ.uuid = data.uuid
                resultQ.qnaPK = data.qnaPK
                resultQ.currentMedia = data.qnaFileModel
                resultQ.itemIndex = data.mediaIndex
                resultEnqueue(resultQ)
            } else {
                progressNotificationCall(data.uuid, true)
                notificationCall(FAppLocalString.qnaUploadFail, ret.msg)
                resultBreak(data.uuid)
                
            }
        }
    }
    private func postResultData(_ data: QnAResultQueueModel) {
        if data.uuid == "-1" {
            return
        }
        Task {
            if data.qnaPK.isEmpty {
                await postData(data)
            } else {
                await postReply(data)
            }
        }
    }
    private func postData(_ data: QnAResultQueueModel) async {
        let ret = await qnaListService.postData(data.title, data.parsePostData())
        if ret.result == true {
            let qnaPK = ret.data?.thisPK ?? ""
            notificationCall(FAppLocalString.qnaUploadComp, qnaPK)
            _ = await mqttService.postQnA(qnaPK, data.title)
        } else {
            notificationCall(FAppLocalString.qnaUploadFail, ret.msg)
        }
        progressNotificationCall(data.uuid, true)
    }
    private func postReply(_ data: QnAResultQueueModel) async {
        let ret = await qnaListService.postReply(data.qnaPK, data.parsePostReply())
        if ret.result == true {
            notificationCall(FAppLocalString.qnaUploadComp, data.qnaPK)
            _ = await mqttService.postQnA(data.qnaPK, data.title)
        } else {
            notificationCall(FAppLocalString.qnaUploadFail, ret.msg)
        }
        progressNotificationCall(data.uuid, true)
    }
    
    private func notificationCall(_ title: String, _ message: String? = nil, _ thisPK: String = "") {
        notificationService.sendNotify(NotifyIndex.QNA_UPLOAD, title, message ?? "", thisPK)
        FEventBus.ins.emit(QnAUploadEvent(thisPK))
    }
    private func progressNotificationCall(_ uuid: String, _ isCancel: Bool = false) {
        if isCancel {
            notificationService.updateNotification(uuid, "", "", 0, isCancel)
        } else {
            notificationService.makeProgressNotify(uuid, FAppLocalString.qnaUpload)
        }
    }
}
