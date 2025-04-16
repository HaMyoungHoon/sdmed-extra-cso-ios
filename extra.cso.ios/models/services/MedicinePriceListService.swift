class MedicinePriceListService: PMedicinePriceListRepository {
    var baseUrl: String
    init(_ url: String) {
        baseUrl = url
    }
    func getList(_ page: Int, _ size: Int) async -> RestResultT<RestPage<[ExtraMedicinePriceResponse]>> {
        let url = "\(baseUrl)/list/paging"
        let http = FHttp()
        http.addParam("page", page.toString)
        http.addParam("size", size.toString)
        return await http.get(url, RestPage<[ExtraMedicinePriceResponse]>.self)
    }
    func getLike(_ searchString: String, _ page: Int, _ size: Int) async -> RestResultT<RestPage<[ExtraMedicinePriceResponse]>> {
        let url = "\(baseUrl)/like/paging"
        let http = FHttp()
        http.addParam("searchString", searchString)
        http.addParam("page", page.toString)
        http.addParam("size", size.toString)
        return await http.get(url, RestPage<[ExtraMedicinePriceResponse]>.self)
    }
}
