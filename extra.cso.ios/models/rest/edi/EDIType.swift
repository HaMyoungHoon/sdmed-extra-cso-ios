enum EDIType: String, Codable, CaseIterable {
    case DEFAULT
    case NEW
    case TRANSFER
    
    var index: Int {
        switch self {
        case EDIType.DEFAULT: return 0
        case EDIType.NEW: return 1
        case EDIType.TRANSFER: return 2
        }
    }
    var desc: String {
        switch self {
        case EDIType.DEFAULT: return "edi_type_default"
        case EDIType.NEW: return "edi_type_new"
        case EDIType.TRANSFER: return "edi_type_transfer"
        }
    }
}
