enum HospitalTempFileType: String, Decodable {
    case TAXPAYER
    
    var desc: String {
        switch self {
        case HospitalTempFileType.TAXPAYER: return "taxpayer_desc"
        }
    }
}
