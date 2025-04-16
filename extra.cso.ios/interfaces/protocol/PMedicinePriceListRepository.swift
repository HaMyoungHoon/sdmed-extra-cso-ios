protocol PMedicinePriceListRepository {
    func getList(_ page: Int, _ size: Int) async -> RestResultT<RestPage<[ExtraMedicinePriceResponse]>>
    func getLike(_ searchString: String, _ page: Int, _ size: Int) async -> RestResultT<RestPage<[ExtraMedicinePriceResponse]>>
}
