import Foundation

@propertyWrapper
struct FallbackDate: Decodable {
    var wrappedValue: Date
    static var dateFormatter: DateFormatter = {
        let ret = DateFormatter()
        ret.dateFormat = "yyyy-MM-dd"
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
        } else if let string = try? container.decode(String.self),
                  let date = FallbackDate.dateFormatter.date(from: string) {
            wrappedValue = date
        } else {
            wrappedValue = Date()
        }
    }
}
