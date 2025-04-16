@propertyWrapper
struct FallbackInt: Decodable {
    var wrappedValue: Int
    init() {
        wrappedValue = 0
    }
    init(data: Int) {
        wrappedValue = data
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let int = try? container.decode(Int.self) {
            wrappedValue = int
        } else if let string = try? container.decode(String.self),
                  let parsed = Int(string) {
            wrappedValue = parsed
        } else {
            wrappedValue = 0
        }
    }
}
