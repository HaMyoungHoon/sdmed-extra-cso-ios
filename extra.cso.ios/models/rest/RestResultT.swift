class RestResultT<T: Decodable>: PRestResult {
    var result: Bool? = nil
    var code: Int? = nil
    var msg: String? = nil
    var data: T? = nil
    
    func emptyResult() -> RestResultT<T> {
        self.result = true
        self.code = 0
        self.msg = ""
        return self
    }
    func setSuccess(_ data: T) -> RestResultT<T> {
        self.result = true
        self.code = 0
        self.msg = ""
        self.data = data
        return self
    }
    func setFail(_ code: Int? = -1, _ msg: String? = "not defined error") -> RestResultT<T> {
        self.result = false
        self.code = code
        self.msg = msg
        return self
    }
    func setFail(_ data: PRestResult) -> RestResultT<T> {
        self.result = data.result
        self.code = data.code
        self.msg = data.msg
        return self
    }
    static func emptyResult() -> RestResultT<T> {
        let ret = RestResultT<T>()
        ret.result = true
        ret.code = 0
        ret.msg = ""
        return ret
    }
    static func setSuccess(_ data: T) -> RestResultT<T> {
        let ret = RestResultT<T>()
        ret.result = true
        ret.code = 0
        ret.msg = ""
        ret.data = data
        return ret
    }
    static func setFail(_ msg: String? = "not defined error") -> RestResultT<T> {
        let ret = RestResultT<T>()
        ret.result = false
        ret.code = -1
        ret.msg = msg
        return ret
    }
    static func setFail(_ code: Int?, _ msg: String? = "not defined error") -> RestResultT<T> {
        let ret = RestResultT<T>()
        ret.result = false
        ret.code = code
        ret.msg = msg
        return ret
    }
    static func setFail(_ data: PRestResult) -> RestResultT<T> {
        let ret = RestResultT<T>()
        ret.result = data.result
        ret.code = data.code
        ret.msg = data.msg
        return ret
    }
}
