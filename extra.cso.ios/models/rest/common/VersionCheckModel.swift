struct VersionCheckModel: Decodable {
    @FallbackString var thisPK: String
    @FallbackEnum var versionCheckType: VersionCheckType
    @FallbackString var latestVersion: String
    @FallbackString var minorVersion: String
    @FallbackBool var able: Bool
    @FallbackString var regDate: String
    
    enum CodingKeys: String, CodingKey {
        case thisPK, versionCheckType, latestVersion, minorVersion, able, regDate
    }
}
