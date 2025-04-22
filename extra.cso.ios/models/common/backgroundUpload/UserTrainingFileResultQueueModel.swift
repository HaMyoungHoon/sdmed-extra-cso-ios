class UserTrainingFileResultQueueModel: Equatable {
    var uuid: String = ""
    var media: BlobUploadModel = BlobUploadModel()
    var trainingDate: String = ""
    
    func readyToSend() -> Bool {
        return !trainingDate.isEmpty
    }
    func setThis(_ data: UserTrainingFileResultQueueModel) {
        media = data.media
        trainingDate = data.trainingDate
    }
    static func == (lhs: UserTrainingFileResultQueueModel, rhs: UserTrainingFileResultQueueModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
