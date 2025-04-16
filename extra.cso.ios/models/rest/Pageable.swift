class Pageable: PPageable, Decodable {
    @FallbackInt var pageNumber: Int
    @FallbackInt var pageSize: Int
    
    enum CodingKeys: String, CodingKey {
        case pageNumber, pageSize
    }
}
