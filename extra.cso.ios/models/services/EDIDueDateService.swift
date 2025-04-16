import Foundation

class EDIDueDateService: PEDIDueDateRepository {
    var baseUrl: String
    init(_ url: String) {
        baseUrl = url
    }
    func getList(_ date: String, _ isYear: Bool) async -> RestResultT<[EDIPharmaDueDateModel]> {
        let url = "\(baseUrl)/list"
        let http = FHttp()
        http.addParam("date", date)
        http.addParam("isYear", isYear.toString)
        return await http.get(url, [EDIPharmaDueDateModel].self)
    }
    func getListRange(_ startDate: String, _ endDate: String) async -> RestResultT<[EDIPharmaDueDateModel]> {
        let url = "\(baseUrl)/list/range"
        let http = FHttp()
        http.addParam("startDate", startDate)
        http.addParam("endDate", endDate)
        return await http.get(url, [EDIPharmaDueDateModel].self)
    }
}
