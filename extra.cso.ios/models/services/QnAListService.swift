class QnAListService: PQnAListRepository {
    var baseUrl: String
    init(_ url: String) {
        baseUrl = url
    }
    func getList(_ page: Int, _ size: Int) async -> RestResultT<RestPage<[QnAHeaderModel]>> {
        let url = "\(baseUrl)/list/paging"
        let http = FHttp()
        http.addParam("page", page.toString)
        http.addParam("size", size.toString)
        return await http.get(url, RestPage<[QnAHeaderModel]>.self)
    }
    func getLike(_ searchString: String, _ page: Int, _ size: Int) async -> RestResultT<RestPage<[QnAHeaderModel]>> {
        let url = "\(baseUrl)/like/paging"
        let http = FHttp()
        http.addParam("searchString", searchString)
        http.addParam("page", page.toString)
        http.addParam("size", size.toString)
        return await http.get(url, RestPage<[QnAHeaderModel]>.self)
    }
    func getHeaderData(_ thisPK: String) async -> RestResultT<QnAHeaderModel> {
        let url = "\(baseUrl)/data/header/\(thisPK)"
        let http = FHttp()
        return await http.get(url, QnAHeaderModel.self)
    }
    func getContentData(_ thisPK: String) async -> RestResultT<QnAContentModel> {
        let url = "\(baseUrl)/data/content/\(thisPK)"
        let http = FHttp()
        return await http.get(url, QnAContentModel.self)
    }
    func postData(_ title: String, _ qnaContentModel: QnAContentModel) async -> RestResultT<QnAHeaderModel> {
        let url = "\(baseUrl)/data"
        let http = FHttp()
        http.addParam("title", title)
        return await http.post(url, qnaContentModel, QnAHeaderModel.self)
    }
    func postReply(_ thisPK: String, _ qnaReplyModel: QnAReplyModel) async -> RestResultT<QnAReplyModel> {
        let url = "\(baseUrl)/data/\(thisPK)"
        let http = FHttp()
        return await http.post(url, qnaReplyModel, QnAReplyModel.self)
    }
    func putData(_ thisPK: String) async -> RestResultT<QnAHeaderModel> {
        let url = "\(baseUrl)/data/\(thisPK)"
        let http = FHttp()
        return await http.put(url, QnAHeaderModel.self)
    }
}
