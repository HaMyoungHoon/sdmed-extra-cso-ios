class FCalendar2: FDateTime2 {
    var _startDayOfWeek: FDayOfWeek = FDayOfWeek.SUNDAY
    var _baseDay: FDayOfWeek = FDayOfWeek.WEDNESDAY
    
    func setThis(_ data: FCalendar2) -> FCalendar2 {
        _ = super.setThis(data)
        return self
    }
    override func setThis(_ data: FDateTime2?) -> FCalendar2 {
        _ = super.setThis(data)
        return self
    }
    override func setThis(_ dateString: String, _ splitChar: String) -> FCalendar2 {
        _ = super.setThis(dateString, splitChar)
        return self
    }
    override func setThis(_ year: Int, _ month: Int, _ day: Int, _ splitChar: String) -> FCalendar2 {
        _ = super.setThis(year, month, day, splitChar)
        return self
    }
    override func setThis(_ data: Int) -> FCalendar2 {
        _ = super.setThis(data)
        return self
    }
    override func setError(_ msg: String?) -> FCalendar2 {
        _ = super.setError(msg)
        return self
    }
    override func setSplitChar(_ splitChar: String) -> FDateTime2 {
        _ = super.setSplitChar(splitChar)
        return self
    }
    override func getNextOrSameDate(_ dayOfWeek: FDayOfWeek) -> FCalendar2 {
        return FCalendar2().setThis(super.getNextOrSameDate(dayOfWeek))
    }
    override func getNextOrSameDay(_ dayOfWeek: FDayOfWeek) -> FCalendar2 {
        return FCalendar2().setThis(self).setDay(super.getNextOrSameDay(dayOfWeek).getDay())
    }
    override func getPrevOrSameDate(_ dayOfWeek: FDayOfWeek) -> FCalendar2 {
        return FCalendar2().setThis(super.getPrevOrSameDate(dayOfWeek))
    }
    override func getPrevOrSameDay(_ dayOfWeek: FDayOfWeek) -> FCalendar2 {
        return FCalendar2().setThis(self).setDay(super.getPrevOrSameDay(dayOfWeek).getDay())
    }
    override func getFirstDayOfMonth(_ dayOfWeek: FDayOfWeek) -> FCalendar2 {
        return FCalendar2().setThis(super.getFirstDayOfMonth(dayOfWeek))
    }
    override func addYear(_ year: Int) -> FCalendar2 {
        _ = super.addYear(year)
        return self
    }
    override func addMonth(_ month: Int) -> FCalendar2 {
        _ = super.addMonth(month)
        return self
    }
    override func addDays(_ day: Int) -> FCalendar2 {
        _ = super.addDays(day)
        return self
    }
    override func setYear(_ year: Int) -> FCalendar2 {
        _ = super.setYear(year)
        return self
    }
    override func setMonth(_ month: Int) -> FCalendar2 {
        _ = super.setMonth(month)
        return self
    }
    override func setDay(_ day: Int) -> FCalendar2 {
        _ = super.setDay(day)
        return self
    }
    override func setLastDay() -> FCalendar2 {
        _ = super.setLastDay()
        return self
    }
    
    func setStartDayOfWeek(_ dayOfWeek: FDayOfWeek) -> FCalendar2 {
        self._startDayOfWeek = dayOfWeek
        return self
    }
    func setBaseDay(_ dayOfWeek: FDayOfWeek) -> FCalendar2 {
        self._baseDay = dayOfWeek
        return self
    }
    func getWeekNumberInWeek() -> String {
        let startDate = getPrevOrSameDate(_startDayOfWeek)
        let endDate = FCalendar2().setThis(startDate).addDays(6)
        let startMonth = startDate.getMonth()
        let endMonth = endDate.getMonth()
        var month = 1
        if endMonth == startMonth {
            month = endMonth
        } else {
            let baseDay = startDate.getNextOrSameDate(_baseDay)
            if baseDay.getMonth() == startMonth {
                month = startMonth
            } else {
                month = endMonth
            }
        }
        let weekNumberOfBaseDay = getWeekNumberOfBaseDay(startDate)
        if weekNumberOfBaseDay == 1 {
            return "\(endDate.getYear())\(_splitChar)\(String(format:"%02d", month)) \(weekNumberOfBaseDay)"
        } else {
            return "\(startDate.getYear())\(_splitChar)\(String(format:"%02d", month)) \(weekNumberOfBaseDay)"
        }
    }
    func getWeekNumberOfBaseDay(_ data: FCalendar2) -> Int {
        let baseDay = data.getNextOrSameDate(_baseDay)
        let current = baseDay.getFirstDayOfMonth(_baseDay)
        var count = 1
        while current.isBefore(baseDay) {
            _ = current.addWeeks(1)
            count += 1
        }
        return count
    }
    func getYearOfWEekList() -> [[FDateTime2]] {
        var ret: [[FDateTime2]] = []
        let buff = self.clone().setMonth(1).setDay(1)
        let year = buff.getYear()
        while year == buff.getYear() {
            ret.append(buff.getWeekList())
            _ = buff.addWeeks(1)
        }
        return ret
    }
    func getYearOfWeekListMid(_ count: Int = 1) -> [[FDateTime2]] {
        var ret: [[FDateTime2]] = []
        let buff = self.clone()
        _ = buff.addWeeks(-(count / 2))
        for _ in 0 ..< count {
            ret.append(buff.getWeekList())
            _ = buff.addWeeks(1)
        }
        return ret
    }
    func getYearOfMonthList() -> [[FDateTime2]] {
        var ret: [[FDateTime2]] = []
        let buff = self.clone().setMonth(1).setDay(1)
        let year = buff.getYear()
        while year == buff.getYear() {
            ret.append(buff.getMonthList())
            _ = buff.addMonth(1)
        }
        return ret
    }
    func getYearOfDayList() -> [FDateTime2] {
        var ret: [FDateTime2] = []
        let buff = self.clone().setMonth(1).setDay(1)
        let year = buff.getYear()
        while year == buff.getYear() {
            buff.getMonthList().forEach {
                ret.append($0)
            }
            _ = buff.addMonth(1)
        }
        return ret
    }
    func getYearOfCalendarMonthList() -> [[FDateTime2]] {
        var ret: [[FDateTime2]] = []
        let buff = self.clone().setMonth(1).setDay(1)
        let year = buff.getYear()
        while year == buff.getYear() {
            let month = buff.getMonth()
            var retBuff: [FDateTime2] = []
            var weekList = buff.getWeekList()
            while weekList.first(where: { $0.getMonth() == month }) != nil {
                retBuff.append(contentsOf: weekList)
                _ = buff.addWeeks(1)
                weekList = buff.getWeekList()
            }
            _ = buff.setDay(1)
            ret.append(retBuff)
        }
        return ret
    }
    func getYearOfCalendarMonthListMid(_ count: Int = 1) -> [[FDateTime2]] {
        var ret: [[FDateTime2]] = []
        let buff = self.clone().setDay(1)
        _ = buff.addMonth(-(count / 2))
        for _ in 0 ..< count {
            let month = buff.getMonth()
            var retBuff: [FDateTime2] = []
            var weekList = buff.getWeekList()
            while weekList.first(where: { $0.getMonth() == month}) != nil {
                retBuff.append(contentsOf: weekList)
                _ = buff.addWeeks(1)
                weekList = buff.getWeekList()
            }
            _ = buff.setDay(1)
            ret.append(retBuff)
        }
        return ret
    }
    func getMonthFirstFromCalendar() -> FDateTime2 {
        return FCalendar2().setThis(self).setDay(1).getWeekFirst()
    }
    func getMonthLastFromCalendar() -> FDateTime2 {
        return FCalendar2().setThis(self).setDay(getMaxDayOfMonth()).getWeekLast()
    }
    func getMonthList() -> [FDateTime2] {
        var ret: [FDateTime2] = []
        let startDate = FDateTime2().setThis(self).setDay(1)
        for i in 1 ... startDate.getMaxDayOfMonth() {
            ret.append(FDateTime2().setThis(startDate).setDay(i))
        }
        return ret
    }
    func getMonthListWithDayOfWeek(_ fLocalize: FLocalize = FLocalize.KOREA) -> [(String, String)] {
        var ret: [(String, String)] = []
        let startDate = FDateTime2().setThis(self).setDay(1)
        for i in 1 ... startDate.getMaxDayOfMonth() {
            let buff = FDateTime2().setThis(startDate).setDay(i)
            ret.append((buff.getDate(), fLocalize.getDayOfWeek(buff.getDayOfWeek())))
        }
        return ret
    }
    func getMonthList(_ year: Int, _ month: Int, _ splitChar: String = "-") -> [String] {
        var ret: [String] = []
        let startDate = FDateTime2().setThis(year, month, 1, splitChar)
        for i in 1 ... startDate.getMaxDayOfMonth() {
            ret.append(FDateTime2().setThis(startDate).setDay(i).getDate())
        }
        return ret
    }
    func getMonthListWithDayOfWeek(_ year: Int, _ month: Int, _ splitChar: String = "-", _ fLocalize: FLocalize = FLocalize.KOREA) -> [(String, String)] {
        var ret: [(String, String)] = []
        let startDate = FDateTime2().setThis(year, month, 1, splitChar)
        for i in 1 ... startDate.getMaxDayOfMonth() {
            let buff = FDateTime2().setThis(startDate).setDay(i)
            ret.append((buff.getDate(), fLocalize.getDayOfWeek(buff.getDayOfWeek())))
        }
        return ret
    }
    func getMonthList(_ dateString: String, _ splitChar: String = "-") -> [String] {
        var ret: [String] = []
        let startDate = FDateTime2().setThis(dateString, splitChar).setDay(1)
        for i in 1 ... startDate.getMaxDayOfMonth() {
            ret.append(FDateTime2().setThis(startDate).setDay(i).getDate())
        }
        return ret
    }
    func getMonthListWithDayOfWeek(_ dateString: String, _ splitChar: String = "-", _ fLocalize: FLocalize = FLocalize.KOREA) -> [(String, String)] {
        var ret: [(String, String)] = []
        let startDate = FDateTime2().setThis(dateString, splitChar).setDay(1)
        for i in 1 ... startDate.getMaxDayOfMonth() {
            let buff = FDateTime2().setThis(startDate).setDay(i)
            ret.append((buff.getDate(), fLocalize.getDayOfWeek(buff.getDayOfWeek())))
        }
        
        return ret
    }
    func getWeekFirst() -> FDateTime2 {
        return getPrevOrSameDate(_startDayOfWeek)
    }
    func getWeekLast() -> FDateTime2 {
        return getPrevOrSameDate(_startDayOfWeek).addDays(6)
    }
    func getWeekList() -> [FDateTime2] {
        var ret: [FDateTime2] = []
        let startDate = getPrevOrSameDate(_startDayOfWeek)
        for i in 0 ..< 7 {
            ret.append(FDateTime2().setThis(startDate).addDays(i))
        }
        return ret
    }
    func getDayOfWeekList() -> [FDayOfWeek] {
        var ret: [FDayOfWeek] = []
        var lastDayOfWeek = _startDayOfWeek
        ret.append(lastDayOfWeek)
        for _ in 1 ..< 7 {
            lastDayOfWeek = FDayOfWeek.next(lastDayOfWeek)
            ret.append(lastDayOfWeek)
        }
        return ret
    }
    func getWeekListWithDayOfWeek(_ fLocalize: FLocalize = FLocalize.KOREA) -> [(String, String)] {
        var ret: [(String, String)] = []
        let startDate = getPrevOrSameDate(_startDayOfWeek)
        for i in 0 ..< 7 {
            let buff = FDateTime2().setThis(startDate).addDays(i)
            ret.append((buff.getDate(), fLocalize.getDayOfWeek(buff.getDayOfWeek())))
        }
        return ret
    }
    func getWeekList(_ dateString: String, _ splitChar: String = "-") -> [String] {
        var ret: [String] = []
        let startDate = getPrevOrSameDate(dateString, _startDayOfWeek, splitChar)
        for i in 0 ..< 7 {
            ret.append(FDateTime2().setThis(startDate, splitChar).addDays(i).getDate())
        }
        return ret
    }
    func getWeekListWithDayOfWeek(_ dateString: String, _ splitChar: String = "-", _ fLocalize: FLocalize = FLocalize.KOREA) -> [(String, String)] {
        var ret: [(String, String)] = []
        let startDate = getPrevOrSameDate(dateString, _startDayOfWeek, splitChar)
        for i in 0 ..< 7 {
            let buff = FDateTime2().setThis(startDate, splitChar).addDays(i)
            ret.append((buff.getDate(), fLocalize.getDayOfWeek(buff.getDayOfWeek())))
        }
        return ret
    }
    
    func clone() -> FCalendar2 {
        return FCalendar2().setThis(self.getDate(), self.getSplitChar()).setStartDayOfWeek(self._startDayOfWeek).setBaseDay(self._baseDay)
    }
}
