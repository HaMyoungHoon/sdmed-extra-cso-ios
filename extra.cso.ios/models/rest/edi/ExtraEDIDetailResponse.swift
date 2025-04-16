import SwiftUI

class ExtraEDIDetailResponse: FDataModelClass<ExtraEDIDetailResponse.ClickEvent>, Decodable {
    @FallbackString var thisPK: String
    @FallbackString var year: String
    @FallbackString var month: String
    @FallbackString var orgName: String
    @FallbackString var tempHospitalPK: String
    @FallbackString var tempOrgName: String
    @FallbackEnum var ediState: EDIState
    @FallbackEnum var ediType: EDIType
    @FallbackString var regDate: String
    @FallbackDataClass var pharmaList: [ExtraEDIPharma]
    @FallbackDataClass var responseList: [ExtraEDIResponse]
    
    var orgViewName: String {
        if ediType == EDIType.DEFAULT {
            return orgName
        } else {
            return tempOrgName
        }
    }
    
    var ediColor: Color {
        return ediState.parseEDIColor()
    }
    var ediBackColor: Color {
        return ediState.parseEDIBackColor()
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, year, month, orgName, tempHospitalPK, tempOrgName, ediState, ediType, regDate, pharmaList, responseList
    }
    
    enum ClickEvent: Int, CaseIterable {
        case OPEN = 1
    }
}
