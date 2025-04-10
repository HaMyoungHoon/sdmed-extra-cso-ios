public class FFormatLiterals {
    var appCompatLiteral: String = ":."
    var dd: Int = 2
    var hh: Int = 2
    var mm: Int = 2
    var ss: Int = 2
    var ff: Int = FDateTimeFormat.ins.maxSecondsFractionDigits
    private var _literals: [String] = ["", ".", ":", ":", ".", ""]
    var start: String { return _literals[0] }
    var dayHourSep: String { return _literals[1] }
    var hourMinuteSep: String { return _literals[2] }
    var minuteSecondSep: String { return _literals[3] }
    var secondFractionSep: String { return _literals[4] }
    var end: String { return _literals[5] }
    
    func initInvariant(_ isNegative: Bool) -> FFormatLiterals {
        let ret = FFormatLiterals()
        ret._literals[0] = isNegative ? "-" : ""
        return ret
    }
    func initThis(_ format: String, _ useInvariantFieldLengths: Bool) -> FFormatLiterals {
        _literals = ["", "", "", "", "", ""]
        dd = 0
        hh = 0
        mm = 0
        ss = 0
        ff = 0
        
        var buff = ""
        var inQuote = false
        var quote = "'".toChar
        var field = 0
        var skipOnce = false
        for i in format.indices {
            if skipOnce {
                skipOnce = false
                continue
            }
            switch format[i] {
            case "'".toChar, "\"".toChar:
                if inQuote && (quote == format[i]) {
                    _literals[field] = buff
                    buff = ""
                    inQuote = false
                } else if !inQuote {
                    quote = format[i]
                    inQuote = true
                }
                break
            case "\\".toChar:
                if !inQuote {
                    skipOnce = true
                    buff += format[i].toString
                }
                break
            case "d".toChar:
                if !inQuote {
                    field = 1
                    dd += 1
                }
                break
            case "h".toChar:
                if !inQuote {
                    field = 2
                    hh += 1
                }
                break
            case "m".toChar:
                if !inQuote {
                    field = 3
                    mm += 1
                }
                break
            case "s".toChar:
                if !inQuote {
                    field = 4
                    ss += 1
                }
                break
            case "f".toChar, "F".toChar:
                if !inQuote {
                    field = 5
                    ff += 1
                }
                break
            default:
                buff += format[i].toString
                break
            }
        }
        appCompatLiteral = minuteSecondSep + secondFractionSep
        if useInvariantFieldLengths {
            dd = 2
            hh = 2
            mm = 2
            ss = 2
            ff = FDateTimeFormat.ins.maxSecondsFractionDigits
        } else {
            if dd < 2 || dd > 2 {
                dd = 2
            }
            if hh < 1 || hh > 2 {
                hh = 2
            }
            if mm < 1 || mm > 2 {
                mm = 2
            }
            if ss < 1 || ss > 2 {
                ss = 2
            }
            if ff < 1 || ff > 7 {
                ff = 2
            }
        }
        return self
    }
}
