protocol PMyInfoRepository {
    func getData() async -> RestResultT<ExtraMyInfoResponse>
    func getTrainingData() async -> RestResultT<[UserTrainingModel]>
    func putPasswordChange(_ currentPW: String, _ afterPW: String, _ confirmPW: String) async -> RestResultT<ExtraMyInfoResponse>
    func putUserFileImageUrl(_ thisPK: String, _ blobModel: BlobUploadModel, _ userFileType: UserFileType) async -> RestResultT<UserFileModel>
    func postUserTrainingData(_ thisPK: String, _ trainingDate: String, _ blobModel: BlobUploadModel) async -> RestResultT<UserTrainingModel>
}
