@propertyWrapper
class FallbackString: Decodable {
    var wrappedValue: String
    init() {
        wrappedValue = ""
    }
    init(data: String) {
        wrappedValue = data
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            wrappedValue = string
        } else if let int = try? container.decode(Int.self) {
            wrappedValue = int.toString
        } else if let double = try? container.decode(Double.self) {
            wrappedValue = double.toString
        } else {
            wrappedValue = ""
        }
    }
}
