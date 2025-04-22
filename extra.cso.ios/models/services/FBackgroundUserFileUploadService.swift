import Foundation

class FBackgroundUserFileUploadService {
    var mqttService = FDI.mqttService
    var notificationService = FDI.notificationService
    var commonService = FDI.commonService
    var azureBlobService = FDI.azureBlobService
    var myInfoService = FDI.myInfoService
    
    private let sasKeyQ = QueueLockModel<UserFileSASKeyQueueModel>("sasQ \(FExtensions.ins.getToday().toString("yyyy-MM-dd")) \(UUID().uuidString)")
    private let azureQ = QueueLockModel<UserFileAzureQueueModel>("azureQ \(FExtensions.ins.getToday().toString("yyyy-MM-dd")) \(UUID().uuidString)")
    private let resultQ = QueueLockModel<UserFileResultQueueModel>("resultQ \(FExtensions.ins.getToday().toString("yyyy-MM-dd")) \(UUID().uuidString)")
    private let sasTrainingKeyQ = QueueLockModel<UserTrainingFileSASKeyQueueModel>("sasTrainingQ \(FExtensions.ins.getToday().toString("yyyy-MM-dd")) \(UUID().uuidString)")
    private let azureTrainingQ = QueueLockModel<UserTrainingFileAzureQueueModel>("azureTrainingQ \(FExtensions.ins.getToday().toString("yyyy-MM-dd")) \(UUID().uuidString)")
    private let resultTrainingQ = QueueLockModel<UserTrainingFileResultQueueModel>("resultTrainingQ \(FExtensions.ins.getToday().toString("yyyy-MM-dd")) \(UUID().uuidString)")
    
    private var resultQRun = false
    private var resultTrainingQRun = false
    
