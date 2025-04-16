protocol PHospitalTempRepository {
    func getData(_ thisPK: String) async -> RestResultT<HospitalTempModel>
    func getListSearch(_ searchString: String) async -> RestResultT<[HospitalTempModel]>
    func getListNearby(_ latitude: Double, _ longitude: Double, _ distance: Int) async -> RestResultT<[HospitalTempModel]>
    func getPharmacyListNearby(_ latitude: Double, _ longitude: Double, _ distance: Int) async -> RestResultT<[PharmacyTempModel]>
}
