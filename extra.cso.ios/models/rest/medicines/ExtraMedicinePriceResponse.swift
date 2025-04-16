class ExtraMedicinePriceResponse: FDataModelClass<ExtraMedicinePriceResponse.ClickEvent>, Decodable {
    @FallbackString var thisPK: String
    @FallbackString var mainIngredientCode: String
    @FallbackString var mainIngredientName: String
    @FallbackString var clientName: String
    @FallbackString var makerName: String
    @FallbackString var orgName: String
    @FallbackString var kdCode: String
    @FallbackInt var customPrice: Int
    @FallbackInt var maxPrice: Int
    @FallbackString var standard: String
    @FallbackString var etc1: String
    
    enum CodingKeys: String, CodingKey {
        case thisPK, mainIngredientCode, mainIngredientName, clientName, makerName, orgName, kdCode, customPrice, maxPrice, standard, etc1
    }
    
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
}
