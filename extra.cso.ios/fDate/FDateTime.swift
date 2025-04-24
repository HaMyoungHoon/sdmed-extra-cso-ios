import Foundation

public class FDateTime {
    let _ticksMask: Int64 = Int64(bitPattern: 0x3FFFFFFFFFFFFFFF)
    let _flagsMask: Int64 = Int64(bitPattern: 0xC000000000000000)
    let _ticksPerMillisecond: Int = 10000
    var _ticksPerSecond: Int { return _ticksPerMillisecond * 1000 }
    var _ticksPerMinute: Int { return _ticksPerSecond * 60 }
    var _ticksPerHour: Int { return _ticksPerMinute * 60 }
    var _ticksPerDay: Int{ return _ticksPerHour * 24 }
    let _millisPerSecond: Int = 1000
    var _millisPerMinute: Int { return _millisPerSecond * 60 }
    var _millisPerHour: Int { return _millisPerMinute * 60 }
    var _millisPerDay: Int { return _millisPerHour * 24 }
    let _daysPerYear: Int = 365
    var _daysPer4Years: Int { return _daysPerYear * 4 + 1 }
    var _daysPer100Years: Int { return _daysPer4Years * 25 - 1 }
    var _daysPer400Years: Int { return _daysPer100Years * 4 + 1 }
    var _daysTo1601: Int { return _daysPer400Years * 4 }
    var _daysTo1899: Int { return _daysPer400Years * 4 + _daysPer100Years * 3 - 367 }
    var _daysTo1970: Int { return _daysPer400Years * 4 + _daysPer100Years * 3 + _daysPer4Years * 17 + _daysPerYear }
    var _daysTo10000: Int { return _daysPer400Years * 25 - 366 }
    let _minTicks: Int = 0
    var _maxTicks: Int { return _daysTo10000 * _ticksPerDay - 1 }
    var _maxMillis: Int { return (_daysTo10000 * _millisPerDay) }
    var _fileTimeOffset: Int { return _daysTo1601 * _ticksPerDay }
    var _doubleDateOffset: Int { return _daysTo1899 * _ticksPerDay }
    var _oADateMinAsTicks: Int { return (_daysPer100Years - _daysPerYear) * _ticksPerDay }
    let _oADateMinAsDouble: Double = -657435.0
    let _oADateMaxAsDouble: Double = 2958466.0
    let _datePartYear: Int = 0
    let _datePartDayOfYear: Int = 1
    let _datePartMonth: Int = 2
    let _datePartDay: Int = 3

