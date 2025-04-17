import Foundation

class JWT {
    var jwt: String
    var claims: [String: Any]
    init(_ token: String) {
        self.jwt = token
        let segments = jwt.components(separatedBy: ".")
        guard segments.count >= 3 else {
            self.claims = [FConstants.CLAIMS_INDEX: ""]
            return
        }
        var payload = segments[1]
        var base64 = payload.replace("-", "+")
        base64 = payload.replace("_", "/")
        while base64.count % 4 != 0 {
            base64 += "="
        }
        
        guard let payloadData = Data(base64Encoded: base64),
              let payloadJson = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any] else {
            self.claims = [FConstants.CLAIMS_INDEX: ""]
            return
        }
        self.claims = payloadJson
    }
    var userPK: String? {
        guard let ret = claims[FConstants.CLAIMS_INDEX] as? String else {
            return nil
        }
        return ret
    }
    var userName: String? {
        guard let ret = claims[FConstants.CLAIMS_NAME] as? String else {
            return nil
        }
        return ret
    }
    var expiredDate: TimeInterval? {
        guard let ret = claims[FConstants.CLAIMS_EXP] as? TimeInterval else {
            return nil
        }
        return ret
    }
    var subject: String? {
        guard let ret = claims[FConstants.CLAIMS_SUB] as? String else {
            return nil
        }
        return ret
    }
}
