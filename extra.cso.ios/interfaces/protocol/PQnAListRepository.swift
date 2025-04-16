protocol PQnAListRepository {
    func getList(_ page: Int, _ size: Int) async -> RestResultT<RestPage<[QnAHeaderModel]>>
    func getLike(_ searchString: String, _ page: Int, _ size: Int) async -> RestResultT<RestPage<[QnAHeaderModel]>>
    func getHeaderData(_ thisPK: String) async -> RestResultT<QnAHeaderModel>
    func getContentData(_ thisPK: String) async -> RestResultT<QnAContentModel>
    func postData(_ title: String, _ qnaContentModel: QnAContentModel) async -> RestResultT<QnAHeaderModel>
    func postReply(_ thisPK: String, _ qnaReplyModel: QnAReplyModel) async -> RestResultT<QnAReplyModel>
    func putData(_ thisPK: String) async -> RestResultT<QnAHeaderModel>
}
