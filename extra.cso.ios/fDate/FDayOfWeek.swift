import SwiftUI

public enum FDayOfWeek: Int {
    case NULL = -1
    case SUNDAY = 0
    case MONDAY = 1
    case TUESDAY = 2
    case WEDNESDAY = 3
    case THURSDAY = 4
    case FRIDAY = 5
    case SATURDAY = 6

    func parseColor() -> Color {
        switch self {
        case FDayOfWeek.NULL: FAppColor.foreground
        case FDayOfWeek.SUNDAY: FAppColor.sunday
        case FDayOfWeek.MONDAY: FAppColor.monday
        case FDayOfWeek.TUESDAY: FAppColor.tuesday
        case FDayOfWeek.WEDNESDAY: FAppColor.wednesday
        case FDayOfWeek.THURSDAY: FAppColor.thursday
        case FDayOfWeek.FRIDAY: FAppColor.friday
        case FDayOfWeek.SATURDAY: FAppColor.saturday
        }
    }
    static func fromInt(_ value: Int) -> FDayOfWeek {
        return FDayOfWeek(rawValue: value) ?? SUNDAY
    }

    static func fromString(_ value: String?) -> FDayOfWeek {
        guard let value = value, let intValue = Int(value) else {
            return SUNDAY
        }
        return FDayOfWeek(rawValue: intValue) ?? SUNDAY
    }
    static func next(_ value: FDayOfWeek) -> FDayOfWeek {
        if value.rawValue + 1 > 6 {
            return SUNDAY
        } else {
            return fromInt(value.rawValue + 1)
        }
    }
}
