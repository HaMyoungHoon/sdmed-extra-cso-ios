public enum FTimeSpanStandardStyle: Int, CaseIterable {
    case None = 0x00000000
    case Invariant = 0x00000001
    case Localized = 0x00000002
    case RequireFull = 0x00000004
    case AnyStyle = 0x00000003
    
    func and(_ rhs: FTimeSpanStandardStyle) -> Int {
        return self.rawValue | rhs.rawValue
    }
    func toS() -> FTimeSpanStandardStyles {
        let ret = FTimeSpanStandardStyles([self])
        return ret
    }
}

extension Set where Element == FTimeSpanStandardStyle {
    func allOf(_ other: Set<FTimeSpanStandardStyle>) -> Bool {
        return other.isSubset(of: self)
    }
    
    func and(_ rhs: FTimeSpanStandardStyle) -> FTimeSpanStandardStyles {
        return self.union([rhs])
    }

    func flag(_ rhs: FTimeSpanStandardStyle) -> Int {
        return self.reduce(0) { $0 | $1.rawValue } & rhs.rawValue
    }
}
typealias FTimeSpanStandardStyles = Set<FTimeSpanStandardStyle>
