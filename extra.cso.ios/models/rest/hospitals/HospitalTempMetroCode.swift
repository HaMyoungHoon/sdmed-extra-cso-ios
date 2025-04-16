
enum HospitalTempMetroCode: String, Decodable {
    case CODE_000000
    case CODE_110000
    case CODE_210000
    case CODE_220000
    case CODE_230000
    case CODE_240000
    case CODE_250000
    case CODE_260000
    case CODE_310000
    case CODE_320000
    case CODE_330000
    case CODE_340000
    case CODE_350000
    case CODE_360000
    case CODE_370000
    case CODE_380000
    case CODE_390000
    case CODE_410000
    
    var code: Int {
        switch self {
        case HospitalTempMetroCode.CODE_000000: return 0
        case HospitalTempMetroCode.CODE_110000: return 110000
        case HospitalTempMetroCode.CODE_210000: return 210000
        case HospitalTempMetroCode.CODE_220000: return 220000
        case HospitalTempMetroCode.CODE_230000: return 230000
        case HospitalTempMetroCode.CODE_240000: return 240000
        case HospitalTempMetroCode.CODE_250000: return 250000
        case HospitalTempMetroCode.CODE_260000: return 260000
        case HospitalTempMetroCode.CODE_310000: return 310000
        case HospitalTempMetroCode.CODE_320000: return 320000
        case HospitalTempMetroCode.CODE_330000: return 330000
        case HospitalTempMetroCode.CODE_340000: return 340000
        case HospitalTempMetroCode.CODE_350000: return 350000
        case HospitalTempMetroCode.CODE_360000: return 360000
        case HospitalTempMetroCode.CODE_370000: return 370000
        case HospitalTempMetroCode.CODE_380000: return 380000
        case HospitalTempMetroCode.CODE_390000: return 390000
        case HospitalTempMetroCode.CODE_410000: return 410000
        }
    }
    var desc: String {
        switch self {
        case HospitalTempMetroCode.CODE_000000: return "미지정"
        case HospitalTempMetroCode.CODE_110000: return "서울"
        case HospitalTempMetroCode.CODE_210000: return "부산"
        case HospitalTempMetroCode.CODE_220000: return "인천"
        case HospitalTempMetroCode.CODE_230000: return "대구"
        case HospitalTempMetroCode.CODE_240000: return "광주"
        case HospitalTempMetroCode.CODE_250000: return "대전"
        case HospitalTempMetroCode.CODE_260000: return "울산"
        case HospitalTempMetroCode.CODE_310000: return "경기"
        case HospitalTempMetroCode.CODE_320000: return "강원"
        case HospitalTempMetroCode.CODE_330000: return "충북"
        case HospitalTempMetroCode.CODE_340000: return "충남"
        case HospitalTempMetroCode.CODE_350000: return "전북"
        case HospitalTempMetroCode.CODE_360000: return "전남"
        case HospitalTempMetroCode.CODE_370000: return "경북"
        case HospitalTempMetroCode.CODE_380000: return "경남"
        case HospitalTempMetroCode.CODE_390000: return "제주"
        case HospitalTempMetroCode.CODE_410000: return "세종"
        }
    }
}
