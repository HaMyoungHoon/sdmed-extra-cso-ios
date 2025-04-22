enum NotifyIndex: Int, CaseIterable {
    case UNKNOWN = 0
    case EDI_UPLOAD = 1
    case EDI_FILE_UPLOAD = 2
    case EDI_FILE_REMOVE = 3
    case EDI_RESPONSE = 4
    case QNA_UPLOAD = 5
    case QNA_FILE_UPLOAD = 6
    case QNA_RESPONSE = 7
    case USER_FILE_UPLOAD = 8
    
    func getViewIndex() -> Int {
        switch self {
        case NotifyIndex.UNKNOWN: return 0
        case NotifyIndex.EDI_UPLOAD: return 0
        case NotifyIndex.EDI_FILE_UPLOAD: return 0
        case NotifyIndex.EDI_FILE_REMOVE: return 0
        case NotifyIndex.EDI_RESPONSE: return 0
        case NotifyIndex.QNA_UPLOAD: return 3
        case NotifyIndex.QNA_FILE_UPLOAD: return 3
        case NotifyIndex.QNA_RESPONSE: return 3
        case NotifyIndex.USER_FILE_UPLOAD: return 4
        }
    }
    
    static func parseIndex(_ index: Int?) -> NotifyIndex {
        return NotifyIndex(rawValue: index ?? 0) ?? NotifyIndex.UNKNOWN
    }
}
