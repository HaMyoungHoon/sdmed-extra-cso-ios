class VersionModel: Comparable {
    var major: Int = 0
    var minor: Int = 0
    var patch: Int = 0
    func getVersionString() -> String {
        return "\(major).\(minor).\(patch)"
    }
    func setVersionString(_ versionString: String) -> VersionModel {
        let buff = versionString.split(separator: ".")
        if buff.isEmpty {
            major = 0
            minor = 0
            patch = 0
            return self
        }
        if buff.count <= 1 {
            major = buff[0].toInt
            minor = 0
            patch = 0
            return self
        }
        if buff.count <= 2 {
            major = buff[0].toInt
            minor = buff[1].toInt
            patch = 0
            return self
        }
        major = buff[0].toInt
        minor = buff[1].toInt
        patch = buff[2].toInt
        return self
    }
    
    static func < (lhs: VersionModel, rhs: VersionModel) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }
        if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        }
        return lhs.patch < rhs.patch
    }
    static func == (lhs: VersionModel, rhs: VersionModel) -> Bool {
        return lhs.major == rhs.major &&
               lhs.minor == rhs.minor &&
               lhs.patch == rhs.patch
    }
}
