import Foundation

@propertyWrapper
struct FallbackDateNil: Decodable {
    var wrappedValue: Date?
    static var dateFormatter: DateFormatter = {
        let ret = DateFormatter()
        ret.dateFormat = "yyyy-MM-dd"
        return ret
    }()
    static var dateFormatter2: DateFormatter = {
        let ret = DateFormatter()
        ret.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return ret
    }()
    init() {
        wrappedValue = Date()
    }
    init(data: Date) {
        wrappedValue = data
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let date = try? container.decode(Date.self) {
            wrappedValue = date
        } else if let string = try? container.decode(String.self) {
            if let date = FallbackDate.dateFormatter.date(from: string) {
                wrappedValue = date
            } else if let date = FallbackDate.dateFormatter2.date(from: string) {
                wrappedValue = date
            } else {
                wrappedValue = Date()
            }
        } else {
            wrappedValue = Date()
        }
    }
}
