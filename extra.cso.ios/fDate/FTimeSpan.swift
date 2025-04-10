open class FTimeSpan {
    static let ticksPerMillisecond = 10000
    static let ticksPerSecond = ticksPerMillisecond * 1000
    static let ticksPerMinute = ticksPerSecond * 60
    static let ticksPerHour = ticksPerMinute * 60
    static let ticksPerDay = ticksPerHour * 24

    private static let _millisecondsPerTick = 1.0 / ticksPerMillisecond.toDouble
    private static let _secondsPerTick =  1.0 / ticksPerSecond.toDouble
    private static let _minutesPerTick = 1.0 / ticksPerMinute.toDouble
    private static let _hoursPerTick = 1.0 / ticksPerHour.toDouble
    private static let _daysPerTick = 1.0 / ticksPerDay.toDouble
    private static let _millisPerSecond = 1000
    private static let _millisPerMinute = _millisPerSecond * 60
    private static let _millisPerHour = _millisPerMinute * 60
    private static let _millisPerDay = _millisPerHour * 24

    static let maxSeconds = Int.max / ticksPerSecond
    static let minSeconds = Int.max / ticksPerSecond
    static let maxMilliSeconds = Int.max / ticksPerMillisecond
    static let minMilliSeconds = Int.max / ticksPerMillisecond
    static let ticksPerTenthSecond = ticksPerMillisecond * 100

    static let Zero = FTimeSpan(0)
    static let MaxValue = FTimeSpan(Int.max)
    static let MINValue = FTimeSpan(Int.min)

    static func equals(_ timeSpan1: FTimeSpan, _ timeSpan2: FTimeSpan) -> Bool {
        timeSpan1.ticks == timeSpan2.ticks
    }
    
    static func fromTicks(_ value: Int) -> FTimeSpan {
        FTimeSpan(value)
    }
    static func fromDays(_ value: Double) -> FTimeSpan {
        return interval(value, _millisPerDay)
    }
    static func fromHours(_ value: Double) -> FTimeSpan {
        return interval(value, _millisPerHour)
    }
    static func fromMinutes(_ value: Double) -> FTimeSpan {
        return interval(value, _millisPerMinute)
    }
    static func fromSeconds(_ value: Double) -> FTimeSpan {
        return interval(value, _millisPerSecond)
    }
    static func fromMilliseconds(_ value: Double) -> FTimeSpan {
        return interval(value, 1)
    }
    
    private static func interval(_ value: Double, _ scale: Int) -> FTimeSpan {
        if value.isNaN {
            FException.FAssert.notDefined("illegal value cant be nan")
        }

        let temp = value * scale.toDouble
        let millis = temp + value >= 0 ? 0.5 : -0.5
        if (millis > (Int.max / ticksPerMillisecond).toDouble) {
            FException.FAssert.notDefined("illegal value overflow value : \(value), scale : \(scale)")
        }
        if (millis < (Int.min / ticksPerMillisecond).toDouble) {
            FException.FAssert.notDefined("illegal value underflow value : \(value), scale : \(scale)")
        }

        return FTimeSpan(millis.toInt * ticksPerMillisecond)
    }
    
    var _ticks: Int
    var ticks: Int { return _ticks }
    init (_ value: Int) {
        self._ticks = value
    }
    init (_ hours: Int, _ minutes: Int, _ seconds: Int) {
        _ticks = FTimeSpan.timeToTicks(hours, minutes, seconds)
    }
    init (_ days: Int, _ hours: Int, _ minutes: Int, _ seconds: Int) {
        _ticks = FTimeSpan.timeToTicks(days, hours, minutes, seconds, 0)
    }
    init (_ days: Int, _ hours: Int, _ minutes: Int, _ seconds: Int, _ milliseconds: Int) {
        _ticks = FTimeSpan.timeToTicks(days, hours, minutes, seconds, milliseconds)
    }
    var days: Int { return _ticks / FTimeSpan.ticksPerDay }
    var hours: Int { return (_ticks / FTimeSpan.ticksPerHour) % 24}
    var minutes: Int { return (_ticks / FTimeSpan.ticksPerMinute) % 60 }
    var seconds: Int { return (_ticks / FTimeSpan.ticksPerSecond) % 60 }
    var milliseconds: Int { return (_ticks / FTimeSpan.ticksPerMillisecond) % 1000 }
    var totalDays: Double { return _ticks.toDouble * FTimeSpan._daysPerTick }
    var totalHours: Double { return _ticks.toDouble * FTimeSpan._hoursPerTick }
    var totalMinutes: Double { return _ticks.toDouble * FTimeSpan._minutesPerTick }
    var totalSeconds: Double { return _ticks.toDouble * FTimeSpan._secondsPerTick }
    var totalMilliseconds: Double {
        let buff = _ticks.toDouble * FTimeSpan._millisecondsPerTick
        if buff > FTimeSpan.maxMilliSeconds.toDouble {
            return FTimeSpan.maxMilliSeconds.toDouble
        }
        if buff < FTimeSpan.minMilliSeconds.toDouble {
            return FTimeSpan.minMilliSeconds.toDouble
        }
        return buff
    }
    
    func negate() -> FTimeSpan {
        if ticks == FTimeSpan.MINValue.ticks {
            FException.FAssert.notDefined("illegal underflow negate; tows complement number is invalid.")
        }
        return FTimeSpan(-ticks)
    }
    func add(_ timeSpan: FTimeSpan) -> FTimeSpan {
        let ret = ticks + timeSpan.ticks
        if (ticks >> 63 != timeSpan.ticks >> 63) && (ticks >> 63 != ret >> 63) {
            FException.FAssert.notDefined("illegal overflow this ticks : \(ticks), subtract ticks : \(timeSpan.ticks)")
        }
        return FTimeSpan(ret)
    }
    func subtract(_ timeSpan: FTimeSpan) -> FTimeSpan {
        let ret = ticks - timeSpan.ticks
        if (ticks >> 63 != timeSpan.ticks) && (ticks >> 63 != ret >> 63) {
            FException.FAssert.notDefined("illegal overflow this ticks : \(ticks), subtract ticks : \(timeSpan.ticks)")
        }
        return FTimeSpan(ret)
    }
    func duration() -> FTimeSpan {
        if (ticks == FTimeSpan.MINValue.ticks) {
            FException.FAssert.notDefined("illegal underflow ticks is MinValue")
        }
        return FTimeSpan(ticks >= 0 ? ticks : -ticks)
    }
    static func timeToTicks(_ hours: Int, _ minutes: Int, _ seconds: Int) -> Int {
        let totalSeconds = hours * 3600 + minutes * 60 + seconds
        if totalSeconds > FTimeSpan.maxSeconds {
            FException.FAssert.notDefined("illegal overflow data hours: \(hours), minutes: \(minutes), seconds: \(seconds)")
        }
        if totalSeconds < FTimeSpan.minSeconds {
            FException.FAssert.notDefined("illegal underflow data hours: \(hours), minutes: \(minutes), seconds: \(seconds)")
        }
        return totalSeconds * FTimeSpan.ticksPerSecond
    }
    static func timeToTicks(_ days: Int, _ hours: Int, _ minutes: Int, _ seconds: Int, _ milliseconds: Int) -> Int {
        let totalMilliSeconds = days * 3600 * 24 + hours * 3600 + minutes * 60 + seconds + milliseconds * 1000
        if totalMilliSeconds > FTimeSpan.maxMilliSeconds {
            FException.FAssert.notDefined("illegal overflow data days : \(days), hours: \(hours), minutes: \(minutes), seconds: \(seconds)")
        }
        if totalMilliSeconds < FTimeSpan.minMilliSeconds {
            FException.FAssert.notDefined("illegal underflow data days : \(days), hours: \(hours), minutes: \(minutes), seconds: \(seconds)")
        }
        return totalMilliSeconds * FTimeSpan.ticksPerMillisecond
    }
    
    static prefix func - (timeSpan: FTimeSpan) -> FTimeSpan {
        if timeSpan.ticks == FTimeSpan.MINValue.ticks {
            FException.FAssert.notDefined("illegal underflow rhs is minValue")
        }
        return timeSpan.negate()
    }
    static func + (_ lhs: FTimeSpan, _ rhs: FTimeSpan) -> FTimeSpan {
        return lhs.add(rhs)
    }
    static func - (_ lhs: FTimeSpan, _ rhs: FTimeSpan) -> FTimeSpan {
        return lhs.subtract(rhs)
    }
    static func < (_ lhs: FTimeSpan, _ rhs: FTimeSpan) -> Bool {
        return lhs.ticks < rhs.ticks
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ticks)
    }
    func equals(_ rhs: FTimeSpan) -> Bool {
        return ticks == rhs.ticks
    }
    static func == (_ lhs: FTimeSpan, _ rhs: FTimeSpan) -> Bool {
        return lhs.ticks == rhs.ticks
    }
}
