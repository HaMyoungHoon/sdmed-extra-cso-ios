import Foundation

class HospitalTempModel: FDataModelClass<HospitalTempModel.ClickEvent>, Decodable {
    @FallbackString var thisPK: String
    @FallbackString var code: String
    @FallbackString var orgName: String
    @FallbackEnum var hospitalTempTypeCode: HospitalTempTypeCode
    @FallbackEnum var hospitalTempMetroCode: HospitalTempMetroCode
    @FallbackEnum var hospitalTempCityCode: HospitalTempCityCode
    @FallbackString var hospitalTempLocalName: String
    @FallbackInt var zipCode: Int
    @FallbackString var address: String
    @FallbackString var phoneNumber: String
    @FallbackString var websiteUrl: String
    @FallbackString var openDate: String
    @FallbackDouble var longitude: Double
    @FallbackDouble var latitude: Double
    @FallbackDataClass var fileList: [HospitalTempFileModel]
    var markerType: MarkerClusterType = MarkerClusterType.HOSPITAL

    @Published var isSelect = false
    
    func toMarkerClusterDataModel() -> MarkerClusterDataModel {
        let ret = MarkerClusterDataModel()
        ret.thisPK = thisPK
        ret.orgName = orgName
        ret.address = address
        ret.phoneNumber = phoneNumber
        ret.websiteUrl = websiteUrl
        ret.latitude = latitude
        ret.longitude = longitude
        ret.resDrawableId = FAppImage.hospitalRedNamed
        ret.markerType = markerType
        return ret
    }
    func parse(_ data: MarkerClusterDataModel) -> HospitalTempModel {
        self.thisPK = data.thisPK
        self.orgName = data.orgName
        self.address = data.address
        self.phoneNumber = data.phoneNumber
        self.websiteUrl = data.websiteUrl
        self.latitude = data.latitude
        self.longitude = data.longitude
        return self
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, code, orgName, hospitalTempTypeCode, hospitalTempMetroCode, hospitalTempCityCode, hospitalTempLocalName, zipCode, address, phoneNumber, websiteUrl, openDate, longitude, latitude, fileList
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
        case WEB_SITE = 1
        case PHONE_NUMBER = 2
    }
}
