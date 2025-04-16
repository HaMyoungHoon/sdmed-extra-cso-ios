class RestResult: PRestResult {
    var result: Bool? = nil
    var code: Int? = nil
    var msg: String? = nil
        
    func emptyResult() -> RestResult {
        self.result = true
        self.code = 0
        self.msg = ""
        return self
    }
    func setFail(_ code: Int? = -1, _ msg: String? = "not defined error") -> RestResult {
        self.result = false
        self.code = code
        self.msg = msg
        return self
    }
    func setFail(_ data: PRestResult) -> RestResult {
        self.result = data.result
        self.code = data.code
        self.msg = data.msg
        return self
    }
    static func emptyResult() -> RestResult {
        let ret = RestResult()
        ret.result = true
        ret.code = 0
        ret.msg = ""
        return ret
    }
    static func setFail(_ code: Int?, _ msg: String? = "not defined error") -> RestResult {
        let ret = RestResult()
        ret.result = false
        ret.code = code
        ret.msg = msg
        return ret
    }
    static func setFail(_ msg: String? = "not defined error") -> RestResult {
        let ret = RestResult()
        ret.result = false
        ret.code = -1
        ret.msg = msg
        return ret
    }
    static func setFail(_ data: PRestResult) -> RestResult {
        let ret = RestResult()
        ret.result = data.result
        ret.code = data.code
        ret.msg = data.msg
        return ret
    }
}
