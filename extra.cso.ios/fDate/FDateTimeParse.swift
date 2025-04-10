public class FDateTimeParse {
    static let ins = FDateTimeParse()
    func parse(_ data: String) -> FDateTime {
        let buff = FDateTime2().setThis(data)
        return FDateTime().setThis(buff.getYear(), buff.getMonth(), buff.getDay())
    }
    func parse(_ data: String, _ fLocalize: FLocalize) -> FDateTime {
        let buff = FDateTime2().setThis(data)
        return FDateTime().setThis(buff.getYear(), buff.getMonth(), buff.getDay())
    }
    func tryParseQuoteString(_ format: String, _ pos: Int, _ result: inout String) -> (Bool, Int) {
        var ret = (false, 0)
        let formatLen = format.count
        let beginPos = pos
        var posBuff = pos
        let quoteChar = format[posBuff]
        posBuff += 1
        var foundQuote = false
        while posBuff < formatLen {
            let ch = format[posBuff]
            posBuff += 1
            if ch == quoteChar {
                foundQuote = true
                break
            } else if ch == "\\".toChar {
                if posBuff < formatLen {
                    result.append(format[posBuff])
                    posBuff += 1
                } else {
                    return ret
                }
            } else {
                result.append(ch)
            }
        }
        if !foundQuote {
            return ret
        }
        ret = (true, posBuff - beginPos)
        return ret
    }
}
