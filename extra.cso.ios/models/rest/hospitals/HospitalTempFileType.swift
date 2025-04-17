enum HospitalTempFileType: String, Decodable, CaseIterable {
    case TAXPAYER
    
    var desc: String {
        switch self {
        case HospitalTempFileType.TAXPAYER: return "taxpayer_desc"
        }
    }
}
