class HospitalTempService: PHospitalTempRepository {
    var baseUrl: String
    init(_ url: String) {
        baseUrl = url
    }
    func getData(_ thisPK: String) async -> RestResultT<HospitalTempModel> {
        let url = "\(baseUrl)/data/\(thisPK)"
        let http = FHttp()
        return await http.get(url, HospitalTempModel.self)
    }
    func getListSearch(_ searchString: String) async -> RestResultT<[HospitalTempModel]> {
        let url = "\(baseUrl)/list/search"
        let http = FHttp()
        http.addParam("searchString", searchString)
        return await http.get(url, [HospitalTempModel].self)
    }
    func getListNearby(_ latitude: Double, _ longitude: Double, _ distance: Int = 1000) async -> RestResultT<[HospitalTempModel]> {
        let url = "\(baseUrl)/list/nearby"
        let http = FHttp()
        http.addParam("latitude", latitude.toString)
        http.addParam("longitude", longitude.toString)
        http.addParam("distance", distance.toString)
        return await http.get(url, [HospitalTempModel].self)
    }
    func getPharmacyListNearby(_ latitude: Double, _ longitude: Double, _ distance: Int = 1000) async -> RestResultT<[PharmacyTempModel]> {
        let url = "\(baseUrl)/list/nearby/pharmacy"
        let http = FHttp()
        http.addParam("latitude", latitude.toString)
        http.addParam("longitude", longitude.toString)
        http.addParam("distance", distance.toString)
        return await http.get(url, [PharmacyTempModel].self)
    }
}
