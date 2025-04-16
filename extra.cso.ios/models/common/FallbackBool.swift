@propertyWrapper
struct FallbackBool: Decodable {
    var wrappedValue: Bool
    init() {
        wrappedValue = false
    }
    init(data: Bool) {
        wrappedValue = data
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let bool = try? container.decode(Bool.self) {
            wrappedValue = bool
        } else if let string = try? container.decode(String.self) {
            let lowered = string.lowercased()
            wrappedValue = ["true", "1"].contains(lowered)
        } else if let int = try? container.decode(Int.self) {
            wrappedValue = int != 0
        } else {
            wrappedValue = false
        }
    }
}
