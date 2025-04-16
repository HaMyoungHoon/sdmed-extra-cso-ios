import Foundation

open class FLocalize {
    static let KOREA = FLocalize()
    static let KOREA_LUNA = FLocalize()
    static let USA = FLocalize()
    
    static func parseThis(_ lang: String) -> FLocalize {
        switch lang {
        case "en": return FLocalize.USA
            default : return FLocalize.KOREA
        }
    }
    
    private var _fullTimeSpanPositivePattern: String? = nil
    var fullTimeSpanPositivePattern: String {
        if _fullTimeSpanPositivePattern == nil {
            let decimalSeparator = "."
            _fullTimeSpanPositivePattern = "d':'h':'mm':'ss\(decimalSeparator)FFFFFFF"
        }
        return _fullTimeSpanPositivePattern!
    }

    private var _fullTimeSpanNegativePattern: String? = nil
    var fullTimeSpanNegativePattern: String {
        if _fullTimeSpanNegativePattern == nil {
            _fullTimeSpanNegativePattern = "'-'\(fullTimeSpanPositivePattern)"
        }
        return _fullTimeSpanNegativePattern!
    }

    func getCultureInfo() -> String {
        if self === FLocalize.KOREA {
            return "ko-kr"
        } else if self === FLocalize.KOREA_LUNA {
            return "ko-kr-luna"
        }
        return "en-us"
    }

    func getCultureName() -> String {
        if self === FLocalize.KOREA {
            return "한국어"
        } else if self === FLocalize.KOREA_LUNA {
            return "한국어 (음력)"
        }
        return "English (US)"
    }

    func getDateTimeOffset() -> String {
        if self === FLocalize.KOREA || self === FLocalize.KOREA_LUNA {
            return "yyyy-MM-dd hh:mm:ss (ddd)"
        }
        return "MM-dd-yyyy hh:mm:ss (ddd)"
    }

    private func cvtLunarDay(_ solarDate: FDateTime) -> FDateTime {
        let isLeap = FDateTime.isLeapYear(solarDate.year)
        let solarDay = isLeap ? FDateTime._daysToMonth366[solarDate.month - 1] + solarDate.day : FDateTime._daysToMonth365[solarDate.month - 1] + solarDate.day
        var jan1Month = 0
        var jan1Date = 0
        var lunarDay = solarDay
        var lunarYear = solarDate.year
        if lunarYear == (getMaxCalendarYear() + 1) {
            lunarYear -= 1
            lunarDay += FDateTime.isLeapYear(lunarYear) ? 366 : 365
            jan1Month = FKoreanLunaModel.ins.getYearInfo(lunarYear, FKoreanLunaModel.ins.jan1Month)
            jan1Date = FKoreanLunaModel.ins.getYearInfo(lunarYear, FKoreanLunaModel.ins.jan1Date)
        } else {
            jan1Month = FKoreanLunaModel.ins.getYearInfo(lunarYear, FKoreanLunaModel.ins.jan1Month)
            jan1Date = FKoreanLunaModel.ins.getYearInfo(lunarYear, FKoreanLunaModel.ins.jan1Date)
            if (solarDate.month < jan1Month || (solarDate.month == jan1Month && solarDate.day < jan1Date)) {
                lunarYear -= 1
                lunarDay += FDateTime.isLeapYear(lunarYear) ? 366 : 365
                jan1Month = FKoreanLunaModel.ins.getYearInfo(lunarYear, FKoreanLunaModel.ins.jan1Month)
                jan1Date = FKoreanLunaModel.ins.getYearInfo(lunarYear, FKoreanLunaModel.ins.jan1Date)
            }
        }

        lunarDay -= FDateTime._daysToMonth365[jan1Month - 1]
        lunarDay -= (jan1Date - 1)

        var mask = 0x8000
        let yearInfo = FKoreanLunaModel.ins.getYearInfo(lunarYear, FKoreanLunaModel.ins.daysPerMonth)
        var days = (yearInfo & mask) != 0 ? 30 : 29
        var lunarMonth = 1
        while (lunarDay > days) {
            lunarDay -= days
            lunarMonth += 1
            mask = mask >> 1
            days = (yearInfo & mask) != 0 ? 30 : 29
        }

        return FDateTime().setThis(lunarYear, lunarMonth, lunarDay)
    }
    
