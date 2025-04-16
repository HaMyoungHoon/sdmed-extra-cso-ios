class FServiceFactory {
    static func createAzureService() -> PAzureBlobRepository {
        return AzureBlobService()
    }
    static func createCommonService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_QNA_LIST)") -> PCommonRepository {
        return CommonService(url)
    }
    static func createEDIDueDateService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_QNA_LIST)") -> PEDIDueDateRepository {
        return EDIDueDateService(url)
    }
    static func createEDIListService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_QNA_LIST)") -> PEDIListRepository {
        return EDIListService(url)
    }
    static func createHospitalTempService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_QNA_LIST)") -> PHospitalTempRepository {
        return HospitalTempService(url)
    }
    static func createMedicinePriceListService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_QNA_LIST)") -> PMedicinePriceListRepository {
        return MedicinePriceListService(url)
    }
    static func createMqttService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_QNA_LIST)") -> PMqttRepository {
        return MqttService(url)
    }
    static func createMyInfoService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_QNA_LIST)") -> PMyInfoRepository {
        return MyInfoService(url)
    }
    static func createQnAListService(_ url: String = "\(FConstants.REST_API_URL)/\(FConstants.REST_API_QNA_LIST)") -> PQnAListRepository {
        return QnAListService(url)
    }
}
