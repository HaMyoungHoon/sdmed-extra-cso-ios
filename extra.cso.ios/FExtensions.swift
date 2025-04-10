class FExtensions {
    static let ins = FExtensions()
}


extension String {
    subscript (_ index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }
    subscript (_ range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let endIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<endIndex]
    }
    subscript (_ startIndex: Int, _ endIndex: Int) -> Substring {
        return self[startIndex..<endIndex]
    }
    mutating func delete(_ start: Int, _ length: Int) {
        guard start >= 0, length > 0, start < self.count else { return }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
        self.removeSubrange(startIndex..<endIndex)
    }
    var toChar: Character {
        return self.first!
    }
    func toChar(_ index: Int) -> Character {
        return self[index]
    }
    var toInt: Int {
        return Int(self)!
    }
    func tryToInt(_ def: Int) -> Int {
        guard let ret = Int(self) else {
            return def
        }
        return ret
    }
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    mutating func replace(_ old: String, _ new: String) -> String {
        return self.replacingOccurrences(of: old, with: new)
    }
}

extension Substring {
    var toString: String {
        return String(self)
    }
    var toInt: Int {
        return Int(self.toString)!
    }
}

extension Character {
    var toInt: Int {
        guard let ret = unicodeScalars.first else {
            FException.FFatal.notDefined("illegal character unicodeScalars.first is nil")
            return 0
        }
        return Int(ret.value)
    }
    var toString: String {
        return String(self)
    }
}

extension Int {
    var toChar: Character {
        guard let ret = Unicode.Scalar(self) else {
            FException.FFatal.notDefined("illegal int self is not unicode")
            return Character("")
        }
        return Character(ret)
    }
    var toString: String {
        return String(self)
    }
    var toDouble: Double {
        return Double(self)
    }
}

extension Double {
    var toString: String {
        return String(self)
    }
    var toInt: Int {
        return Int(self)
    }
}
