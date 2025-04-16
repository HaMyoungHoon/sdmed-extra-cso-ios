class MyInfoService: PMyInfoRepository {
    var baseUrl: String
    init(_ url: String) {
        baseUrl = url
    }
    func getData() async -> RestResultT<ExtraMyInfoResponse> {
        let url = "\(baseUrl)/data"
        let http = FHttp()
        return await http.get(url, ExtraMyInfoResponse.self)
    }
    func putPasswordChange(_ currentPW: String, _ afterPW: String, _ confirmPW: String) async -> RestResultT<ExtraMyInfoResponse> {
        let url = "\(baseUrl)/passwordChange"
        let http = FHttp()
        http.addParam("currentPW", currentPW)
        http.addParam("afterPW", afterPW)
        http.addParam("confirmPW", confirmPW)
        return await http.put(url, ExtraMyInfoResponse.self)
    }
    func putUserFileImageUrl(_ thisPK: String, _ blobModel: BlobUploadModel, _ userFileType: UserFileType) async -> RestResultT<UserFileModel> {
        let url = "\(baseUrl)/file/\(thisPK)"
        let http = FHttp()
        http.addParam("userFileType", userFileType.rawValue)
        return await http.put(url, blobModel, UserFileModel.self)
    }
    func postUserTrainingData(_ thisPK: String, _ trainingDate: String, _ blobModel: BlobUploadModel) async -> RestResultT<UserTrainingModel> {
        let url = "\(baseUrl)/file/training/\(thisPK)"
        let http = FHttp()
        http.addParam("trainingDate", trainingDate)
        return await http.post(url, blobModel, UserTrainingModel.self)
    }
}
