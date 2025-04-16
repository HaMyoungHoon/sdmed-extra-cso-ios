class RestPage<T: Decodable>: PRestPage, Decodable {
    typealias T = T
    var content: T? = nil
    var pageable: Pageable = Pageable()
    var first: Bool = false
    var last: Bool = false
    var empty: Bool = false
    var size: Int = 0
    var number: Int = 0
    var numberOfElements: Int = 0
    var totalElements: Int = 0
    var totalPages: Int = 0
}
