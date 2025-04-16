protocol PEDIListRepository {
    func getList(_ startDate: String, _ endDate: String) async -> RestResultT<[ExtraEDIListResponse]>
    func getData(_ thisPK: String) async -> RestResultT<ExtraEDIDetailResponse>
    func postPharmaFile(_ thisPK: String, _ ediPharmaPK: String, _ ediUploadPharmaFileModel: [EDIUploadPharmaFileModel]) async -> RestResultT<[EDIUploadPharmaFileModel]>
    func deleteEDIPharmaFile(_ thisPK: String) async -> RestResultT<EDIUploadPharmaFileModel>
}
