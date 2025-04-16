@propertyWrapper
class FallbackDataClass<T: Decodable & PDefaultInitializable>: Decodable {
    var wrappedValue: T
    init() {
        wrappedValue = T()
    }
    required init(from decoder: Decoder) throws {
        do {
            self.wrappedValue = try T(from: decoder)
        } catch {
            self.wrappedValue = T()
        }
    }
}

