class ExtraEDIApplyDateResponse: FDataModelClass<ExtraEDIApplyDateResponse.ClickEvent>, Decodable {
    @FallbackString var thisPK: String
    @FallbackString var year: String
    @FallbackString var month: String
    
    enum CodingKeys: String, CodingKey {
        case thisPK, year, month
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