    private var _dateData: Int64 = 0
    private var _localize: FLocalize = FLocalize.KOREA
    var internalTicks: Int { return Int(_dateData & _ticksMask) }
    var internalKind: Int { return Int(_dateData & _flagsMask) }
    var millisecond: Int { return internalTicks / _ticksPerMillisecond % 1000 }
    var second: Int { return internalTicks / _ticksPerSecond % 60 }
    var minute: Int { return internalTicks / _ticksPerMinute % 60 }
    var hour: Int { return internalTicks / _ticksPerHour % 24 }
    static var _daysToMonth365: [Int] = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365]
    static var _daysToMonth366: [Int] = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366]
    
    static func isLeapYear(_ year: Int) -> Bool {
        if year % 400 == 0 { return true }
        if year % 100 == 0 { return false }
        if year % 4 == 0 { return true }
        return false
    }
    
    private func isLeapYear(_ year: Int) -> Bool {
        if year % 400 == 0 { return true }
        if year % 100 == 0 { return false }
        if year % 4 == 0 { return true }
        return false
    }
    
    static func daysInMonth(_ year: Int, _ month: Int) -> Int {
        if month < 1 || month > 12 {
            return -1
        }
        let days = isLeapYear(year) ? _daysToMonth366 : _daysToMonth365
        return days[month] - days[month - 1]
    }
    
    static func getMaxDayOfMonth(_ year: Int, _ month: Int) -> Int {
        switch month {
        case 1: return 31
        case 2: return isLeapYear(year) ? 29 : 28
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
        default: FException.FAssert.notDefined("getMaxDayOfMonth month : \(month)")
        }
        return 31
    }
    
    private func getDatePart(_ part: Int) -> Int {
        let ticks = internalTicks
        var n = (ticks / _ticksPerDay)
        let y400: Int = n / _daysPer400Years
        n -= y400 * _daysPer400Years
        var y100: Int = n / _daysPer100Years
        if y100 == 4 {
            y100 = 3
        }
        n -= y100 * _daysPer100Years
        let y4: Int = n / _daysPer4Years
        n -= y4 * _daysPer4Years
        var y1: Int = n / _daysPerYear
        if y1 == 4 {
            y1 = 3
        }
        if part == _datePartYear {
            return y400 * 400 + y100 * 100 + y4 * 4 + y1 + 1
        }
        n -= y1 * _daysPerYear
        if part == _datePartDayOfYear {
            return n + 1
        }
        let leapYear: Bool = y1 == 3 && (y4 != 24 || y100 == 3)
        let days = leapYear ? FDateTime._daysToMonth366 : FDateTime._daysToMonth365
        var m = (n >> 5) + 1
        while n >= days[m] {
            m += 1
        }
        
        return (part == _datePartMonth) ? m : n - days[m - 1] + 1
    }
    
    func getDatePart() -> (Int, Int, Int) {
        let ticks = internalTicks
        var n = ticks / _ticksPerDay
        let y400 = n / _daysPer400Years
        n -= y400 * _daysPer400Years
        var y100 = n / _daysPer100Years
        if (y100 == 4) { y100 = 3 }
        n -= y100 * _daysPer100Years
        let y4 = n / _daysPer4Years
        n -= y4 * _daysPer4Years
        var y1 = n / _daysPerYear
        if (y1 == 4) { y1 = 3 }
        let year = y400 * 400 + y100 * 100 + y4 * 4 + y1 + 1
        n -= y1 * _daysPerYear
        let leapYear = y1 == 3 && (y4 != 24 || y100 == 3)
        let days = leapYear ? FDateTime._daysToMonth366 : FDateTime._daysToMonth365
        var m = (n >> 5) + 1
        while (n >= days[m]) { m += 1 }
        let month = m
        let day = n - days[m - 1] + 1
        return (year, month, day)
    }
    
    var day: Int { return getDatePart(_datePartDay) }
    var dayOfWeek: FDayOfWeek { return FDayOfWeek.fromInt((internalTicks / _ticksPerDay + 1) % 7) }
    var dayOfYear: Int { return getDatePart(_datePartDayOfYear) }
    var month: Int { return getDatePart(_datePartMonth) }
    var year: Int { return getDatePart(_datePartYear) }
    
    
    func setThis(_ year: Int, _ month: Int, _ day: Int) -> FDateTime {
        self._dateData = dateToTicks(year, month, day)
        return self
    }
    func setThis(_ data: TimeInterval) -> FDateTime {
        let timeZone = TimeZone.current
        let timeZoneOffset = timeZone.secondsFromGMT() / 60 / 60
        _dateData = Int64(data.toInt * _ticksPerSecond) + dateToTicks(1970, 1, 1) + Int64(timeZoneOffset * _ticksPerHour)
        return self
    }
    func setThis(_ data: Int) -> FDateTime {
        let timeZone = TimeZone.current
        let timeZoneOffset = timeZone.secondsFromGMT() / 60 / 60
        _dateData = Int64(data * _ticksPerSecond) + dateToTicks(1970, 1, 1) + Int64(timeZoneOffset * _ticksPerHour)
        return self
    }
    func setThis(_ data: Date?) -> FDateTime {
        let dataBuff = data ?? Date()
        let timeZone = TimeZone.current
        let timeZoneOffset = timeZone.secondsFromGMT() / 60 / 60
        _dateData = Int64(dataBuff.timeIntervalSince1970.toInt * _ticksPerSecond) + dateToTicks(1970, 1, 1) + Int64(timeZoneOffset * _ticksPerHour)
        return self
    }
    func setThis(_ data: Int64) -> FDateTime {
        _dateData = data
        return self
    }
    func setThis(_ data: String?, _ localize: FLocalize = FLocalize.KOREA) -> FDateTime {
        guard let dataBuff = data, dataBuff.isEmpty == false else {
            return self
        }
        self._localize = localize
        self._dateData = FDateTimeParse.ins.parse(dataBuff, self._localize)._dateData
        return self
    }
    func setLocalize(_ data: FLocalize) -> FDateTime {
        self._localize = data
        return self
    }

    func dateToTicks(_ year: Int, _ month: Int, _ day: Int) -> Int64 {
        if (year < 1 || year > 9999 || month < 1 || month > 12 || day < 1) {
            FException.FAssert.notDefined("illegal format year : \(year), month : \(month), day : \(day)")
        }

        let days = isLeapYear(year) ? FDateTime._daysToMonth366 : FDateTime._daysToMonth365
        if (day > days[month] - days[month - 1]) {
            FException.FAssert.notDefined("illegal format year : \(year), month : \(month), day : \(day)")
        }

        return Int64(daysToYear(year) + days[month - 1] + day - 1) * Int64(_ticksPerDay)
    }
    func toString(_ format: String? = nil) -> String {
        return FDateTimeFormat.ins.format(self, format, _localize)
    }
    func toString(_ format: String? = nil, _ localize: FLocalize) -> String {
        return FDateTimeFormat.ins.format(self, format, localize)
    }
    func toDate() -> Date {
        let timeZone = TimeZone.current
        let timeZoneOffset = timeZone.secondsFromGMT() / 60 / 60
        let timeInterval = Double(_dateData - dateToTicks(1970, 1, 1) - Int64(timeZoneOffset * _ticksPerHour)) / Double(_ticksPerSecond)
        return Date(timeIntervalSince1970: timeInterval)
    }
    func getMonthOfFirstDay() -> FDateTime {
        return FDateTime().setThis(year, month, 1)
    }
    func getMonthOfLastDay() -> FDateTime {
        return FDateTime().setThis(year, month, FDateTime.getMaxDayOfMonth(year, month))
    }
    func getLocalizeYear(_ withString: Bool) -> String {
        return _localize.getYear(self, withString)
    }
    func getLocalizeMonth(_ isDDD: Bool) -> String {
        return _localize.getMonth(self, isDDD)
    }
    func getLocalizeMonth(_ month: Int, _ isDDD: Bool) -> String {
        return _localize.getMonth(month, isDDD)
    }
    func getLocalizeDay(_ isDDD: Bool) -> String {
        return _localize.getDay(self, isDDD)
    }
    func getLocalizeDay(_ day: Int, _ isDDD: Bool) -> String {
        return _localize.getDay(day, isDDD)
    }
    func getLocalizeDayOfWeek(_ isDDD: Bool) -> String {
        return _localize.getDayOfWeek(self, isDDD)
    }
    func getLocalizeDayOfWeek(_ dayOfWeek: Int, _ isDDD: Bool) -> String {
        return _localize.getDayOfWeek(dayOfWeek, isDDD)
    }
    func addTicks(_ value: Int) -> FDateTime {
        let ticks = internalTicks
        if (value > _maxTicks - ticks || value < _minTicks - ticks) {
            return self
        }

        return FDateTime().setThis(((ticks + value) | internalKind))
    }
    func addMonth(_ value: Int) -> FDateTime {
        if (value < -120000 || value > 120000) {
            return self
        }
        
        let yearMonthDay = getDatePart()
        var year = yearMonthDay.0
        var month = yearMonthDay.1
        var day = yearMonthDay.2

            let i = month - 1 + value
        if (i >= 0) {
            month = i % 12 + 1
            year = year + i / 12
        } else {
            month = 12 + (i + 1) % 12
            year = year + (i - 11) / 12
        }
        if (year < 1 || year > 9999) {
            return self
        }
        let days = FDateTime.daysInMonth(year, month)
        if (day > days) {
            day = days
        }
        
        return FDateTime().setThis(Int64((dateToTicks(year, month, day) + Int64(internalTicks % _ticksPerDay)) | Int64(internalKind)))
    }
    func addMinutes(_ value: Double) -> FDateTime {
        return add(value, _millisPerMinute)
    }
    private func daysToYear(_ year: Int) -> Int {
        let lastYear = year - 1
        let leapYear = 365 * 4 + 1
        let cent = lastYear / 100
        return lastYear * leapYear / 4 - cent + cent / 4
    }
    
    private func add(_ value: Double, _ scale: Int) -> FDateTime {
        let part = (value >= 0.0) ? 0.5 : -0.5
        let millis = (value * scale.toDouble + part)
        if (millis <= -_maxMillis.toDouble || millis >= _maxMillis.toDouble) {
            return self
        }
        return addTicks((millis * _ticksPerMillisecond.toDouble).toInt)
    }
}

