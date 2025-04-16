class EDIRequestService: PEDIRequestRepository {
    var baseUrl: String
    init(_ url: String) {
        baseUrl = url
    }
    func getApplyDateList() async -> RestResultT<[ExtraEDIApplyDateResponse]> {
        let url = "\(baseUrl)/list/applyDate"
        let http = FHttp()
        return await http.get(url, [ExtraEDIApplyDateResponse].self)
    }
    func getHospitalList(_ applyDate: String) async -> RestResultT<[EDIHosBuffModel]> {
        let url = "\(baseUrl)/list/hospital"
        let http = FHttp()
        http.addParam("applyDate", applyDate)
        return await http.get(url, [EDIHosBuffModel].self)
    }
    func getPharmaList() async -> RestResultT<[EDIPharmaBuffModel]> {
        let url = "\(baseUrl)/list/pharma"
        let http = FHttp()
        return await http.get(url, [EDIPharmaBuffModel].self)
    }
    func getPharmaList(_ hosPK: String, _ applyDate: String) async -> RestResultT<[EDIPharmaBuffModel]> {
        let url = "\(baseUrl)/list/pharma/\(hosPK)"
        let http = FHttp()
        http.addParam( "applyDate", applyDate)
        return await http.get(url, [EDIPharmaBuffModel].self)
    }
    func getMedicineList(_ hosPK: String, _ pharmaPK: [String]) async -> RestResultT<[EDIMedicineBuffModel]> {
        let url = "\(baseUrl)/list/medicine/\(hosPK)"
        let http = FHttp()
        http.addParam("pharmaPK", pharmaPK.joined(separator: ","))
        return await http.get(url, [EDIMedicineBuffModel].self)
    }
    func postData(_ ediUploadModel: EDIUploadModel) async -> RestResultT<EDIUploadModel> {
        let url = "\(baseUrl)/data"
        let http = FHttp()
        return await http.post(url, ediUploadModel, EDIUploadModel.self)
    }
    func postNewData(_ ediUploadModel: EDIUploadModel) async -> RestResultT<EDIUploadModel> {
        let url = "\(baseUrl)/data/new"
        let http = FHttp()
        return await http.post(url, ediUploadModel, EDIUploadModel.self)
    }
}
