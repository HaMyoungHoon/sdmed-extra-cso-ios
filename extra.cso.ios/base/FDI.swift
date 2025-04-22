class FDI {
    static let azureBlobService = FServiceFactory.createAzureService()
    static let commonService = FServiceFactory.createCommonService()
    static let ediDueDateService = FServiceFactory.createEDIDueDateService()
    static let ediListService = FServiceFactory.createEDIListService()
    static let hospitalTempService = FServiceFactory.createHospitalTempService()
    static let medicinePriceListSerivce = FServiceFactory.createMedicinePriceListService()
    static let mqttService = FServiceFactory.createMqttService()
    static let myInfoService = FServiceFactory.createMyInfoService()
    static let qnaListService = FServiceFactory.createQnAListService()
    
    static let notificationService = FServiceFactory.createNotificationService()
    static let mqttBackgroundService = FServiceFactory.createMqttBackgroundService()
    
    static let backgroundUserFileUploadService = FServiceFactory.createBackgroundUserFileUploadService()
}
