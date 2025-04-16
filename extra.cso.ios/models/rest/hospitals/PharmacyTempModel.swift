import Foundation

class PharmacyTempModel: FDataModelClass<PharmacyTempModel.ClickEvent>, Decodable {
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
    @FallbackString var openDate: String
    @FallbackDouble var longitude: Double
    @FallbackDouble var latitude: Double
    var markerType: MarkerClusterType = MarkerClusterType.PHARMACY
    
    @Published var isSelect = false
    
    func toMarkerClusterDataModel() -> MarkerClusterDataModel {
        let ret = MarkerClusterDataModel()
        ret.thisPK = thisPK
        ret.orgName = orgName
        ret.address = address
        ret.phoneNumber = phoneNumber
        ret.latitude = latitude
        ret.longitude = longitude
        ret.resDrawableId = FAppImage.pharmacyGreenNamed
        ret.markerType = markerType
        
        return ret
    }
    func parse(_ data: MarkerClusterDataModel) -> PharmacyTempModel {
        self.thisPK = data.thisPK
        self.orgName = data.orgName
        self.address = data.address
        self.phoneNumber = data.phoneNumber
        self.latitude = data.latitude
        self.longitude = data.longitude
        return self
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, code, orgName, hospitalTempTypeCode, hospitalTempMetroCode, hospitalTempCityCode, hospitalTempLocalName, zipCode, address, phoneNumber, openDate, longitude, latitude
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
        case PHONE_NUMBER = 1
    }
}
