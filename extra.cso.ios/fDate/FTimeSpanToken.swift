import Foundation

public class FTimeSpanToken {
    var ttt: FTimeSpanTokenTypes
    var num: Int
    var zeroes: Int
    var sep: String?
    
    init() {
        ttt = FTimeSpanTokenTypes.Num
        num = 0
        zeroes = 0
        sep = nil
    }
    init(_ number: Int) {
        ttt = FTimeSpanTokenTypes.Num
        num = number
        zeroes = 0
        sep = nil
    }
    init(_ number: Int, _ leadingZeroes: Int) {
        ttt = FTimeSpanTokenTypes.Num
        num = number
        zeroes = leadingZeroes
        sep = nil
    }
    func isInvalidNumber(_ maxValue: Int, _ maxPrecision: Int) -> Bool {
        if num > maxValue { return true }
        if maxPrecision == FTimeSpanParse.ins.unlimitedDigits { return false }
        if zeroes > maxPrecision { return true }
        if num == 0 || zeroes == 0 { return false }
        return num >= (maxValue.toDouble / pow(10.0, (zeroes - 1).toDouble)).toInt
    }
}
