import SwiftUI

class EDIPharmaDueDateModel: FDataModelClass<EDIPharmaDueDateModel.ClickEvent>, Decodable {
    @FallbackString var thisPK: String
    @FallbackString var pharmaPK: String
    @FallbackString var orgName: String
    @FallbackString var year: String
    @FallbackString var month: String
    @FallbackString var day: String
    @FallbackString var regDate: String
    
    var yearMonthDay: String {
        return "\(year)-\(month)-\(day)"
    }
    var dayOfTheWeek: String {
        return FDateTime().setThis("\(year)-\(month)-\(day)", FExtensions.ins.getLocalize()).getLocalizeDayOfWeek(false)
    }
    var parseColor: Color {
        return FDateTime().setThis("\(year)-\(month)-\(day)", FExtensions.ins.getLocalize()).dayOfWeek.parseColor()
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
