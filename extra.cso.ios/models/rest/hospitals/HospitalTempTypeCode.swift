
enum HospitalTempTypeCode: String, Decodable {
    case CODE_00
    case CODE_01
    case CODE_11
    case CODE_21
    case CODE_28
    case CODE_29
    case CODE_31
    case CODE_41
    case CODE_51
    case CODE_61
    case CODE_71
    case CODE_72
    case CODE_73
    case CODE_74
    case CODE_75
    case CODE_81
    case CODE_91
    case CODE_92
    case CODE_93
    case CODE_94
    case CODE_AA
    
    var code: String {
        switch self {
        case HospitalTempTypeCode.CODE_00: return "00"
        case HospitalTempTypeCode.CODE_01: return "01"
        case HospitalTempTypeCode.CODE_11: return "11"
        case HospitalTempTypeCode.CODE_21: return "21"
        case HospitalTempTypeCode.CODE_28: return "28"
        case HospitalTempTypeCode.CODE_29: return "29"
        case HospitalTempTypeCode.CODE_31: return "31"
        case HospitalTempTypeCode.CODE_41: return "41"
        case HospitalTempTypeCode.CODE_51: return "51"
        case HospitalTempTypeCode.CODE_61: return "61"
        case HospitalTempTypeCode.CODE_71: return "71"
        case HospitalTempTypeCode.CODE_72: return "72"
        case HospitalTempTypeCode.CODE_73: return "73"
        case HospitalTempTypeCode.CODE_74: return "74"
        case HospitalTempTypeCode.CODE_75: return "75"
        case HospitalTempTypeCode.CODE_81: return "81"
        case HospitalTempTypeCode.CODE_91: return "91"
        case HospitalTempTypeCode.CODE_92: return "92"
        case HospitalTempTypeCode.CODE_93: return "93"
        case HospitalTempTypeCode.CODE_94: return "94"
        case HospitalTempTypeCode.CODE_AA: return "AA"
        }
    }
    var desc: String {
        switch self {
        case HospitalTempTypeCode.CODE_00: return "미지정"
        case HospitalTempTypeCode.CODE_01: return "상급종합병원"
        case HospitalTempTypeCode.CODE_11: return "종합병원"
        case HospitalTempTypeCode.CODE_21: return "병원"
        case HospitalTempTypeCode.CODE_28: return "요양병원"
        case HospitalTempTypeCode.CODE_29: return "정신병원"
        case HospitalTempTypeCode.CODE_31: return "의원"
        case HospitalTempTypeCode.CODE_41: return "치과병원"
        case HospitalTempTypeCode.CODE_51: return "치과의원"
        case HospitalTempTypeCode.CODE_61: return "조산원"
        case HospitalTempTypeCode.CODE_71: return "보건소"
        case HospitalTempTypeCode.CODE_72: return "보건지소"
        case HospitalTempTypeCode.CODE_73: return "보건진료소"
        case HospitalTempTypeCode.CODE_74: return "모자보건센타"
        case HospitalTempTypeCode.CODE_75: return "보건의료원"
        case HospitalTempTypeCode.CODE_81: return "약국"
        case HospitalTempTypeCode.CODE_91: return "한방종합병원"
        case HospitalTempTypeCode.CODE_92: return "한방병원"
        case HospitalTempTypeCode.CODE_93: return "한의원"
        case HospitalTempTypeCode.CODE_94: return "한약방"
        case HospitalTempTypeCode.CODE_AA: return "병의원"
        }
    }
}