    func getYear(_ solarDate: FDateTime, _ withString: Bool) -> String {
        if self === FLocalize.KOREA {
            return withString ? "\(solarDate.year)년" : "\(solarDate.year)"
        } else if self === FLocalize.KOREA_LUNA {
            return withString ? "\(cvtLunarDay(solarDate).year)년" : "\(cvtLunarDay(solarDate).year)"
        }
        return "\(solarDate.year),"
    }

    func getYear(_ solarDate: FDateTime) -> Int {
        if self === FLocalize.KOREA_LUNA {
            return cvtLunarDay(solarDate).year
        }
        return solarDate.year
    }

    func getMonth(_ solarDate: FDateTime) -> Int {
        if self === FLocalize.KOREA_LUNA {
            return cvtLunarDay(solarDate).month
        }
        return solarDate.month
    }

    func getMonth(_ month: Int, _ isDDD: Bool) -> String {
        if self === FLocalize.KOREA || self === FLocalize.KOREA_LUNA {
            return isDDD ? String(format: "%02d월", month) : "\(month)월"
        }
        switch month {
        case 1:
            return isDDD ? "Jan" : "January"
        case 2:
            return isDDD ? "Feb" : "February"
        case 3:
            return isDDD ? "Mar" : "March"
        case 4:
            return isDDD ? "Apr" : "April"
        case 5:
            return isDDD ? "May" : "May"
        case 6:
            return isDDD ? "Jun" : "June"
        case 7:
            return isDDD ? "Jul" : "July"
        case 8:
            return isDDD ? "Aug" : "August"
        case 9:
            return isDDD ? "Sep" : "September"
        case 10:
            return isDDD ? "Oct" : "October"
        case 11:
            return isDDD ? "Nov" : "November"
        case 12:
            return isDDD ? "Dec" : "December"
        default:
            FException.FAssert.notDefined("illegal data month : \(month)")
        }
        return ""
    }
    func getMonth(_ solarDate: FDateTime, _ isDDD: Bool) -> String {
        return getMonth(solarDate.month, isDDD)
    }
    func getDay(_ day: Int, _ isDDD: Bool) -> String {
        if (self === FLocalize.KOREA || self === FLocalize.KOREA_LUNA) {
            return isDDD ? String(format: "%02d일", day) : "\(day)일"
        }
        if (!isDDD) {
            return "\(day)"
        }
        switch day % 10 {
        case 1: return String(format: "%02", day) + "st"
        case 2: return String(format: "%02", day) + "nd"
        case 3: return String(format: "%02", day) + "rd"
        default: return String(format: "%02", day) + "th"
        }
    }
    func getDay(_ solarDate: FDateTime, _ isDDD: Bool) -> String {
        return getDay(solarDate.day, isDDD)
    }
    func getDayOfMonth(_ solarDate: FDateTime) -> Int {
        if (self === FLocalize.KOREA_LUNA) {
            return cvtLunarDay(solarDate).day
        }
        
        return solarDate.day
    }

