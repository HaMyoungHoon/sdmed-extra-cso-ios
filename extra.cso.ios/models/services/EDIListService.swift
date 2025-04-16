class EDIListService: PEDIListRepository {
    var baseUrl: String
    init(_ url: String) {
        baseUrl = url
    }
    func getList(_ startDate: String, _ endDate: String) async -> RestResultT<[ExtraEDIListResponse]> {
        let url = "\(baseUrl)/list"
        let http = FHttp()
        http.addParam("startDate", startDate)
        http.addParam("endDate", endDate)
        return await http.get(url, [ExtraEDIListResponse].self)
    }
    func getData(_ thisPK: String) async -> RestResultT<ExtraEDIDetailResponse> {
        let url = "\(baseUrl)/data/\(thisPK)"
        let http = FHttp()
        return await http.get(url, ExtraEDIDetailResponse.self)
    }
    func postPharmaFile(_ thisPK: String, _ ediPharmaPK: String, _ ediUploadPharmaFileModel: [EDIUploadPharmaFileModel]) async -> RestResultT<[EDIUploadPharmaFileModel]> {
        let url = "\(baseUrl)/file/\(thisPK)/pharma/\(ediPharmaPK)"
        let http = FHttp()
        return await http.post(url, ediUploadPharmaFileModel, [EDIUploadPharmaFileModel].self)
    }
    func deleteEDIPharmaFile(_ thisPK: String) async -> RestResultT<EDIUploadPharmaFileModel> {
        let url = "\(baseUrl)/data/pharma/file/\(thisPK)"
        let http = FHttp()
        return await http.delete(url, EDIUploadPharmaFileModel.self)
    }
}
