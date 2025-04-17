import SwiftUI

enum QnAState: String, Decodable, CaseIterable {
    case None
    case OK
    case Recep
    case Reply
    
    func isEditable() -> Bool {
        return self == QnAState.Reply
    }
    
    var index: Int {
        switch self {
        case QnAState.None: return 0
        case QnAState.OK: return 1
        case QnAState.Recep: return 2
        case QnAState.Reply: return 3
        }
    }
    var desc: String {
        switch self {
        case QnAState.None: return "qna_state_none"
        case QnAState.OK: return "qna_state_ok"
        case QnAState.Recep: return "qna_state_recep"
        case QnAState.Reply: return "qna_state_reply"
        }
    }
    func parseQnAColor() -> Color {
        switch self {
        case QnAState.None: return FAppColor.foreground
        case QnAState.OK: return FAppColor.qnaStateOk
        case QnAState.Recep: return FAppColor.qnaStateRecep
        case QnAState.Reply: return FAppColor.qnaStateReply
        }
    }
    func parseQnABackColor() -> Color {
        switch self {
        case QnAState.None: return FAppColor.background
        case QnAState.OK: return FAppColor.qnaBackStateOk
        case QnAState.Recep: return FAppColor.qnaBackStateRecep
        case QnAState.Reply: return FAppColor.qnaBackStateReply
        }
    }
}
