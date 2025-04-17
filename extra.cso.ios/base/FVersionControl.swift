class FVersionControl {
    static func checkVersion(_ versionModel: VersionCheckModel, _ currentVersion: String) -> VersionResultType {
        if versionModel.latestVersion == currentVersion {
            return VersionResultType.LATEST
        }
        let current = VersionModel().setVersionString(currentVersion)
        let minor = VersionModel().setVersionString(versionModel.minorVersion)
        if current >= minor {
            return VersionResultType.UPDATABLE
        }
        
        return VersionResultType.NEED_UPDATE
    }
}
