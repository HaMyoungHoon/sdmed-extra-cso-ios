class FServiceFactory {
    static func createAzureService() -> PAzureBlobRepository {
        return AzureBlobService()
    }
    static func createCommonService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_COMMON)") -> PCommonRepository {
        return CommonService(url)
    }
    static func createEDIDueDateService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_EDI_DUE_DATE)") -> PEDIDueDateRepository {
        return EDIDueDateService(url)
    }
    static func createEDIListService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_EDI_LIST)") -> PEDIListRepository {
        return EDIListService(url)
    }
    static func createEDIRequestService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_EDI_REQUEST)") -> PEDIRequestRepository {
        return EDIRequestService(url)
    }
    static func createHospitalTempService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_HOSPITAL_TEMP)") -> PHospitalTempRepository {
        return HospitalTempService(url)
    }
    static func createMedicinePriceListService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_MEDICINE_PRICE_LIST)") -> PMedicinePriceListRepository {
        return MedicinePriceListService(url)
    }
    static func createMqttService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_MQTT)") -> PMqttRepository {
        return MqttService(url)
    }
    static func createMyInfoService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_MY_INFO)") -> PMyInfoRepository {
        return MyInfoService(url)
    }
    static func createQnAListService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_QNA_LIST)") -> PQnAListRepository {
        return QnAListService(url)
    }
    
    static func createNotificationService() -> FNotificationService {
        return notificationService
    }
    static func createMqttBackgroundService() -> FMqttBackgroundService {
        return mqttBackgroundService
    }
    
    static func createBackgroundEDIFileUploadService() -> FBackgroundEDIFileUploadService {
        return backgroundEDIFileUploadService
    }
    static func createBackgroundEDIRequestNewUploadService() -> FBackgroundEDIRequestNewUploadService {
        return backgroundEDIRequestNewUploadService
    }
    static func createBackgroundEDIRequestUploadService() -> FBackgroundEDIRequestUploadService {
        return backgroundEDIRequestUploadService
    }
    static func createBackgroundQnAUploadService() -> FBackgroundQnAUploadService {
        return backgroundQnAUploadService
    }
    static func createBackgroundUserFileUploadService() -> FBackgroundUserFileUploadService {
        return backgroundUserFileUploadService
    }

    static private let notificationService = FNotificationService()
    static private let mqttBackgroundService = FMqttBackgroundService()
    
    static private let backgroundEDIFileUploadService = FBackgroundEDIFileUploadService()
    static private let backgroundEDIRequestNewUploadService = FBackgroundEDIRequestNewUploadService()
    static private let backgroundEDIRequestUploadService = FBackgroundEDIRequestUploadService()
    static private let backgroundQnAUploadService = FBackgroundQnAUploadService()
    static private let backgroundUserFileUploadService = FBackgroundUserFileUploadService()
}
