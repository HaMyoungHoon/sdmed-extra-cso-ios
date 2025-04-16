protocol PEDIDueDateRepository {
    func getList(_ date: String, _ isYear: Bool) async -> RestResultT<[EDIPharmaDueDateModel]>
    func getListRange(_ startDate: String, _ endDate: String) async -> RestResultT<[EDIPharmaDueDateModel]>
}
