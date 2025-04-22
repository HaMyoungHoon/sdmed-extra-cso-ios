class FConstants {
    static let AUTH_TOKEN = "token"
    static let NOTIFY_INDEX = "notifyIndex"
    static let NOTIFY_PK = "notifyPK"
    static let GOOGLE_MAP_STYLE_INDEX = "googleMapStyleIndex"
    static let MULTI_LOGIN_TOKEN = "multiLoginToken"
    
    static let REST_API_URL = "https://back-cso.sdmed.co.kr"
    static let REST_API_COMMON = "common"
    static let REST_API_MQTT = "mqtt"
    static let REST_API_EDI_LIST = "extra/ediList"
    static let REST_API_EDI_REQUEST = "extra/ediRequest"
    static let REST_API_EDI_DUE_DATE = "extra/ediDueDate"
    static let REST_API_HOSPITAL_TEMP = "extra/hospitalTemp"
    static let REST_API_MY_INFO = "extra/myInfo"
    static let REST_API_QNA_LIST = "extra/qnaList"
    static let REST_API_MEDICINE_PRICE_LIST = "extra/medicinePriceList"
    
    static let CLAIMS_INDEX = "index"
    static let CLAIMS_NAME = "name"
    static let CLAIMS_EXP = "exp"
    static let CLAIMS_SUB = "sub"
    
    static let DEF_LATITUDE = 37.6618
    static let DEF_LONGITUDE = 126.76905
    static let DEF_ZOOM = 15.0
    
    static let MAX_FILE_SIZE = 10 * 1024 * 1024
    
    static let REGEX_NUMBER_REPLACE = "[^0-9]"
    static let REGEX_CHECK_PASSWORD_0 = "^(?=.*[A-Za-z가-힣ㄱ-하-ㅣ!@#$%^&*()])(?=.*\\d)[A-Za-z가-힣ㄱ-하-ㅣ\\d!@#$%^&*()]{8,20}$"
}
