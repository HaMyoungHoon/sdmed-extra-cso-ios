import Foundation

public class FDateTimeFormat {
    static let ins = FDateTimeFormat()
    let maxSecondsFractionDigits = 7
    func format(_ dateTime: FDateTime, _ format: String? = nil, _ localize: FLocalize = FLocalize.KOREA) -> String {
        let parseFormatter = (format != nil) ? (format?.isEmpty == false ? format! : localize.getDateOffset()) : localize.getDateOffset()
        return formatCustomized(dateTime, parseFormatter, localize)
    }
    func formatCustomized(_ dateTime: FDateTime, _ format: String, _ localize: FLocalize) -> String {
        var ret: String = ""
        var index = 0
        var tokenLen = 0
        var hour12 = 0
        var nextLetter: Int
        while index < format.count {
            let letter: Character = format[index]
            switch (letter) {
            case "h".toChar:
                tokenLen = parseRepeatPattern(format, index, letter)
                hour12 = dateTime.hour % 12
                if hour12 == 0 {
                    hour12 = 12
                }
                break
            case "H".toChar:
                tokenLen = parseRepeatPattern(format, index, letter)
                formatDigits(&ret, dateTime.hour, tokenLen)
                break
            case "m".toChar:
                tokenLen = parseRepeatPattern(format, index, letter)
                formatDigits(&ret, dateTime.minute, tokenLen)
                break
            case "s".toChar:
                tokenLen = parseRepeatPattern(format, index, letter)
                formatDigits(&ret, dateTime.second, tokenLen)
                break
            case "f".toChar, "F".toChar:
                tokenLen = parseRepeatPattern(format, index, letter)
                if tokenLen <= maxSecondsFractionDigits {
                    var fraction = dateTime.internalTicks % dateTime._ticksPerSecond
                    fraction /= pow(10.0, (7 - tokenLen).toDouble).toInt
                    if letter == "f".toChar {
                        formatDigits(&ret, fraction, tokenLen, true)
                    } else {
                        var effectiveDigits = tokenLen
                        while effectiveDigits > 0 {
                            if fraction % 10 == 0 {
                                fraction /= 10
                                effectiveDigits -= 1
                            } else {
                                break
                            }
                        }
                        if effectiveDigits > 0 {
                            formatDigits(&ret, fraction, effectiveDigits, true)
                        } else {
                            if ret.isEmpty == false && ret[ret.count - 1] == ".".toChar {
                                ret.delete(ret.count - 1, 1)
                            }
                        }
                    }
                } else {
                    FException.FAssert.notDefined("illegal format max seconds fraction is \(maxSecondsFractionDigits) but \(tokenLen)")
                }
                break
            case "d".toChar:
                tokenLen = parseRepeatPattern(format, index, letter)
                if tokenLen <= 2 {
                    formatDigits(&ret, localize.getDayOfMonth(dateTime), tokenLen)
                } else {
                    ret.append(localize.getDayOfWeek(dateTime, tokenLen > 3))
                }
                break
            case "M".toChar:
                tokenLen = parseRepeatPattern(format, index, letter)
                if (tokenLen <= 2) {
                    formatDigits(&ret, localize.getMonth(dateTime), tokenLen)
                } else {
                    if (tokenLen >= 4) {
                        ret.append(localize.getMonth(dateTime, false))
                    } else {
                        ret.append(localize.getMonth(dateTime, true))
                    }
                }
                break
            case "y".toChar:
                tokenLen = parseRepeatPattern(format, index, letter)
                formatDigits(&ret, localize.getYear(dateTime), tokenLen)
                break
            case ":".toChar, "/".toChar:
                tokenLen = 1
                ret.append(letter)
                break
            case "'".toChar, "\"".toChar:
                var buff: String = ""
                tokenLen = parseQuoteString(format, index, &buff)
                ret.append(buff)
                break
            case "%".toChar:
                nextLetter = parseNextChar(format, index)
                if nextLetter >= 0 && nextLetter != "%".toChar.toInt {
                    ret.append(dateTime.toString(nextLetter.toChar.toString, localize))
                    tokenLen = 2
                } else {
                    FException.FAssert.notDefined("illegal format : \(format)")
                }
                break
            case "\\".toChar:
                nextLetter = parseNextChar(format, index)
                if nextLetter >= 0 {
                    ret.append(nextLetter.toChar.toString)
                } else {
                    FException.FAssert.notDefined("illegal format : \(format)")
                }
                break
            default:
                tokenLen = 1
                ret.append(letter)
                break
            }
            index += tokenLen
        }
        
        return ret
    }
    func parseNextChar(_ format: String, _ pos: Int) -> Int {
        if pos >= format.count - 1 {
            return -1
        }
        return format[pos+1].toInt
    }
    func parseQuoteString(_ format: String, _ pos: Int, _ outputData: inout String) -> Int {
        let formatLength = format.count
        let beginPos = pos
        var index = pos + 1
        let quoteChar = format[index]
        var foundQuote = false
        while index < formatLength {
            let letter = format[index]
            index += 1
            if letter == quoteChar {
                foundQuote = true
                break
            } else if letter == "\\".toChar {
                if index < formatLength {
                    outputData.append(format[index])
                    index += 1
                } else {
                    FException.FAssert.notDefined("illegal format : \(format)")
                }
            } else {
                outputData.append(letter)
            }
        }
        
        if !foundQuote {
            FException.FAssert.notDefined("illegal format : \(format), quoteChar : \(quoteChar)")
        }
        
        return (index - beginPos)
    }
    func parseRepeatPattern(_ format: String, _ pos: Int, _ letter: Character) -> Int {
        let len = format.count
        var index = pos + 1
        while (index < len) && format[index] == letter {
            index += 1
        }
        return (index - pos)
    }
    func formatDigits(_ outputData: inout String, _ value: Int, _ tokenLen: Int) {
        formatDigits(&outputData, value, tokenLen, false)
    }
    func formatDigits(_ outputData: inout String, _ value: Int, _ tokenLen: Int, _ overrideLenthLimit: Bool) {
        if value < 0 {
            FException.FAssert.notDefined("illegal format value : \(value)")
        }
        var len = tokenLen
        if !overrideLenthLimit && len > 2 {
            len = 2
        }
        var buff = [Character](repeating: " ", count: 16)
        var p = buff.count
        var n = value
        repeat {
            p -= 1
            buff[p] = "\(n % 10)".toChar
            n /= 10
        } while n != 0 && p > 0
        var digits = buff.count - p
        while digits < len && p > 0 {
            p -= 1
            buff[p] = "0".toChar
            digits += 1
        }
        
        outputData.append(contentsOf: buff[p..<buff.count])
    }
}
