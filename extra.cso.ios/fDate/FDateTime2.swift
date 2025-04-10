import Foundation

open class FDateTime2: Equatable, Hashable {
    var _thisDate = "9999-12-31"
    var _splitChar = "-"
    var _error = ""
    open func setThis(_ data: FDateTime2?) -> FDateTime2 {
        guard let dataBuff = data else {
            return self
        }
        self._thisDate = dataBuff._thisDate
        self._splitChar = dataBuff._splitChar
        self._error = dataBuff._error
        return self
    }
    open func setThis(_ dateString: String, _ splitChar: String = "-") -> FDateTime2 {
        _thisDate = dateString
        _splitChar = splitChar
        return self
    }
    open func setThis(_ year: Int, _ month: Int, _ day: Int, _ splitChar: String = "-") -> FDateTime2 {
        return self.setYear(year).setMonth(month).setDay(day).setSplitChar(splitChar)
    }
    open func setThis(_ data: Int) -> FDateTime2 {
        let timeZoneOffset = (TimeZone.current.secondsFromGMT() / 60 / 60) + (data / 60 / 60)
        let elapseDay = timeZoneOffset / 24
        return self.setThis(1970, 1, 1).addDays(elapseDay)
    }
    func getDate() -> String {
        return _thisDate
    }
    func getSplitChar() -> String {
        return _splitChar
    }
    open func setError(_ msg: String?) -> FDateTime2 {
        self._error = msg ?? "null"
        return self
    }
    open func setSplitChar(_ splitChar: String) -> FDateTime2 {
        self._thisDate = self._thisDate.replace(self._splitChar, splitChar)
        self._splitChar = splitChar
        return self
    }
    func getDoomsDay() -> FDayOfWeek {
        return getDoomsDay(getYear())
    }
    func getDoomsDay(_ year: String) -> FDayOfWeek {
        return getDoomsDay(year.toInt)
    }
    func getDoomsDay(_ year: Int) -> FDayOfWeek {
        let century = year / 100
        let yearInCentury = year % 100
        let dayOfWeek = {
            switch century % 4 {
            case 0: return FDayOfWeek.TUESDAY
            case 1: return FDayOfWeek.SUNDAY
            case 2: return FDayOfWeek.FRIDAY
            case 3: return FDayOfWeek.WEDNESDAY
            default: fatalError("getDoomsDay error year : \(year)")
            }
        }
        let yearAnchor = yearInCentury / 12
        let yearRemainder = yearInCentury % 12
        let remainderAnchor = yearRemainder / 4
        return {
            switch (dayOfWeek().rawValue + yearAnchor + yearRemainder + remainderAnchor) % 7 {
            case 0: return FDayOfWeek.SUNDAY
            case 1: return FDayOfWeek.MONDAY
            case 2: return FDayOfWeek.TUESDAY
            case 3: return FDayOfWeek.WEDNESDAY
            case 4: return FDayOfWeek.THURSDAY
            case 5: return FDayOfWeek.FRIDAY
            case 6: return FDayOfWeek.SATURDAY
            default: fatalError("getDoomsDay error year : \(year)")
            }
        }()
    }
    func isBefore(_ dateString: String, _ splitChar: String = "-") -> Bool {
        let target = FDateTime2().setThis(dateString, splitChar)
        return isBefore(target)
    }
    func isBefore(_ target: FDateTime2) -> Bool {
        return getDaysBetween(target) > 0
    }
    func isLeapYear() -> Bool {
        isLeapYear(getYear())
    }
    func isLeapYear(_ year: String) -> Bool {
        return isLeapYear(year.toInt)
    }
    func isLeapYear(_ year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        }
        if year % 100 == 0 {
            return false
        }
        if year % 4 == 0 {
            return true
        }
        return false
    }
    func getDayOfWeek() -> FDayOfWeek {
        return getDayOfWeek(_thisDate, _splitChar)
    }
    func getDayOfWeek(_ dateString: String, _ splitChar: String = "-") -> FDayOfWeek {
        let year = getYear(dateString, splitChar)
        let month = getMonth(dateString, splitChar)
        let day = getDay(dateString, splitChar)
        let doomsSameDay = getDoomsSameDay(year, month)
        let plusDay = (day + 35 - doomsSameDay) % 7
        return FDayOfWeek.fromInt((getDoomsDay(year).rawValue + plusDay) % 7)
    }
    func getDaysBetween(_ dateString: String, _ splitChar: String = "-") -> Int {
        let target = FDateTime2().setThis(dateString, splitChar)
        return getDaysBetween(target)
    }
    func getDaysBetween(_ target: FDateTime2) -> Int {
        var targetYearDay = 0
        var thisYearDay = 0
        var diffYear = target.getYear() - self.getYear()
        if diffYear > 0 {
            for i in 0...diffYear {
                targetYearDay += isLeapYear(target.getYear() - i) ? 366 : 365
            }
            thisYearDay = isLeapYear(self.getYear()) ? 366 : 365
        } else if diffYear < 0 {
            diffYear = -diffYear
            for i in 0...diffYear {
                thisYearDay += isLeapYear(self.getYear() - i) ? 366 : 365
            }
            targetYearDay = isLeapYear(target.getYear()) ? 366 : 365
        }
        var targetMonthDay = 0
        var thisMonthDay = 0
        var diffMonth = target.getMonth() - self.getMonth()
        if diffMonth > 0 {
            for i in 1...diffMonth {
                targetMonthDay += getMaxDayOfMonth(self.getYear(), target.getMonth() - i)
            }
        } else if diffMonth < 0 {
            diffMonth = -diffMonth
            for i in 1...diffMonth {
                thisMonthDay += getMaxDayOfMonth(self.getYear(), self.getMonth() - i)
            }
        }
        let targetDay = target.getDay()
        let thisDay = getDay()
        return targetYearDay + targetMonthDay + targetDay - thisYearDay - thisMonthDay - thisDay
    }
    open func getNextOrSameDate(_ dayOfWeek: FDayOfWeek) -> FDateTime2 {
        return FDateTime2().setThis(getNextOrSameDate(self._thisDate, dayOfWeek, self._splitChar), self._splitChar)
    }
    open func getNextOrSameDay(_ dayOfWeek: FDayOfWeek) -> FDateTime2 {
        return FDateTime2().setThis(self._thisDate, self._splitChar).setDay(getNextOrSameDay(self._thisDate, dayOfWeek, self._splitChar))
    }
    func getNextOrSameDate(_ dateString: String, _ dayOfWeek: FDayOfWeek, _ splitChar: String = "-") -> String {
        let getDayOfWeek = getDayOfWeek(dateString, splitChar)
        var gapBuffer = dayOfWeek.rawValue - getDayOfWeek.rawValue
        if gapBuffer < 0 {
            gapBuffer += 7
        }
        return FDateTime2().setThis(dateString, splitChar).addDays(gapBuffer).getDate()
    }
    func getNextOrSameDay(_ dateString: String, _ dayOfWeek: FDayOfWeek, _ splitChar: String = "-") -> Int {
        let getDayOfWeek = getDayOfWeek(dateString, splitChar)
        var gapBuffer = dayOfWeek.rawValue - getDayOfWeek.rawValue
        if gapBuffer < 0 {
            gapBuffer += 7
        }
        return FDateTime2().setThis(dateString, splitChar).addDays(gapBuffer).getDay()
    }
    open func getPrevOrSameDate(_ dayOfWeek: FDayOfWeek) -> FDateTime2 {
        return FDateTime2().setThis(getPrevOrSameDate(self._thisDate, dayOfWeek, self._splitChar), self._splitChar)
    }
    open func getPrevOrSameDay(_ dayOfWeek: FDayOfWeek) -> FDateTime2 {
        return FDateTime2().setThis(self._thisDate, self._splitChar).setDay(getPrevOrSameDay(self._thisDate, dayOfWeek, self._splitChar))
    }
    func getPrevOrSameDate(_ dateString: String, _ dayOfWeek: FDayOfWeek, _ splitChar: String = "-") -> String {
        let getDayOfWeek = getDayOfWeek(dateString, splitChar)
        var gapBuffer = getDayOfWeek.rawValue - dayOfWeek.rawValue
        if gapBuffer < 0 {
            gapBuffer += 7
        }
        return FDateTime2().setThis(dateString, splitChar).addDays(-gapBuffer).getDate()
    }
    func getPrevOrSameDay(_ dateString: String, _ dayOfWeek: FDayOfWeek, _ splitChar: String = "-") -> Int {
        let getDayOfWeek = getDayOfWeek(dateString, splitChar)
        var gapBuffer = getDayOfWeek.rawValue - dayOfWeek.rawValue
        if gapBuffer < 0 {
            gapBuffer += 7
        }
        return FDateTime2().setThis(dateString, splitChar).addDays(-gapBuffer).getDay()
    }
    open func getFirstDayOfMonth(_ dayOfWeek: FDayOfWeek) -> FDateTime2 {
        return FDateTime2().setThis(getFirstDayOfMonth(self._thisDate, dayOfWeek, self._splitChar), self._splitChar)
    }
    func getFirstDayOfMonth(_ dateString: String, _ dayOfWeek: FDayOfWeek, _ splitChar: String = "-") -> String {
        let buff = FDateTime2().setThis(dateString, splitChar).setDay(1)
        let getDayOfWeek = buff.getDayOfWeek()
        let dayGap = getDayOfWeek.rawValue - dayOfWeek.rawValue
        let firstOfTheDay = dayGap > 0 ? 7 - dayGap : (dayGap == 0 ? 0 : -dayGap)
        return buff.setDay(firstOfTheDay + 1).getDate()
    }
    open func addYear(_ addYear: Int) -> FDateTime2 {
        self._thisDate = self.addYear(self._thisDate, addYear, self._splitChar)
        return self
    }
    func addYear(_ dateString: String, _ addYear: Int, _ splitChar: String = "-") -> String {
        var currentYear = getYear(dateString, splitChar) + addYear
        var currentMonth = getMonth(dateString, splitChar)
        var currentDay = getDay(dateString, splitChar)
        if currentYear <= 0 {
            currentYear = 9999
        }
        // 이거 2월 때문에 그런거
        let maxDay = getMaxDayOfMonth(currentYear, currentMonth)
        if currentDay > maxDay {
            currentDay -= maxDay
            currentMonth += 1
        }
        if currentMonth > 12 {
            currentYear += 1
            currentMonth = 1
        }
        return FDateTime2().setThis(currentYear, currentMonth, currentDay).getDate()
    }
    open func addMonth(_ addMonth: Int) -> FDateTime2 {
        self._thisDate = self.addMonth(self._thisDate, addMonth, self._splitChar)
        return self
    }
    func addMonth(_ dateString: String, _ addMonth: Int, _ splitChar: String = "-") -> String {
        var currentYear = getYear(dateString, splitChar)
        var currentMonth = getMonth(dateString, splitChar)
        var currentDay = getDay(dateString, splitChar)
        
        while true {
            if currentMonth > 12 {
                currentMonth -= 12
                currentYear += 1
            } else if currentMonth <= 0 {
                currentMonth += 12
                currentYear -= 1
                if currentYear <= 0 {
                    currentYear = 9999
                }
            } else {
                break
            }
        }
        
        let maxDay = getMaxDayOfMonth(currentYear, currentMonth)
        if currentDay > maxDay {
            currentDay -= maxDay
            currentMonth += 1
        }
        if currentMonth > 12 {
            currentYear += 1
            currentMonth = 1
        }
        return FDateTime2().setThis(currentYear, currentMonth, currentDay, splitChar).getDate()
    }
    open func addWeeks(_ addWeek: Int) -> FDateTime2 {
        self._thisDate = addWeeks(self._thisDate, addWeek, self._splitChar)
        return self
    }
    func addWeeks(_ dateString: String, _ addWeek: Int, _ splitChar: String = "-") -> String {
        return addDays(dateString, addWeek * 7, splitChar)
    }
    open func addDays(_ addDay: Int) -> FDateTime2 {
        self._thisDate = addDays(self._thisDate, addDay, self._splitChar)
        return self
    }
    func addDays(_ dateString: String, _ addDay: Int, _ splitChar: String = "-") -> String {
        var currentYear = getYear(dateString, splitChar)
        var currentMonth = getMonth(dateString, splitChar)
        var currentDay = (getDay(dateString, splitChar) + addDay)
        while true {
            let maxDay = getMaxDayOfYear(currentYear)
            if currentDay > maxDay {
                currentDay -= maxDay
                currentYear += 1
            } else {
                break
            }
        }
        while true {
            let maxDay = getMaxDayOfMonth(currentYear, currentMonth)
            if currentDay > maxDay {
                currentDay -= maxDay
                currentMonth += 1
            } else if currentDay <= 0 {
                currentMonth -= 1
                if currentMonth == 0 {
                    currentMonth = 12
                    currentYear -= 1
                    if currentYear <= 0 {
                        currentYear = 9999
                    }
                }
                currentDay += getMaxDayOfMonth(currentYear, currentMonth)
            } else {
                break
            }
            if currentMonth > 12 {
                currentYear += 1
                currentMonth = 1
            }
        }
        return FDateTime2().setThis(currentYear, currentMonth, currentDay, splitChar).getDate()
    }
    open func setYear(_ year: Int) -> FDateTime2 {
        return self.setThis(setYear(self._thisDate, year, self._splitChar))
    }
    open func setMonth(_ month: Int) -> FDateTime2 {
        return self.setThis(setMonth(self._thisDate, month, self._splitChar))
    }
    open func setDay(_ day: Int) -> FDateTime2 {
        return self.setThis(setDay(self._thisDate, day, self._splitChar))
    }
    open func setLastDay() -> FDateTime2 {
        return self.setThis(setDay(self._thisDate, getMaxDayOfMonth(), self._splitChar))
    }
    func getYear() -> Int {
        return getYear(self._thisDate, self._splitChar)
    }
    func getMonth() -> Int {
        return getMonth(self._thisDate, self._splitChar)
    }
    func getDay() -> Int {
        return getDay(self._thisDate, self._splitChar)
    }
    func setYear(_ dateString: String, _ year: Int, _ splitChar: String = "-") -> String {
        let splitData = dateString.split(separator: splitChar)
        if splitData.count != 3 {
            FException.FFatal.notDefined("setYear format illegal dateString : \(dateString), splitChar : \(splitChar)")
        }
        if year <= 0 {
            FException.FFatal.notDefined("setYear format illegal year : \(dateString)")
        }
        let month = getMonth(dateString, splitChar)
        let day = getDay(dateString, splitChar)
        return "\(year)\(splitChar)\(month)\(splitChar)\(day)"
    }
    func getYear(_ dateString: String, _ splitChar: String = "-") -> Int {
        let splitData = dateString.split(separator: splitChar)
        if splitData.count != 3 {
            FException.FFatal.notDefined("getYear format illegal dateString : \(dateString), splitChar : \(splitChar)")
        }
        let ret = splitData[0].toInt
        if ret <= 0 {
            FException.FFatal.notDefined("getYear format illegal dateString : \(dateString), splitChar : \(splitChar), year : \(ret)")
        }
        return ret
    }
    func getYearString(_ dateString: String, _ splitChar: String = "-") -> String {
        return getYear(dateString, splitChar).toString
    }
    func setMonth(_ dateString: String, _ month: Int, _ splitChar: String = "-") -> String {
        let splitData = dateString.split(separator: splitChar)
        if splitData.count != 3 {
            FException.FFatal.notDefined("setMonth format illegal dateString : \(dateString), splitChar : \(splitChar)")
        }
        if month <= 0 || month > 12 {
            FException.FFatal.notDefined("setMonth format illegal month : \(dateString)")
        }
        let year = getYear(dateString, splitChar)
        let monthString = String(format: "%02d", month)
        let day = getDay(dateString, splitChar)
        return "\(year)\(splitChar)\(monthString)\(splitChar)\(day)"
    }
    func getMonth(_ dateString: String, _ splitChar: String = "-") -> Int {
        let splitData = dateString.split(separator: splitChar)
        if splitData.count != 3 {
            FException.FFatal.notDefined("getMonth format illegal dateString : \(dateString), splitChar : \(splitChar)")
        }
        let ret = splitData[1].toInt
        if ret <= 0 || ret > 12 {
            FException.FFatal.notDefined("getMonth format illegal dateString : \(dateString), splitChar : \(splitChar), month : \(ret)")
        }
        return ret
    }
    func getMonthString(_ dateString: String, _ splitChar: String = "-") -> String {
        return getMonth(dateString, splitChar).toString
    }
    func setDay(_ dateString: String, _ day: Int, _ splitChar: String = "-") -> String {
        let splitData = dateString.split(separator: splitChar)
        if splitData.count != 3 {
            FException.FFatal.notDefined("setDay format illegal dateString : \(dateString), splitChar : \(splitChar)")
        }
        let year = getYear(dateString, splitChar)
        let month = getMonth(dateString , splitChar)
        let maxDay = getMaxDayOfMonth(year, month)
        if day <= 0 || day > maxDay {
            FException.FFatal.notDefined("setDay format illegal month : \(month), months MaxDay : \(maxDay), day : \(day)")
        }
        return "\(year)\(splitChar)\(month)\(splitChar)\(String(format:"%02d", day))"
    }
    func getDay(_ dateString: String, _ splitChar: String = "-") -> Int {
        let splitData = dateString.split(separator: splitChar)
        if splitData.count != 3 {
            FException.FFatal.notDefined("getDay format illegal dateString : \(dateString), splitChar : \(splitChar)")
        }
        let year = getYear(dateString, splitChar)
        let month = getMonth(dateString, splitChar)
        let maxDay = getMaxDayOfMonth(year, month)
        let ret = splitData[2].toInt
        if ret <= 0 || ret > maxDay {
            FException.FFatal.notDefined("getDay format illegal dateString : \(dateString), splitChar : \(splitChar), day : \(ret)")
        }
        return ret
    }
    func getDayString(_ dateString: String, _ splitChar: String = "-") -> String {
        return getDay(dateString, splitChar).toString
    }
    func getMaxDayOfYear(_ year: Int) -> Int {
        if isLeapYear(year) {
            return 366
        } else {
            return 365
        }
    }
    func getMaxDayOfMonth(_ year: Int, _ month: Int) -> Int {
        switch month {
        case 1: return 31
        case 2: if isLeapYear(year) {
            return 29
        } else {
            return 28
        }
        case 3: return 31
        case 4: return 30
        case 5: return 31
        case 6: return 30
        case 7: return 31
        case 8: return 31
        case 9: return 30
        case 10: return 31
        case 11: return 30
        case 12: return 31
        default: FException.FFatal.notDefined("getMaxDayOfMonth month : \(month)")
        }
        return 0
    }
    func getMaxDayOfMonth() -> Int {
        return getMaxDayOfMonth(getYear(), getMonth())
    }
    func getDoomsSameDay(_ year: Int, _ month: Int) -> Int {
        switch month {
        case 1: if isLeapYear(year) {
            return 4
        } else {
            return 3
        }
        case 2: if isLeapYear(year) {
            return 29
        } else {
            return 28
        }
        case 3: return 0
        case 4: return 4
        case 5: return 9
        case 6: return 6
        case 7: return 11
        case 8: return 8
        case 9: return 5
        case 10: return 10
        case 11: return 7
        case 12: return 12
        default: FException.FFatal.notDefined("getDoomsSameDay month : \(month)")
        }
        return 0
    }
    
    public static func == (_ lhs: FDateTime2, _ rhs: FDateTime2) -> Bool {
        if lhs.getYear() != rhs.getYear() {
            return false
        }
        if lhs.getMonth() != rhs.getMonth() {
            return false
        }
        if lhs.getDay() != rhs.getDay() {
            return false
        }
        
        return true
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(getYear())
        hasher.combine(getMonth())
        hasher.combine(getDay())
    }
}
