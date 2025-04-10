public struct FLunaDateModel {
    var lm: Int = 0
    var lunaMonth: Int = 0
    var lunaDay: Int = 0
    var daysPerMonth: Int = 0
    
    init(_ lm: Int, _ lunaMonth: Int, _ lunaDay: Int, _ daysPerMonth: Int) {
        self.lm = lm
        self.lunaMonth = lunaMonth
        self.lunaDay = lunaDay
        self.daysPerMonth = daysPerMonth
    }

    func getItem(_ index: Int) -> Int {
        switch index {
        case 0:
            return lm
        case 1:
            return lunaMonth
        case 2:
            return lunaDay
        default:
            return daysPerMonth
        }
    }
}