    func getDayOfWeek(_ dayOfWeek: Int, _ isDDD: Bool = false) -> String {
        let fDayOfWeek = FDayOfWeek.fromInt(dayOfWeek)
        if self === FLocalize.KOREA || self === FLocalize.KOREA_LUNA {
            switch fDayOfWeek {
            case FDayOfWeek.SUNDAY: return isDDD ? "일요일" : "일"
            case FDayOfWeek.MONDAY: return isDDD ? "월요일" : "월"
            case FDayOfWeek.TUESDAY: return isDDD ? "화요일" : "화"
            case FDayOfWeek.WEDNESDAY: return isDDD ? "수요일" : "수"
            case FDayOfWeek.THURSDAY: return isDDD ? "목요일" : "목"
            case FDayOfWeek.FRIDAY: return isDDD ? "금요일" : "금"
            case FDayOfWeek.SATURDAY: return isDDD ? "토요일" : "토"
            default: FException.FAssert.notDefined("illegal data day of week : \(dayOfWeek)")
            }
            return ""
        }
        switch fDayOfWeek {
        case FDayOfWeek.SUNDAY: return isDDD ? "Sunday" : "Sun"
        case FDayOfWeek.MONDAY: return isDDD ? "Monday" : "Mon"
        case FDayOfWeek.TUESDAY: return isDDD ? "Tuesday" : "Tues"
        case FDayOfWeek.WEDNESDAY: return isDDD ? "Wednesday" : "Wed"
        case FDayOfWeek.THURSDAY: return isDDD ? "Thursday" : "Thur"
        case FDayOfWeek.FRIDAY: return isDDD ? "Friday" : "Fri"
        case FDayOfWeek.SATURDAY: return isDDD ? "Saturday" : "Sat"
        default: FException.FAssert.notDefined("illegal data day of week : \(dayOfWeek)")
        }
        return ""
    }
    func getDayOfWeek(_ fDayOfWeek: FDayOfWeek, _ isDDD: Bool = false) -> String {
        if (self === FLocalize.KOREA || self === FLocalize.KOREA_LUNA) {
            switch fDayOfWeek {
            case FDayOfWeek.SUNDAY: return isDDD ? "일요일" : "일"
            case FDayOfWeek.MONDAY: return isDDD ? "월요일" : "월"
            case FDayOfWeek.TUESDAY: return isDDD ? "화요일" : "화"
            case FDayOfWeek.WEDNESDAY: return isDDD ? "수요일" : "수"
            case FDayOfWeek.THURSDAY: return isDDD ? "목요일" : "목"
            case FDayOfWeek.FRIDAY: return isDDD ? "금요일" : "금"
            case FDayOfWeek.SATURDAY: return isDDD ? "토요일" : "토"
            default: FException.FAssert.notDefined("illegal data day of week : \(fDayOfWeek)")
            }
            return ""
        }
        switch fDayOfWeek {
        case FDayOfWeek.SUNDAY: return isDDD ? "Sunday" : "Sun"
        case FDayOfWeek.MONDAY: return isDDD ? "Monday" : "Mon"
        case FDayOfWeek.TUESDAY: return isDDD ? "Tuesday" : "Tues"
        case FDayOfWeek.WEDNESDAY: return isDDD ? "Wednesday" : "Wed"
        case FDayOfWeek.THURSDAY: return isDDD ? "Thursday" : "Thur"
        case FDayOfWeek.FRIDAY: return isDDD ? "Friday" : "Fri"
        case FDayOfWeek.SATURDAY: return isDDD ? "Saturday" : "Sat"
        default: FException.FAssert.notDefined("illegal data day of week : \(fDayOfWeek)")
        }
        return ""
    }
    func getDayOfWeek(_ solarDate: FDateTime, _ isDDD: Bool = false) -> String {
        return getDayOfWeek(solarDate.dayOfWeek, isDDD)
    }
    func getAM() -> String {
        if (self === FLocalize.KOREA || self === FLocalize.KOREA_LUNA) {
            return "오전"
        }
        
        return "AM"
    }
    func getPM() -> String {
        if (self === FLocalize.KOREA || self === FLocalize.KOREA_LUNA) {
            return "오후"
        }
        
        return "PM"
    }
    private func getMaxCalendarYear() -> Int {
        if (self === FLocalize.KOREA || self === FLocalize.KOREA_LUNA) {
            return FKoreanLunaModel.ins.maxLunaYear
        }
        return FKoreanLunaModel.ins.maxGregorianYear
    }
}
