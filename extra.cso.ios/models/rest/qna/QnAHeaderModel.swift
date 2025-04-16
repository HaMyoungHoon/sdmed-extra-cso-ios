import Foundation

class QnAHeaderModel: FDataModelClass<QnAHeaderModel.ClickEvent>, Decodable {
    @FallbackString var thisPK: String
    @FallbackString var userPK: String
    @FallbackString var name: String
    @FallbackString var title: String
    @FallbackDate var regDate: Date
    @FallbackEnum var qnaState: QnAState
    
    enum CodingKeys: String, CodingKey {
        case thisPK, userPK, name, title, regDate, qnaState
    }
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
