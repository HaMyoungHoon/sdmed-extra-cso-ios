public class FTimeSpanParse {
    static let ins = FTimeSpanParse()
    let unlimitedDigits = -1
    let maxfractionDigits = 7
    let maxDays: Int = 10675199
    let maxHours: Int = 23
    let maxMinutes: Int = 59
    let maxSeconds: Int = 59
    let maxFraction: Int = 9999999
    let zero: FTimeSpanToken = FTimeSpanToken(0)
}