    func sasKeyEnqueue(_ data: UserFileSASKeyQueueModel) {
        sasKeyQ.enqueue(data, true) {
            self.sasKeyThreadStart()
        }
    }
    func sasKeyEnqueue(_ data: UserTrainingFileSASKeyQueueModel) {
        sasTrainingKeyQ.enqueue(data, true) {
            self.sasKeyTrainingThreadStart()
        }
    }
    private func azureEnqueue(_ data: UserFileAzureQueueModel) {
        azureQ.enqueue(data, true) {
            self.azureThreadStart()
        }
    }
    private func azureEnqueue(_ data: UserTrainingFileAzureQueueModel) {
        azureTrainingQ.enqueue(data, true) {
            self.azureTrainingThreadStart()
        }
    }
    private func resultEnqueue(_ data: UserFileResultQueueModel) {
        resultQ.locking()
        if let findBuff = resultQ.findQ(false, { $0.uuid == data.uuid }) {
            findBuff.appendItemPath(data.currentMedia, data.itemIndex)
        } else {
            resultQ.enqueue(data, false)
        }
        resultThreadStart(resultQRun)
        resultQRun = true
        resultQ.unlocking()
    }
    private func resultEnqueue(_ data: UserTrainingFileResultQueueModel) {
        resultTrainingQ.locking()
        if let findBuff = resultTrainingQ.findQ(false, { $0.uuid == data.uuid }) {
            findBuff.setThis(data)
        } else {
            resultTrainingQ.enqueue(data, false)
        }
        resultTrainingThreadStart(resultQRun)
        resultTrainingQRun = true
        resultTrainingQ.unlocking()
    }
    private func resultDequeue() -> UserFileResultQueueModel {
        resultQ.locking()
        let ret: UserFileResultQueueModel
        if let retBuff = resultQ.findQ(false, { $0.readyToSend() }) {
            ret = retBuff
            _ = resultQ.removeQ(ret, false)
        } else {
            ret = UserFileResultQueueModel()
            ret.uuid = "-1"
        }
        resultQ.unlocking()
        return ret
    }
    private func resultTrainingDequeue() -> UserTrainingFileResultQueueModel {
        resultTrainingQ.locking()
        let ret: UserTrainingFileResultQueueModel
        if let retBuff = resultTrainingQ.findQ(false, { $0.readyToSend() }) {
            ret = retBuff
            _ = resultTrainingQ.removeQ(ret, false)
        } else {
            ret = UserTrainingFileResultQueueModel()
            ret.uuid = "-1"
        }
        resultTrainingQ.unlocking()
        return ret
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
        resultQ.threadStart( {
            while self.resultQ.isNotEmpty() {
                self.postResultData(self.resultDequeue())
                Thread.sleep(forTimeInterval: 0.5)
            }
            self.resultQRun = false
        }, resultQRun)
    }
    private func sasKeyTrainingThreadStart() {
        sasTrainingKeyQ.threadStart {
            self.checkSASKeyQ(self.sasTrainingKeyQ.dequeue())
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
    private func azureTrainingThreadStart() {
        azureTrainingQ.threadStart {
            self.checkAzureQ(self.azureTrainingQ.dequeue())
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
    private func resultTrainingThreadStart(_ resultQRun: Bool) {
        resultTrainingQ.threadStart( {
            while self.resultTrainingQ.isNotEmpty() {
                self.postResultData(self.resultTrainingDequeue())
                Thread.sleep(forTimeInterval: 0.5)
            }
            self.resultTrainingQRun = false
        }, resultQRun)
    }
    private func checkSASKeyQ(_ data: UserFileSASKeyQueueModel?) {
        guard let data = data else {
            notificationCall(FAppLocalString.userFileUploadFail, "data is null")
            return
        }
        let blobName = data.blobName()
        
        Task {
            let ret = await commonService.postGenerateSasList(blobName.map { $0.1 })
            guard let retData = ret.data,
                  let retResult = ret.result, retResult != true else {
                      notificationCall(FAppLocalString.userFileUploadFail, ret.msg)
                      return
            }
            let uuid = UUID().uuidString
            let resultQ = UserFileResultQueueModel()
            resultQ.uuid = uuid
            resultQ.itemIndex = -1
            resultQ.itemCount = data.medias.count
            resultQ.mediaTypeIndex = data.mediaTypeIndex
            resultEnqueue(resultQ)
            
            
            for (index, x) in retData.enumerated() {
                guard let queue = UserFileAzureQueueModel().parse(data, blobName, x) else {
                    continue
                }
                queue.uuid = uuid
                queue.itemIndex = index
                queue.mediaTypeIndex = data.mediaTypeIndex
                azureEnqueue(queue)
            }
            progressNotificationCall(uuid)
        }
    }
    private func checkAzureQ(_ data: UserFileAzureQueueModel?) {
        guard let data = data else {
            notificationCall(FAppLocalString.userFileUploadFail, "data is null")
            return
        }
        Task {
            guard let url = data.media.mediaUrl else { notificationCall(FAppLocalString.userFileUploadFail, "mediaUrl is null"); return }
            let cachedFile = FImageUtils.urlToFile(url, data.media.mediaName)
            let ret = await azureBlobService.upload(data.userFileModel.blobUrlKey, cachedFile, data.userFileModel.mimeType)
            FImageUtils.fileDelete(cachedFile)
            FImageUtils.fileDelete(url)
            if ret.result == true {
                let resultQ = UserFileResultQueueModel()
                resultQ.uuid = data.uuid
                resultQ.currentMedia = data.userFileModel
                resultQ.itemIndex = data.itemIndex
                resultQ.mediaTypeIndex = data.mediaTypeIndex
                resultEnqueue(resultQ)
            } else {
                progressNotificationCall(data.uuid, true)
                notificationCall(FAppLocalString.userFileUploadFail)
            }
        }
    }
    private func postResultData(_ data: UserFileResultQueueModel) {
        if data.uuid == "-1" {
            return
        }
        
        let thisPK = FAmhohwa.getThisPK()
        Task {
            let ret = await myInfoService.putUserFileImageUrl(thisPK, data.parseBlobUploadModel(), data.userFileType())
            if ret.result == true {
                notificationCall(FAppLocalString.userFileUploadComp, "", thisPK)
                _ = await mqttService.postUserFileAdd(thisPK, getUserFileContent(data.userFileType()))
            } else {
                notificationCall(FAppLocalString.userFileUploadFail, ret.msg)
            }
            progressNotificationCall(data.uuid, true)
        }
    }
    private func getUserFileContent(_ userFileType: UserFileType) -> String {
        switch userFileType {
        case UserFileType.Taxpayer: return FAppLocalString.mqttTitleTaxpayerAdd
        case UserFileType.BankAccount: return FAppLocalString.mqttTitleBankAccountAdd
        case UserFileType.CsoReport: return FAppLocalString.mqttTitleCsoReportAdd
        case UserFileType.MarketingContract: return FAppLocalString.mqttTitleMarketingContractAdd
        }
    }
    private func checkSASKeyQ(_ data: UserTrainingFileSASKeyQueueModel?) {
        guard let data = data else {
            notificationCall(FAppLocalString.userFileUploadFail, "data is null")
            return
        }
        let blobName = data.blobName()
        
        Task {
            let ret = await commonService.getGenerateSas(blobName.1)
            guard let retData = ret.data,
                  let retResult = ret.result, retResult == true else {
                      notificationCall(FAppLocalString.userFileUploadFail, ret.msg)
                      return
            }
            let uuid = UUID().uuidString
            let resultQ = UserTrainingFileResultQueueModel()
            resultQ.uuid = uuid
            resultEnqueue(resultQ)
            let queue = UserTrainingFileAzureQueueModel().parse(data, retData)
            queue.uuid = uuid
            queue.trainingDate = data.trainingDate
            azureEnqueue(queue)
            progressNotificationCall(uuid)
        }
    }
    private func checkAzureQ(_ data: UserTrainingFileAzureQueueModel?) {
        guard let data = data else {
            notificationCall(FAppLocalString.userFileUploadFail, "data is null")
            return
        }
        Task {
            guard let url = data.media.mediaUrl else { notificationCall(FAppLocalString.userFileUploadFail, "mediaUrl is null"); return }
            let cachedFile = FImageUtils.urlToFile(url, data.media.mediaName)
            let ret = await azureBlobService.upload(data.userFileModel.blobUrlKey, cachedFile, data.userFileModel.mimeType)
            FImageUtils.fileDelete(cachedFile)
            FImageUtils.fileDelete(url)
            if ret.result == true {
                let resultQ = UserTrainingFileResultQueueModel()
                resultQ.uuid = data.uuid
                resultQ.media = data.userFileModel
                resultQ.trainingDate = data.trainingDate
                resultEnqueue(resultQ)
            } else {
                progressNotificationCall(data.uuid, true)
                notificationCall(FAppLocalString.userFileUploadFail)
            }
        }
    }
    private func postResultData(_ data: UserTrainingFileResultQueueModel) {
        if data.uuid == "-1" {
            return
        }
        let thisPK = FAmhohwa.getThisPK()
        Task {
            let ret = await myInfoService.postUserTrainingData(thisPK, data.trainingDate, data.media)
            if ret.result == true {
                notificationCall(FAppLocalString.userFileUploadComp, "", thisPK)
                _ = await mqttService.postUserFileAdd(thisPK, FAppLocalString.mqttTitleTrainingCertificateAdd)
            } else {
                notificationCall(FAppLocalString.userFileUploadFail, ret.msg)
            }
            progressNotificationCall(data.uuid, true)
        }
    }
    private func notificationCall(_ title: String, _ message: String? = nil, _ thisPK: String = "") {
        notificationService.sendNotify(NotifyIndex.USER_FILE_UPLOAD, title, message ?? "", FNotificationService.NotifyType.WITH_VIBRATE, true, thisPK)
        FEventBus.ins.emit(UserFileUploadEvent(thisPK))
    }
    private func progressNotificationCall(_ uuid: String, _ isCancel: Bool = false) {
        if isCancel {
            notificationService.updateNotification(uuid, "", "", 0, isCancel)
        } else {
            notificationService.makeProgressNotify(uuid, FAppLocalString.userFileUpload)
        }
    }
}
