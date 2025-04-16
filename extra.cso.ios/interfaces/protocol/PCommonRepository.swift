import Foundation

protocol PCommonRepository {
    func signIn(_ id: String, _ pw: String) async -> RestResultT<String>
    func multiSign(_ token: String) async -> RestResultT<String>
    func tokenRefresh() async -> RestResultT<String>
    
    func getFindIDAuthNumber(_ name: String, _ phoneNumber: String) async -> RestResult
    func getFindPWAuthNumber(_ id: String, _ phoneNumber: String) async -> RestResult
    func getCheckAuthNumber(_ authNumber: String, _ phoneNumber: String) async -> RestResult
    
    func versionCheck(_ versionCheckType: VersionCheckType) async -> RestResultT<[VersionCheckModel]>
    func serverTime() async -> RestResultT<Date>
    func setLanguage(_ lang: String) async -> RestResult
    
    func getMyRole() async -> RestResultT<Int>
    func getMyState() async -> RestResultT<UserStatus>
    func getGenerateSas(_ blobName: String) async -> RestResultT<BlobStorageInfoModel>
    func postGenerateSasList(_ blobName: [String]) async -> RestResultT<[BlobStorageInfoModel]>
    func downloadFile(_ url: String) async -> RestResultT<Data>
}
