import Foundation

open class FTimeSpanFormat {
    static let ins = FTimeSpanFormat()
    let positiveInvariantFormatLiterals = FFormatLiterals().initInvariant(false)
    let negativeInvariantFormatLiterals = FFormatLiterals().initInvariant(true)
    
    enum Pattern: Int {
        case None = 0
        case Minimum = 1
        case Full = 2
    }
    
    func intToString(_ n: Int, _ digits: Int) -> String {
        var buff = [Character](repeating: " ", count: 16)
        var p = buff.count
        var value = n
        
        repeat {
            p -= 1
            buff[p] = ((value % 10) + "0".toChar.toInt).toChar
            value /= 10
        } while value != 0 && p > 0

        var digitCount = buff.count - p
        while digitCount < digits && p > 0 {
            p -= 1
            buff[p] = "0"
            digitCount += 1
        }

        return String(buff[p..<buff.count])
    }
    func format(_ timeSpan: FTimeSpan, _ format: String? = nil, _ localize: FLocalize) -> String {
        var formatBuff = format ?? "c"
        if formatBuff.count == 1 {
            if formatBuff[0] == "c".toChar || formatBuff[0] == "t".toChar || formatBuff[0] == "T".toChar {
                return formatStandard(timeSpan, true, format, Pattern.Minimum)
            }
            if formatBuff[0] == "g".toChar || formatBuff[0] == "G".toChar {
                let pattern = formatBuff[0] == "g".toChar ? Pattern.Minimum : Pattern.Full
                formatBuff = timeSpan.ticks < 0 ? localize.fullTimeSpanNegativePattern : localize.fullTimeSpanPositivePattern
                return formatStandard(timeSpan, false, formatBuff, pattern)
            }
        }
        return formatCustomized(timeSpan, format, localize)
    }
    func formatStandard(_ timeSpan: FTimeSpan, _ isInvariant: Bool, _ format: String? = nil, _ pattern: Pattern) -> String {
        var ret: String = ""
        var day = timeSpan.ticks / FTimeSpan.ticksPerDay
        var time = timeSpan.ticks % FTimeSpan.ticksPerDay
        if timeSpan.ticks < 0 {
            day = -day
            time = -time
        }
        let hours = time / FTimeSpan.ticksPerHour % 24
        let minutes = time / FTimeSpan.ticksPerMinute % 60
        let seconds = time / FTimeSpan.ticksPerSecond % 60
        var fraction = time % FTimeSpan.ticksPerSecond
        
        let literal = isInvariant ? timeSpan.ticks < 0 ? negativeInvariantFormatLiterals : positiveInvariantFormatLiterals : FFormatLiterals().initThis(format!, pattern == Pattern.Full)
        ret += literal.start
        if pattern == Pattern.Full || day != 0 {
            ret += day.toString
            ret += literal.dayHourSep
        }
        ret += intToString(hours, literal.hh)
        ret += literal.hourMinuteSep
        ret += intToString(minutes, literal.mm)
        ret += literal.minuteSecondSep
        ret += intToString(seconds, literal.ss)
        if !isInvariant && pattern == Pattern.Minimum {
            var effectiveDigits = literal.ff
            while effectiveDigits > 0 {
                if fraction % 10 == 0 {
                    fraction /= 10
                    effectiveDigits -= 1
                } else {
                    break
                }
            }
            if effectiveDigits > 0 {
                ret += literal.secondFractionSep
                ret += intToString(fraction, effectiveDigits)
            }
        } else if pattern == Pattern.Full || fraction != 0 {
            ret += literal.secondFractionSep
            ret += intToString(fraction, literal.ff)
        }
        ret += literal.end
        return ret
    }
    func formatCustomized(_ timeSpan: FTimeSpan, _ format: String? = nil, _ localize: FLocalize) -> String {
        var ret = ""
        var day = timeSpan.ticks / FTimeSpan.ticksPerDay
        var time = timeSpan.ticks % FTimeSpan.ticksPerDay
        if timeSpan.ticks < 0 {
            day = -day
            time = -time
        }
        let hours = time / FTimeSpan.ticksPerHour % 24
        let minutes = time / FTimeSpan.ticksPerMinute % 60
        let seconds = time / FTimeSpan.ticksPerSecond % 60
        let fraction = time % FTimeSpan.ticksPerSecond
        var temp = 0
        var index = 0
        var tokenLen = 0
        guard let formatBuff = format else {
            return ret
        }
        while index < formatBuff.count {
            switch formatBuff[index] {
            case "h".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, index, formatBuff[index])
                if tokenLen > 2 {
                    FException.FAssert.notDefined("illegal format data format : \(formatBuff), format[\(index)] : \(formatBuff[index])")
                }
                FDateTimeFormat.ins.formatDigits(&ret, hours, tokenLen)
                break
            case "m".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, index, formatBuff[index])
                if tokenLen > 2 {
                    FException.FAssert.notDefined("illegal format data format : \(formatBuff), format[\(index)] : \(formatBuff[index])")
                }
                FDateTimeFormat.ins.formatDigits(&ret, minutes, tokenLen)
                break
            case "s".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, index, formatBuff[index])
                if tokenLen > 2 {
                    FException.FAssert.notDefined("illegal format data format : \(formatBuff), format[\(index)] : \(formatBuff[index])")
                }
                FDateTimeFormat.ins.formatDigits(&ret, seconds, tokenLen)
                break
            case "f".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, index, formatBuff[index])
                if tokenLen > 2 {
                    FException.FAssert.notDefined("illegal format data format : \(formatBuff), format[\(index)] : \(formatBuff[index])")
                }
                temp = fraction
                temp /= pow(10.0, (FDateTimeFormat.ins.maxSecondsFractionDigits - tokenLen).toDouble).toInt
                FDateTimeFormat.ins.formatDigits(&ret, temp, tokenLen, true)
                break
            case "F".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, index, formatBuff[index])
                if tokenLen > 2 {
                    FException.FAssert.notDefined("illegal format data format : \(formatBuff), format[\(index)] : \(formatBuff[index])")
                }
                temp = fraction
                temp /= pow(10.0, (FDateTimeFormat.ins.maxSecondsFractionDigits - tokenLen).toDouble).toInt
                var effectiveDigits = tokenLen
                while effectiveDigits > 0 {
                    if temp % 10 == 0 {
                        temp /= 10
                        effectiveDigits -= 1
                    } else {
                        break
                    }
                }
                if (effectiveDigits > 0) {
                    FDateTimeFormat.ins.formatDigits(&ret, temp, effectiveDigits, true)
                }
                break
            case "d".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, index, formatBuff[index])
                if tokenLen > 2 {
                    FException.FAssert.notDefined("illegal format data format : \(formatBuff), format[\(index)] : \(formatBuff[index])")
                }
                FDateTimeFormat.ins.formatDigits(&ret, day, tokenLen, true)
                break
            case "'".toChar, "\"".toChar:
                var buff = ""
                tokenLen = FDateTimeFormat.ins.parseQuoteString(formatBuff, index, &buff)
                ret.append(buff)
                break
            case "%".toChar:
                let nextChar = FDateTimeFormat.ins.parseNextChar(formatBuff, index)
                if nextChar >= 0 && nextChar != "%".toChar.toInt {
                    ret.append(formatCustomized(timeSpan, nextChar.toChar.toString, localize))
                }
                break
            case "\\".toChar:
                let nextChar = FDateTimeFormat.ins.parseNextChar(formatBuff, index)
                if nextChar >= 0 {
                    ret.append(nextChar.toChar)
                    tokenLen = 2
                } else {
                    FException.FAssert.notDefined("illegal format data format : \(formatBuff), format[\(index)] : \(formatBuff[index])")
                }
                break
            default:
                FException.FAssert.notDefined("illegal format data format : \(formatBuff), format[\(index)] : \(formatBuff[index])")
                break
            }
            index += tokenLen
        }
        
        return ret
    }
}
