import Foundation

class EDIHosBuffModel: FDataModelClass<EDIHosBuffModel.ClickEvent>, Decodable {
    @FallbackString var thisPK: String
    @FallbackString var orgName: String
    @FallbackDataClass var pharmaList: [EDIPharmaBuffModel]

    @Published var isSelect = false
    
    enum CodingKeys: String, CodingKey {
        case thisPK, orgName, pharmaList
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
