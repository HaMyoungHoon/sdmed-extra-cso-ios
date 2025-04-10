public class FTimeSpanTokenizer {
    private var _pos: Int = 0
    private var _value: String? = nil
    
    var eol: Bool { return _pos >= ((_value?.count ?? 0) - 1) }
    var currentChar: Character {
        if (_value?.isEmpty == true) {
            return "0"
        }
        if let value = _value, _pos > -1, _pos < (_value?.count ?? 0) {
            return value[_pos]
        }
        return "0"
    }
    func backOne() {
        if _pos > 0 {
            _pos += 1
        }
    }
    var nextChar: Character {
        _pos += 1
        return currentChar
    }
    func initThis(_ value: String) -> FTimeSpanTokenizer {
        return initThis(0, value)
    }
    func initThis(_ pos: Int, _ value: String) -> FTimeSpanTokenizer {
        _pos = pos
        _value = value
        return self
    }
    func getNextToken() -> FTimeSpanToken {
        let ret = FTimeSpanToken()
        var char = currentChar
        if (char == "0") {
            ret.ttt = FTimeSpanTokenTypes.End
            return ret
        }

        if char.isNumber {
            ret.ttt = FTimeSpanTokenTypes.Num
            ret.num = 0
            ret.zeroes = 0
            repeat {
                if (ret.num & 0xF0000000) != 0 {
                    ret.ttt = FTimeSpanTokenTypes.NumOverFlow
                    return ret
                }
                ret.num = ret.num * 10 + char.toInt - "0".toChar.toInt
                if ret.num == 0 { ret.zeroes += 1 }
                if ret.num < 0 {
                    ret.ttt = FTimeSpanTokenTypes.NumOverFlow
                    return ret
                }
                char = nextChar
            } while char.isNumber
            return ret
        } else {
            ret.ttt = FTimeSpanTokenTypes.Sep
            var length = 0
            while char != "0".toChar && char.isNumber == false {
                char = nextChar
                length += 1
            }
            if let value = _value {
                ret.sep = value[_pos..<value.count].toString
            }
            return ret
        }
    }
}
