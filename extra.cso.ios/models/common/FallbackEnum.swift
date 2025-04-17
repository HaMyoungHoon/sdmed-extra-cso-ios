@propertyWrapper
struct FallbackEnum<T: RawRepresentable & Decodable>: Decodable where T.RawValue: Decodable, T: CaseIterable, T.AllCases: Collection {
    var wrappedValue: T
    init() {
        if let first = T.allCases.first {
            wrappedValue = first
        } else {
            fatalError("FallbackEnum failed: \(T.self)")
        }
    }
    init(data: T) {
        wrappedValue = data
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let raw = try? container.decode(T.RawValue.self),
           let value = T(rawValue: raw) {
            wrappedValue = value
        } else {
            if let first = T.allCases.first {
                wrappedValue = first
            } else {
                fatalError("FallbackEnum failed: \(T.self)")
            }
        }
    }
}
