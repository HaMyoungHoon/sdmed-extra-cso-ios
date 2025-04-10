import Foundation

class FException {
    enum FThrow: Error {
        static func notDefined(_ msg: String) -> Error {
            NSError(domain: "App.NotDefiend", code: 1000, userInfo: [NSLocalizedDescriptionKey : msg])
        }
        static func nullPointer(_ msg: String) -> Error {
            NSError(domain: "App.NullPointer", code: 1, userInfo: [NSLocalizedDescriptionKey : msg])
        }
        static func format(_ msg: String) -> Error {
            NSError(domain: "App.Format", code: 2, userInfo: [NSLocalizedDescriptionKey : msg])
        }
        static func formatParameter(_ msg: String) -> Error {
            NSError(domain: "App.FormatParameter", code: 3, userInfo: [NSLocalizedDescriptionKey : msg])
        }
        static func overFlow(_ msg: String) -> Error {
            NSError(domain: "App.OverFlow", code: 4, userInfo: [NSLocalizedDescriptionKey : msg])
        }
    }
    enum FFatal {
        static func notDefined(_ msg: String) {
            fatalError("App.NotDefiend msg : \(msg)")
        }
        static func nullPointer(_ msg: String) -> Error {
            fatalError("App.NullPointer msg : \(msg)")
        }
        static func format(_ msg: String) -> Error {
            fatalError("App.Format msg : \(msg)")
        }
        static func formatParameter(_ msg: String) -> Error {
            fatalError("App.FormatParameter msg : \(msg)")
        }
        static func overFlow(_ msg: String) -> Error {
            fatalError("App.OverFlow msg : \(msg)")
        }
    }
    enum FAssert {
        static func notDefined(_ msg: String) {
            assertionFailure("App.NotDefiend msg : \(msg)")
        }
        static func nullPointer(_ msg: String) {
            assertionFailure("App.NullPointer msg : \(msg)")
        }
        static func format(_ msg: String) {
            assertionFailure("App.Format msg : \(msg)")
        }
        static func formatParameter(_ msg: String) {
            assertionFailure("App.FormatParameter msg : \(msg)")
        }
        static func overFlow(_ msg: String) {
            assertionFailure("App.OverFlow msg : \(msg)")
        }
    }
}
