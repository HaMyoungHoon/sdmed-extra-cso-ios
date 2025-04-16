@propertyWrapper
struct FallbackDouble: Decodable {
    var wrappedValue: Double
    init() {
        wrappedValue = 0.0
    }
    init(data: Double) {
        wrappedValue = data
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let double = try? container.decode(Double.self) {
            wrappedValue = double
        } else if let string = try? container.decode(String.self),
                  let parsed = Double(string) {
            wrappedValue = parsed
        } else if let int = try? container.decode(Int.self) {
            wrappedValue = int.toDouble
        } else {
            wrappedValue = 0.0
        }
    }
}
