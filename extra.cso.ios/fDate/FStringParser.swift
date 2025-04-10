public class FStringParser {
    var _str: String = ""
    var _ch: Character = Character("")
    var _pos: Int = -1
    var _len: Int = 0
    
    func nextChar() {
        if (_pos < _len) {
            _pos += 1
        }
        _ch = _pos < _len ? _str[_pos] : Character("")
    }
    func nextNonDigit() -> Character {
        var index = _pos
        while index < _len {
            let ch = _str[index]
            if ch < "0".toChar || ch > "9".toChar {
                return ch
            }
            index += 1
        }
        return Character("")
    }
    func tryParse(_ input: String?, _ result: FTimeSpanResult) -> Bool {
        result.parsedTimeSpan._ticks = 0
        guard let inputBuff = input else {
            result.setFailure(FParseFailureKind.ArgumentNull, "argument is null")
            return false
        }
        _str = inputBuff
        _len = inputBuff.count
        _pos = -1
        nextChar()
        skipBlanks()
        var negative = false
        if _ch == "-".toChar {
            negative = true
            nextChar()
        }
        var time = 0
        if nextNonDigit() == ":".toChar {
            let pair = parseTime(result)
            if !pair.0 {
                return false
            }
            time = pair.1
        } else {
            var days = 0
            let pair = parseInt(0x7FFFFFFFFFFFFFFF / FTimeSpan.ticksPerDay, result)
            if !pair.0 {
                return false
            }
            days = pair.1
            time = days * FTimeSpan.ticksPerDay
            if _ch == ".".toChar {
                nextChar()
                let pairSub = parseTime(result)
                if !pairSub.0 {
                    return false
                }
                time += pairSub.1
            }
        }
        if negative {
            time = -time
            if time > 0 {
                result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                return false
            }
        } else {
            if time < 0 {
                result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                return false
            }
        }
        skipBlanks()
        if _pos < _len {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
        result.parsedTimeSpan._ticks = time
        return true
    }
    func parseInt(_ max: Int, _ result: FTimeSpanResult) -> (Bool, Int) {
        var second = 0
        let pos = _pos
        while _ch >= "0".toChar && _ch <= "9".toChar {
            if second & 0xF0000000 != 0 {
                result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                return (false, second)
            }
            second = second * 10 + _ch.toInt - "0".toChar.toInt
            if second < 0 {
                result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                return (false, second)
            }
            nextChar()
        }
        if pos == _pos {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return (false, second)
        }
        if second > max {
            result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
            return (false, second)
        }
        return (true, second)
    }
    func parseTime(_ result: FTimeSpanResult) -> (Bool, Int) {
        var second = 0
        var pair = parseInt(23, result)
        if !pair.0 {
            return (false, second)
        }
        second = pair.1 * FTimeSpan.ticksPerHour
        if _ch != ":".toChar {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return (false, second)
        }
        nextChar()
        pair = parseInt(59, result)
        if !pair.0 {
            return (false, second)
        }
        second += pair.1 * FTimeSpan.ticksPerMinute
        if _ch == ":".toChar {
            nextChar()
            if _ch != ".".toChar {
                pair = parseInt(59, result)
                if !pair.0 {
                    return (false, second)
                }
                second += pair.1 * FTimeSpan.ticksPerSecond
            }
            if _ch == ".".toChar {
                nextChar()
                var ticksPerSecond = FTimeSpan.ticksPerSecond
                while ticksPerSecond > 1 && _ch >= "0".toChar && _ch <= "9".toChar {
                    ticksPerSecond /= 10
                    second += (_ch.toInt - "0".toChar.toInt) * ticksPerSecond
                    nextChar()
                }
            }
        }
        return (true, second)
    }
    func skipBlanks() {
        while (_ch == " ".toChar || _ch == "\t".toChar) {
            nextChar()
        }
    }
}
