public class FTimeSpanRawInfo {
    var lastSeenTTT: FTimeSpanTokenTypes = FTimeSpanTokenTypes.None
    var tokenCount: Int = 0
    var sepCount: Int = 0
    var numCount: Int = 0
    var literals: [String] = ["", "", "", "", "", ""]
    var numbers: [FTimeSpanToken] = [FTimeSpanToken(), FTimeSpanToken(), FTimeSpanToken(), FTimeSpanToken(), FTimeSpanToken()]
    private var posLoc: FFormatLiterals? = nil
    private var negLoc: FFormatLiterals? = nil
    private var fullPosPattern: String = ""
    private var fullNegPattern: String = ""
    
    private let maxTokens = 11
    private let maxLiteralTokens = 6
    private let maxNumericTokens = 5
    var positiveInvariant: FFormatLiterals { return FTimeSpanFormat.ins.positiveInvariantFormatLiterals }
    var negativeInvariant: FFormatLiterals { return FTimeSpanFormat.ins.negativeInvariantFormatLiterals }
    var positiveLocalized: FFormatLiterals {
        if posLoc == nil {
            posLoc = FFormatLiterals().initThis(fullPosPattern, false)
        }
        return posLoc!
    }
    var negativeLocalized: FFormatLiterals {
        if negLoc == nil {
            negLoc = FFormatLiterals().initThis(fullNegPattern, false)
        }
        return negLoc!
    }
    
    func initThis(_ localize: FLocalize) -> FTimeSpanRawInfo {
        lastSeenTTT = FTimeSpanTokenTypes.None
        tokenCount = 0
        sepCount = 0
        numCount = 0
        literals = ["", "", "", "", "", ""]
        numbers = [FTimeSpanToken(), FTimeSpanToken(), FTimeSpanToken(), FTimeSpanToken(), FTimeSpanToken()]
        fullPosPattern = localize.fullTimeSpanPositivePattern
        fullNegPattern = localize.fullTimeSpanNegativePattern
        return self
    }
    func processToken(_ token: FTimeSpanToken, _ result: FTimeSpanResult) -> Bool {
        if token.ttt == FTimeSpanTokenTypes.NumOverFlow {
            result.setFailure(FParseFailureKind.OverFlow, "token is overflow")
            return false
        }
        if token.ttt != FTimeSpanTokenTypes.Sep && token.ttt != FTimeSpanTokenTypes.Num {
            result.setFailure(FParseFailureKind.Format, "token is bad format")
            return false
        }
        switch token.ttt {
            case FTimeSpanTokenTypes.Sep: if !addSep(token.sep, result) {
                return false
            }
            break
        case FTimeSpanTokenTypes.Num:
            if tokenCount == 0 {
                if !addSep("", result) {
                    return false
                }
            }
            if !addNum(token, result) {
                return false
            }
            break
        default:
            break
        }
        lastSeenTTT = token.ttt
        return true
    }
    func addSep(_ sep: String?, _ result: FTimeSpanResult) -> Bool {
        if sepCount >= maxLiteralTokens || tokenCount >= maxTokens {
            result.setFailure(FParseFailureKind.OverFlow, "token is overflow")
            return false
        }
        guard let sepBuff = sep else {
            result.setFailure(FParseFailureKind.ArgumentNull, "token is null")
            return false
        }
        literals[sepCount] = sepBuff
        sepCount += 1
        tokenCount += 1
        return true
    }
    func addNum(_ num: FTimeSpanToken, _ result: FTimeSpanResult) -> Bool {
        if numCount >= maxNumericTokens || tokenCount >= maxTokens {
            result.setFailure(FParseFailureKind.OverFlow, "token is overflow")
            return false
        }
        numbers[numCount] = num
        numCount += 1
        tokenCount += 1
        return true
    }
    func fullAppCompatMatch(_ pattern: FFormatLiterals) -> Bool {
        return sepCount == 5 &&
                numCount == 4 &&
                pattern.start == literals[0] &&
                pattern.dayHourSep == literals[1] &&
                pattern.hourMinuteSep == literals[2] &&
                pattern.appCompatLiteral == literals[3] &&
                pattern.end == literals[4]
    }
    func partialAppCompatMatch(_ pattern: FFormatLiterals) -> Bool {
        return sepCount == 4 &&
                numCount == 3 &&
                pattern.start == literals[0] &&
                pattern.hourMinuteSep == literals[1] &&
                pattern.appCompatLiteral == literals[2] &&
                pattern.end == literals[3]
    }
    func fullMatch(_ pattern: FFormatLiterals) -> Bool {
        return sepCount == maxLiteralTokens &&
                numCount == maxNumericTokens &&
                pattern.start == literals[0] &&
                pattern.dayHourSep == literals[1] &&
                pattern.hourMinuteSep == literals[2] &&
                pattern.minuteSecondSep == literals[3] &&
                pattern.secondFractionSep == literals[4] &&
                pattern.end == literals[5]
    }
    func fullDHMSMatch(_ pattern: FFormatLiterals) -> Bool {
        return sepCount == 5 &&
                numCount == 4 &&
                pattern.start == literals[0] &&
                pattern.dayHourSep == literals[1] &&
                pattern.hourMinuteSep == literals[2] &&
                pattern.minuteSecondSep == literals[3] &&
                pattern.end == literals[4]
    }
    func fullHMSFMatch(_ pattern: FFormatLiterals) -> Bool {
        return sepCount == 5 &&
                numCount == 4 &&
                pattern.start == literals[0] &&
                pattern.hourMinuteSep == literals[1] &&
                pattern.minuteSecondSep == literals[2] &&
                pattern.secondFractionSep == literals[3] &&
                pattern.end == literals[4]
    }
    func fullDHMMatch(_ pattern: FFormatLiterals) -> Bool {
        return sepCount == 4 &&
                numCount == 3 &&
                pattern.start == literals[0] &&
                pattern.dayHourSep == literals[1] &&
                pattern.hourMinuteSep == literals[2] &&
                pattern.end == literals[3]
    }
    func fullHMSMatch(_ pattern: FFormatLiterals) -> Bool {
        return sepCount == 4 &&
                numCount == 3 &&
                pattern.start == literals[0] &&
                pattern.hourMinuteSep == literals[1] &&
                pattern.minuteSecondSep == literals[2] &&
                pattern.end == literals[3]
    }
    func fullHMMatch(_ pattern: FFormatLiterals) -> Bool {
        return sepCount == 3 &&
                numCount == 2 &&
                pattern.start == literals[0] &&
                pattern.hourMinuteSep == literals[1] &&
                pattern.end == literals[2]
    }
    func fullDMatch(_ pattern: FFormatLiterals) -> Bool {
        return sepCount == 2 &&
                numCount == 1 &&
                pattern.start == literals[0] &&
                pattern.end == literals[1]
    }
}
