protocol PRestPage {
    associatedtype T: Decodable
    var content: T? { get set }
    var pageable: Pageable { get set }
    var first: Bool { get set }
    var last: Bool { get set }
    var empty: Bool { get set }
    var size: Int { get set }
    var number: Int { get set }
    var numberOfElements: Int { get set }
    var totalElements: Int { get set }
    var totalPages: Int { get set }
}
