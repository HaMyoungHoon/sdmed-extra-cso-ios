import SwiftUI

enum EDIState: String, Codable {
    case None
    case OK
    case Reject
    case Pending
    case Partial
    
    var index: Int {
        switch self {
        case EDIState.None: return 0
        case EDIState.OK: return 1
        case EDIState.Reject: return 2
        case EDIState.Pending: return 3
        case EDIState.Partial: return 4
        }
    }
    var desc: String {
        switch self {
        case EDIState.None: return "edi_state_none"
        case EDIState.OK: return "edi_state_ok"
        case EDIState.Reject: return "edi_state_reject"
        case EDIState.Pending: return "edi_state_pending"
        case EDIState.Partial: return "edi_state_partial"
        }
    }
    func isEditable() -> Bool {
        return !(self == EDIState.OK || self == EDIState.Reject)
    }
    
    func parseEDIColor() -> Color {
        switch self {
        case EDIState.None: return FAppColor.foreground
        case EDIState.OK: return FAppColor.ediStateOk
        case EDIState.Reject: return FAppColor.ediStateReject
        case EDIState.Pending: return FAppColor.ediStatePending
        case EDIState.Partial: return FAppColor.ediStatePartial
        }
    }
    func parseEDIBackColor() -> Color {
        switch self {
        case EDIState.None: return FAppColor.background
        case EDIState.OK: return FAppColor.ediBackStateOk
        case EDIState.Reject: return FAppColor.ediBackStateReject
        case EDIState.Pending: return FAppColor.ediBackStatePending
        case EDIState.Partial: return FAppColor.ediBackStatePartial
        }
    }
}
