protocol PEDIRequestRepository {
    func getApplyDateList() async -> RestResultT<[ExtraEDIApplyDateResponse]>
    func getHospitalList(_ applyDate: String) async -> RestResultT<[EDIHosBuffModel]>
    func getPharmaList() async -> RestResultT<[EDIPharmaBuffModel]>
    func getPharmaList(_ hosPK: String, _ applyDate: String) async -> RestResultT<[EDIPharmaBuffModel]>
    func getMedicineList(_ hosPK: String, _ pharmaPK: [String]) async -> RestResultT<[EDIMedicineBuffModel]>
    func postData(_ ediUploadModel: EDIUploadModel) async -> RestResultT<EDIUploadModel>
    func postNewData(_ ediUploadModel: EDIUploadModel) async -> RestResultT<EDIUploadModel>
}
