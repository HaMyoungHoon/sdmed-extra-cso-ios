protocol PRestResult: Decodable {
    var result: Bool? { get set }
    var code: Int? { get set }
    var msg: String? { get set }
}
