import Foundation

class FDataExceptionHandler {
    static func handleException<T>(_ error: Error) -> RestResultT<T> {
        if let urlError = error as? URLError {
            return RestResultT<T>.setFail(urlError.localizedDescription)
        } else if let decodingError = error as? DecodingError {
            return RestResultT<T>.setFail(decodingError.localizedDescription)
        } else {
            return RestResultT<T>.setFail(error.localizedDescription)
        }
    }
    static func handleException(_ error: Error) -> RestResult {
        if let urlError = error as? URLError {
            return RestResult.setFail(urlError.localizedDescription)
        } else if let decodingError = error as? DecodingError {
            return RestResult.setFail(decodingError.localizedDescription)
        } else {
            return RestResult.setFail(error.localizedDescription)
        }
    }
}
