@propertyWrapper
struct FallbackEnum<T: RawRepresentable & Decodable>: Decodable where T.RawValue: Decodable {
    var wrappedValue: T
    init() {
        if let first = Mirror(reflecting: T.self).children.first?.value as? T {
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
            if let first = Mirror(reflecting: T.self).children.first?.value as? T {
                wrappedValue = first
            } else {
                fatalError("FallbackEnum failed: \(T.self)")
            }
        }
    }
}
