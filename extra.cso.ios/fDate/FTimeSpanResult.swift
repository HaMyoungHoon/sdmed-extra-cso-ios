import Foundation

public class FTimeSpanResult {
    var parsedTimeSpan: FTimeSpan = FTimeSpan(0)
    var throwStyle: FTimeSpanThrowStyle = FTimeSpanThrowStyle.None
    var failure: FParseFailureKind = FParseFailureKind.None
    var failureMessage: String = ""
    
    func initThis(_ canThrow: FTimeSpanThrowStyle) -> FTimeSpanResult {
        parsedTimeSpan = FTimeSpan(0)
        throwStyle = canThrow
        return self
    }
    func setFailure(_ failure: FParseFailureKind, _ failuremessage: String) {
        self.failure = failure
        self.failureMessage = failuremessage
        if throwStyle != FTimeSpanThrowStyle.None {
            getTimeSpanParseException()
        }
    }
    func getTimeSpanParseException() {
        switch failure {
        case FParseFailureKind.ArgumentNull: FException.FAssert.nullPointer(failureMessage)
        case FParseFailureKind.Format: FException.FAssert.format(failureMessage)
        case FParseFailureKind.FormatWithParameter: FException.FAssert.formatParameter(failureMessage)
        case FParseFailureKind.OverFlow: FException.FAssert.overFlow(failureMessage)
        default: FException.FAssert.notDefined(failureMessage)
        }
    }
    func tryTimeToTicks(_ positive: Bool, _ days: FTimeSpanToken, _ hours: FTimeSpanToken, _ minutes: FTimeSpanToken, _ seconds: FTimeSpanToken, _ fraction: FTimeSpanToken) -> (Bool, Int) {
        var ret = 0
        if days.isInvalidNumber(FTimeSpanParse.ins.maxDays, FTimeSpanParse.ins.unlimitedDigits) &&
            hours.isInvalidNumber(FTimeSpanParse.ins.maxHours, FTimeSpanParse.ins.unlimitedDigits) &&
            minutes.isInvalidNumber(FTimeSpanParse.ins.maxMinutes, FTimeSpanParse.ins.unlimitedDigits) &&
            seconds.isInvalidNumber(FTimeSpanParse.ins.maxSeconds, FTimeSpanParse.ins.unlimitedDigits) &&
            fraction.isInvalidNumber(FTimeSpanParse.ins.maxFraction, FTimeSpanParse.ins.unlimitedDigits) {
            return (false, ret)
        }
        let ticks = (days.num * 3600 * 24 + hours.num * 3600 + minutes.num * 60 + seconds.num) * 1000
        if ticks > FTimeSpan.maxMilliSeconds || ticks < FTimeSpan.minMilliSeconds {
            return (false, ret)
        }
        
        var fractionBuff = fraction.num
        if fractionBuff != 0 {
            var lowerLimit = FTimeSpan.ticksPerTenthSecond
            if fraction.zeroes > 0 {
                let divisor = pow(10.0, fraction.zeroes.toDouble).toInt
                lowerLimit = lowerLimit / divisor
            }
            while fractionBuff < lowerLimit {
                fractionBuff *= 10
            }
        }
        ret = ticks * FTimeSpan.ticksPerMillisecond + fractionBuff
        if positive && ret < 0 {
            ret = 0
            return (false, ret)
        }
        
        return (true, ret)
    }
    func tryParse(_ input: String?, _ localize: FLocalize, _ result: FTimeSpan) -> Bool {
        let parseResult = FTimeSpanResult().initThis(FTimeSpanThrowStyle.None)
        if tryParseTimeSpan(input, FTimeSpanStandardStyle.AnyStyle.toS(), localize, parseResult) {
            result._ticks = parseResult.parsedTimeSpan.ticks
            return true
        } else {
            result._ticks = 0
            return false
        }
    }
    func parseExact(_ input: String, _ format: String, _ localize: FLocalize, _ styles: FTimeSpanStyles) -> FTimeSpan {
        let parseResult = FTimeSpanResult().initThis(FTimeSpanThrowStyle.All)
        if tryParseExactTimeSpan(input, format, localize, styles, parseResult) {
            return parseResult.parsedTimeSpan
        } else {
            parseResult.getTimeSpanParseException()
            return parseResult.parsedTimeSpan
        }
    }
    func parseExactDigits(_ tokenizer: FTimeSpanTokenizer, _ minDigitLength: Int) -> (Bool, Int) {
        let maxDigitLength = minDigitLength == 1 ? 2 : minDigitLength
        let triple = parseExactDigits(tokenizer, minDigitLength, maxDigitLength)
        return (triple.0, triple.2)
    }
    func parseExactDigits(_ tokenizer: FTimeSpanTokenizer, _ minDigitLength: Int, _ maxDigitLength: Int) -> (Bool, Int, Int) {
        var first = false
        var second = 0
        var third = 0
        var tokenLength = 0
        while tokenLength < maxDigitLength {
            let ch = tokenizer.nextChar
            if ch < "0".toChar || ch > "9".toChar {
                tokenizer.backOne()
                break
            }
            third = third * 10 + (ch.toInt - "0".toChar.toInt)
            if third == 0 {
                second += 1
            }
            tokenLength += 1
        }
        first = tokenLength >= minDigitLength
        return (first, second, third)
    }
    func parseExactLiteral(_ tokenizer: FTimeSpanTokenizer, _ enquotedString: String) -> Bool {
        for i in 0..<enquotedString.count {
            if enquotedString[i] != tokenizer.nextChar {
                return false
            }
        }
        return true
    }
    func tryParseExact(_ input: String, _ format: String, _ localize: FLocalize, _ styles: FTimeSpanStyles, _ result: FTimeSpan) -> Bool {
        let parseResult = FTimeSpanResult().initThis(FTimeSpanThrowStyle.None)
        if tryParseExactTimeSpan(input, format, localize, styles, parseResult) {
            result._ticks = parseResult.parsedTimeSpan.ticks
            return true
        } else {
            result._ticks = 0
            return false
        }
    }
    func parseExactMultiple(_ input: String, _ format: [String], _ localize: FLocalize, _ styles: FTimeSpanStyles) -> FTimeSpan {
        let parseResult = FTimeSpanResult().initThis(FTimeSpanThrowStyle.All)
        if tryParseExactMultipleTimeSpan(input, format, localize, styles, parseResult) {
            return parseResult.parsedTimeSpan
        } else {
            parseResult.getTimeSpanParseException()
            return parseResult.parsedTimeSpan
        }
    }
    func tryParseExactMultiple(_ input: String, _ format: [String], _ localize: FLocalize, _ styles: FTimeSpanStyles, _ result: FTimeSpan) -> Bool {
        let parseResult = FTimeSpanResult().initThis(FTimeSpanThrowStyle.None)
        if tryParseExactMultipleTimeSpan(input, format, localize, styles, parseResult) {
            result._ticks = parseResult.parsedTimeSpan.ticks
            return true
        } else {
            result._ticks = 0
            return false
        }
    }
    private func tryParseTimeSpan(_ input: String?, _ style: FTimeSpanStandardStyles, _ localize: FLocalize, _ result: FTimeSpanResult) -> Bool {
        guard var inputBuff = input else {
            result.setFailure(FParseFailureKind.ArgumentNull, "input argument is null string")
            return false
        }
        inputBuff = inputBuff.trim
        if inputBuff.isEmpty {
            result.setFailure(FParseFailureKind.Format, "input data is empty")
            return false
        }
        
        let tokenizer = FTimeSpanTokenizer().initThis(inputBuff)
        let raw = FTimeSpanRawInfo().initThis(localize)
        var token = tokenizer.getNextToken()
        while token.ttt != FTimeSpanTokenTypes.End {
            if !raw.processToken(token, result) {
                result.setFailure(FParseFailureKind.Format, "format data is bad input : \(inputBuff), token : \(token)")
                return false
            }
            token = tokenizer.getNextToken()
        }
        if !tokenizer.eol {
            result.setFailure(FParseFailureKind.Format, "input data is bad format input : \(inputBuff)")
            return false
        }
        if !processTerminalState(raw, style, result) {
            result.setFailure(FParseFailureKind.Format, "format data is bad input : \(inputBuff), raw : \(raw)")
            return false
        }
        return true
    }
    private func processTerminalState(_ raw: FTimeSpanRawInfo, _ style: FTimeSpanStandardStyles, _ result: FTimeSpanResult) -> Bool {
        if raw.lastSeenTTT == FTimeSpanTokenTypes.Num {
            let token = FTimeSpanToken()
            token.ttt = FTimeSpanTokenTypes.Sep
            token.sep = ""
            if raw.processToken(token, result) {
                result.setFailure(FParseFailureKind.Format, "format data is bad token : \(token)")
                return false
            }
        }
        
        switch raw.numCount {
        case 1: return processTerminal_D(raw, style, result)
        case 2: return processTerminal_HM(raw, style, result)
        case 3: return processTerminal_HMSD(raw, style, result)
        case 4: return processTerminal_HMSFD(raw, style, result)
        case 5: return processTerminal_DHMSF(raw, style, result)
        default:
            result.setFailure(FParseFailureKind.Format, "format data is bad raw : \(raw)")
            return false
        }
    }
    func processTerminal_D(_ raw: FTimeSpanRawInfo, _ style: FTimeSpanStandardStyles, _ result: FTimeSpanResult) -> Bool {
        if raw.sepCount != 2 || raw.numCount != 1 || style.flag(FTimeSpanStandardStyle.RequireFull) != 0 {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
        
        let inv = style.flag(FTimeSpanStandardStyle.Invariant) != 0
        let loc = style.flag(FTimeSpanStandardStyle.Localized) != 0
        var positive = false
        var match = false
        if inv {
            if raw.fullDMatch(raw.positiveInvariant) {
                match = true
                positive = true
            }
            if !match && raw.fullDMatch(raw.negativeInvariant) {
                match = true
                positive = false
            }
        }
        if loc {
            if !match && raw.fullDMatch(raw.positiveLocalized) {
                match = true
                positive = true
            }
            if !match && raw.fullDMatch(raw.negativeLocalized) {
                match = true
                positive = false
            }
        }
        
        var ticks = 0
        if match {
            let pair = tryTimeToTicks(positive, raw.numbers[0], FTimeSpanParse.ins.zero, FTimeSpanParse.ins.zero, FTimeSpanParse.ins.zero, FTimeSpanParse.ins.zero)
            if !pair.0 {
                result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                return false
            }
            if !positive {
                ticks = -pair.1
                if ticks > 0 {
                    result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                    return false
                }
            }
            result.parsedTimeSpan._ticks = ticks
            return false
        }
        
        result.setFailure(FParseFailureKind.Format, "format data is bad")
        return false
    }
    func processTerminal_HM(_ raw: FTimeSpanRawInfo, _ style: FTimeSpanStandardStyles, _ result: FTimeSpanResult) -> Bool {
        if raw.sepCount != 3 || raw.numCount != 2 || style.flag(FTimeSpanStandardStyle.RequireFull) != 0 {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
        
        let inv = style.flag(FTimeSpanStandardStyle.Invariant) != 0
        let loc = style.flag(FTimeSpanStandardStyle.Localized) != 0
        var positive = false
        var match = false
        if inv {
            if raw.fullHMMatch(raw.positiveInvariant) {
                match = true
                positive = true
            }
            if !match && raw.fullHMMatch(raw.negativeInvariant) {
                match = true
                positive = false
            }
        }
        if loc {
            if !match && raw.fullHMMatch(raw.positiveLocalized) {
                match = true
                positive = true
            }
        }
        
        var ticks = 0
        if match {
            let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], FTimeSpanParse.ins.zero, FTimeSpanParse.ins.zero)
            if !pair.0 {
                result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                return false
            }
            ticks = pair.1
            if !positive {
                ticks = -ticks
                if ticks > 0 {
                    result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                    return false
                }
            }
            result.parsedTimeSpan._ticks = ticks
            return true
        }
        result.setFailure(FParseFailureKind.Format, "format data is bad")
        return false
    }
    func processTerminal_HMSD(_ raw: FTimeSpanRawInfo, _ style: FTimeSpanStandardStyles, _ result: FTimeSpanResult) -> Bool {
        if raw.sepCount != 4 || raw.numCount != 3 || style.flag(FTimeSpanStandardStyle.RequireFull) != 0 {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
        
        let inv = style.flag(FTimeSpanStandardStyle.Invariant) != 0
        let loc = style.flag(FTimeSpanStandardStyle.Localized) != 0
        var positive = false
        var match = false
        var ticks = 0
        var overflow = false
        if inv {
            if raw.fullHMSMatch(raw.positiveInvariant) {
                positive = true
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullDHMMatch(raw.positiveInvariant) {
                positive = true
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero, FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.partialAppCompatMatch(raw.positiveInvariant) {
                positive = true
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], FTimeSpanParse.ins.zero, raw.numbers[2])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullHMSMatch(raw.negativeInvariant) {
                positive = false
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullDHMMatch(raw.negativeInvariant) {
                positive = false
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero, FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.partialAppCompatMatch(raw.negativeInvariant) {
                positive = false
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], FTimeSpanParse.ins.zero, raw.numbers[2])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
        }
        if loc {
            if !match && raw.fullHMSMatch(raw.positiveLocalized) {
                positive = true
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullDHMMatch(raw.positiveLocalized) {
                positive = true
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero, FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.partialAppCompatMatch(raw.positiveLocalized) {
                positive = true
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], FTimeSpanParse.ins.zero, raw.numbers[2])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullHMSMatch(raw.negativeLocalized) {
                positive = false
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullDHMMatch(raw.negativeLocalized) {
                positive = false
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero, FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.partialAppCompatMatch(raw.negativeLocalized) {
                positive = false
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], FTimeSpanParse.ins.zero, raw.numbers[2])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
        }
        if match {
            if !positive {
                ticks = -ticks
                if ticks > 0 {
                    result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                    return false
                }
            }
            result.parsedTimeSpan._ticks = ticks
            return true
        }
        if overflow {
            result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
            return false
        } else {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
    }
    func processTerminal_HMSFD(_ raw: FTimeSpanRawInfo, _ style: FTimeSpanStandardStyles, _ result: FTimeSpanResult) -> Bool {
        if raw.sepCount != 5 || raw.numCount != 4 || style.flag(FTimeSpanStandardStyle.RequireFull) != 0 {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
        
        let inv = style.flag(FTimeSpanStandardStyle.Invariant) != 0
        let loc = style.flag(FTimeSpanStandardStyle.Localized) != 0
        var positive = false
        var match = false
        var ticks = 0
        var overflow = false
        if inv {
            if raw.fullHMSFMatch(raw.positiveInvariant) {
                positive = true
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], raw.numbers[2], raw.numbers[3])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullDHMSMatch(raw.positiveInvariant) {
                positive = true
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], raw.numbers[3], FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullAppCompatMatch(raw.positiveInvariant) {
                positive = true
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero, raw.numbers[3])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullHMSFMatch(raw.negativeInvariant) {
                positive = false
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], raw.numbers[2], raw.numbers[3])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullDHMSMatch(raw.negativeInvariant) {
                positive = false
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], raw.numbers[3], FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullAppCompatMatch(raw.negativeInvariant) {
                positive = false
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero, raw.numbers[3])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
        }
        if loc {
            if raw.fullHMSFMatch(raw.positiveLocalized) {
                positive = true
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], raw.numbers[2], raw.numbers[3])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullDHMSMatch(raw.positiveLocalized) {
                positive = true
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], raw.numbers[3], FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullAppCompatMatch(raw.positiveLocalized) {
                positive = true
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero, raw.numbers[3])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullHMSFMatch(raw.negativeLocalized) {
                positive = false
                let pair = tryTimeToTicks(positive, FTimeSpanParse.ins.zero, raw.numbers[0], raw.numbers[1], raw.numbers[2], raw.numbers[3])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullDHMSMatch(raw.negativeLocalized) {
                positive = false
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], raw.numbers[3], FTimeSpanParse.ins.zero)
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
            if !match && raw.fullAppCompatMatch(raw.negativeLocalized) {
                positive = false
                let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], FTimeSpanParse.ins.zero, raw.numbers[3])
                match = pair.0
                ticks = pair.1
                overflow = overflow || !match
            }
        }
        
        if match {
            if !positive {
                ticks = -ticks
                if ticks > 0 {
                    result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                    return false
                }
            }
            result.parsedTimeSpan._ticks = ticks
            return true
        }
        if overflow {
            result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
            return false
        } else {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
    }
    func processTerminal_DHMSF(_ raw: FTimeSpanRawInfo, _ style: FTimeSpanStandardStyles, _ result: FTimeSpanResult) -> Bool {
        if raw.sepCount != 6 || raw.numCount != 5 {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
        let inv = style.flag(FTimeSpanStandardStyle.Invariant) != 0
        let loc = style.flag(FTimeSpanStandardStyle.Localized) != 0
        var positive = false
        var match = false
        if inv {
            if raw.fullMatch(raw.positiveInvariant) {
                match = true
                positive = true
            }
            if !match && raw.fullMatch(raw.negativeInvariant) {
                match = true
                positive = false
            }
        }
        if loc {
            if raw.fullMatch(raw.positiveLocalized) {
                match = true
                positive = true
            }
            if !match && raw.fullMatch(raw.negativeLocalized) {
                match = true
                positive = false
            }
        }
        
        var ticks = 0
        if match {
            let pair = tryTimeToTicks(positive, raw.numbers[0], raw.numbers[1], raw.numbers[2], raw.numbers[3], raw.numbers[4])
            if !pair.0 {
                result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                return false
            }
            ticks = pair.1
            if !positive {
                ticks = -ticks
                if ticks > 0 {
                    result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
                    return false
                }
            }
            result.parsedTimeSpan._ticks = ticks
            return true
        }
        result.setFailure(FParseFailureKind.Format, "format data is bad")
        return false
    }
    func tryParseExactTimeSpan(_ input: String?, _ format: String?, _ fLocalize: FLocalize, _ styles: FTimeSpanStyles, _ result: FTimeSpanResult) -> Bool {
        guard let _ = input else {
            result.setFailure(FParseFailureKind.ArgumentNull, "argument is null")
            return false
        }
        guard let formatBuff = format else {
            result.setFailure(FParseFailureKind.ArgumentNull, "argument is null")
            return false
        }
        if formatBuff.isEmpty {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
        if formatBuff.count == 1 {
            var styleBuff = FTimeSpanStandardStyle.None.toS()
            if formatBuff[0] == "c".toChar || formatBuff[0] == "t".toChar || formatBuff[0] == "T" {
                return tryParseTimeSpanConstant(input, result)
            } else if formatBuff[0] == "g".toChar {
                styleBuff = styleBuff.and(FTimeSpanStandardStyle.Localized)
            } else if formatBuff[0] == "G".toChar {
                styleBuff = styleBuff.and(FTimeSpanStandardStyle.Localized).and(FTimeSpanStandardStyle.RequireFull)
            } else {
                result.setFailure(FParseFailureKind.Format, "format data is bad")
            }
            return tryParseTimeSpan(input, styleBuff, fLocalize, result)
        }
        
        return tryParseByFormat(input, format, styles, result)
    }
    func tryParseExactMultipleTimeSpan(_ input: String?, _ formats: [String?]?, _ fLocalize: FLocalize, _ styles: FTimeSpanStyles, _ result: FTimeSpanResult) -> Bool {
        guard let inputBuff = input else {
            result.setFailure(FParseFailureKind.ArgumentNull, "argument is null")
            return false
        }
        guard let formatBuffs = formats else {
            result.setFailure(FParseFailureKind.ArgumentNull, "argument is null")
            return false
        }
        if inputBuff.isEmpty {
            result.setFailure(FParseFailureKind.Format, "argument data is bad")
            return false
        }
        if formatBuffs.isEmpty {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
        
        for formatBuff in formatBuffs {
            guard let x = formatBuff else {
                result.setFailure(FParseFailureKind.Format, "format data is bad")
                break
            }
            let innerResult = FTimeSpanResult()
            if tryParseExactTimeSpan(input, x, fLocalize, styles, innerResult) {
                result.parsedTimeSpan = innerResult.parsedTimeSpan
                return true
            }
        }
        
        result.setFailure(FParseFailureKind.Format, "format data is bad")
        return false
    }
    func tryParseTimeSpanConstant(_ input: String?, _ result: FTimeSpanResult) -> Bool {
        return FStringParser().tryParse(input, result)
    }
    func tryParseByFormat(_ input: String?, _ format: String?, _ styles: FTimeSpanStyles, _ result: FTimeSpanResult) -> Bool {
        guard let inputBuff = input else {
            result.setFailure(FParseFailureKind.ArgumentNull, "argument is null")
            return false
        }
        guard let formatBuff = input else {
            result.setFailure(FParseFailureKind.ArgumentNull, "format is null")
            return false
        }
        if inputBuff.isEmpty {
            result.setFailure(FParseFailureKind.Format, "argument data is bad")
            return false
        }
        if formatBuff.isEmpty {
            result.setFailure(FParseFailureKind.Format, "format is bad")
            return false
        }
        
        var seenDD = false
        var seenHH = false
        var seenMM = false
        var seenSS = false
        var seenFF = false
        var dd = 0
        var hh = 0
        var mm = 0
        var ss = 0
        var leadingZeroes = 0
        var ff = 0
        var i = 0
        var tokenLen = 0
        
        let tokenizer = FTimeSpanTokenizer().initThis(-1, inputBuff)
        while i < formatBuff.count {
            let ch = formatBuff[i]
            var nextFormatChar = 0
            switch ch {
            case "h".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, i, ch)
                let pair = parseExactDigits(tokenizer, tokenLen)
                if tokenLen > 2 || seenHH || !pair.0 {
                    result.setFailure(FParseFailureKind.Format, "format data is bad")
                    return false
                }
                hh = pair.1
                seenHH = true
                break
            case "m".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, i, ch)
                let pair = parseExactDigits(tokenizer, tokenLen)
                if tokenLen > 2  || seenMM || !pair.0 {
                    result.setFailure(FParseFailureKind.Format, "format data is bad")
                    return false
                }
                mm = pair.1
                seenMM = true
                break
            case "c".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, i, ch)
                let pair = parseExactDigits(tokenizer, tokenLen)
                if tokenLen > 2  || seenSS || !pair.0 {
                    result.setFailure(FParseFailureKind.Format, "format data is bad")
                    return false
                }
                ss = pair.1
                seenSS = true
                break
            case "f".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, i, ch)
                let pair = parseExactDigits(tokenizer, tokenLen, tokenLen)
                if tokenLen > FDateTimeFormat.ins.maxSecondsFractionDigits || seenFF || !pair.0 {
                    result.setFailure(FParseFailureKind.Format, "format data is bad")
                    return false
                }
                leadingZeroes = pair.1
                ff = pair.2
                seenFF = true
                break
            case "F".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, i, ch)
                if tokenLen > FDateTimeFormat.ins.maxSecondsFractionDigits || seenFF {
                    result.setFailure(FParseFailureKind.Format, "format data is bad")
                    return false
                }
                ff = parseExactDigits(tokenizer, tokenLen, tokenLen).2
                seenFF = true
                break
            case "d".toChar:
                tokenLen = FDateTimeFormat.ins.parseRepeatPattern(formatBuff, i, ch)
                let pair = parseExactDigits(tokenizer, tokenLen < 2 ? 1 : tokenLen, tokenLen < 2 ? 8 : tokenLen)
                if tokenLen > 8 || seenDD || !pair.0 {
                    result.setFailure(FParseFailureKind.Format, "format data is bad")
                }
                dd = pair.2
                seenDD = true
                break
            case "'".toChar, "\"".toChar:
                var enquotedString = ""
                let pair = FDateTimeParse.ins.tryParseQuoteString(formatBuff, i, &enquotedString)
                if !pair.0 {
                    result.setFailure(FParseFailureKind.FormatWithParameter, "format dat is bad")
                    return false
                }
                if !parseExactLiteral(tokenizer, enquotedString) {
                    result.setFailure(FParseFailureKind.Format, "format data is bad")
                    return false
                }
                break
            case "%".toChar:
                nextFormatChar = FDateTimeFormat.ins.parseNextChar(formatBuff, i)
                if nextFormatChar >= 0 && nextFormatChar != "%".toChar.toInt {
                    tokenLen = 1
                } else {
                    result.setFailure(FParseFailureKind.Format, "format data is bad")
                    return false
                }
                break
            case "\\".toChar:
                nextFormatChar = FDateTimeFormat.ins.parseNextChar(formatBuff, i)
                if nextFormatChar >= 0 && tokenizer.nextChar == nextFormatChar.toChar {
                    tokenLen = 2
                } else {
                    result.setFailure(FParseFailureKind.Format, "format data is bad")
                    return false
                }
            default:
                result.setFailure(FParseFailureKind.Format, "format data is bad")
                return false
            }
            i += tokenLen
        }
        
        if !tokenizer.eol {
            result.setFailure(FParseFailureKind.Format, "format data is bad")
            return false
        }
        
        var ticks = 0
        let positive = styles == FTimeSpanStyles.None
        let pairSub = tryTimeToTicks(positive, FTimeSpanToken(dd), FTimeSpanToken(hh), FTimeSpanToken(mm), FTimeSpanToken(ss), FTimeSpanToken(leadingZeroes, ff))
        ticks = pairSub.1
        if pairSub.0 {
            if !positive {
                ticks = -ticks
            }
            result.parsedTimeSpan._ticks = ticks
            return true
        } else {
            result.setFailure(FParseFailureKind.OverFlow, "data is overflow")
            return false
        }
    }
}
