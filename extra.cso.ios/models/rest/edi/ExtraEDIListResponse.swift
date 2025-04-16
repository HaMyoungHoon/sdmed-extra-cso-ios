import SwiftUI

class ExtraEDIListResponse: FDataModelClass<ExtraEDIListResponse.ClickEvent>, Decodable {
    @FallbackString var thisPK: String
    @FallbackString var year: String
    @FallbackString var month: String
    @FallbackString var orgName: String
    @FallbackString var tempHospitalPK: String
    @FallbackString var tempOrgName: String
    @FallbackEnum var ediState: EDIState
    @FallbackEnum var ediType: EDIType
    @FallbackString var regDate: String
    @FallbackDataClass var pharmaList: [String]
    
    @Published var isSelected: Bool = false
    var tempOrgString: String {
        return "(\(_tempOrgName.wrappedValue))"
    }
    var isDefault: Bool {
        return ediType == EDIType.DEFAULT
    }
    var getRegDateString: String {
        return FDateTime().setThis(regDate).toString("yyyy-MM")
    }
    var ediColor: Color {
        return ediState.parseEDIColor()
    }
    var ediBackColor: Color {
        return ediState.parseEDIBackColor()
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, year, month, orgName, tempHospitalPK, tempOrgName, ediState, ediType, regDate, pharmaList
    }
    enum ClickEvent: Int, CaseIterable {
        case OPEN = 0
    }
}

