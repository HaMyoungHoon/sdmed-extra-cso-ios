import Foundation

class CommonService: PCommonRepository {
    var baseUrl: String
    init(_ url: String) {
        baseUrl = url
    }
    func signIn(_ id: String, _ pw: String) async -> RestResultT<String> {
        let url = "\(baseUrl)/signIn"
        let http = FHttp()
        http.addParam("id", id)
        http.addParam("pw", pw)
        return await http.get(url, String.self)
    }
    func multiSign(_ token: String) async -> RestResultT<String> {
        let url = "\(baseUrl)/multiSign"
        let http = FHttp()
        http.addParam("token", token)
        return await http.get(url, String.self)
    }
    func tokenRefresh() async -> RestResultT<String> {
        let url = "\(baseUrl)/tokenRefresh"
        return await FHttp().get(url, String.self)
    }
    func getFindIDAuthNumber(_ name: String, _ phoneNumber: String) async -> RestResult {
        let url = "\(baseUrl)/findIDAuthNumber"
        let http = FHttp()
        http.addParam("name", name)
        http.addParam("phoneNumber", phoneNumber)
        return await http.get(url)
    }
    func getFindPWAuthNumber(_ id: String, _ phoneNumber: String) async -> RestResult {
        let url = "\(baseUrl)/findPWAuthNumber"
        let http = FHttp()
        http.addParam("id", id)
        http.addParam("phoneNumber", phoneNumber)
        return await http.get(url)
    }
    func getCheckAuthNumber(_ authNumber: String, _ phoneNumber: String) async -> RestResult {
        let url = "\(baseUrl)/checkAuthNumber"
        let http = FHttp()
        http.addParam("authNumber", authNumber)
        http.addParam("phoneNumber", phoneNumber)
        return await http.get(url)
    }
    func versionCheck(_ versionCheckType: VersionCheckType) async -> RestResultT<[VersionCheckModel]> {
        let url = "\(baseUrl)/versionCheck"
        let http = FHttp()
        http.addParam("versionCheckType", versionCheckType.rawValue)
        return await http.get(url, [VersionCheckModel].self)
    }
    func serverTime() async -> RestResultT<Date> {
        let url = "\(baseUrl)/serverTime"
        let http = FHttp()
        return await http.get(url, Date.self)
    }
    func setLanguage(_ lang: String) async -> RestResult {
        let url = "\(baseUrl)/lang"
        let http = FHttp()
        http.addParam("lang", lang)
        return await http.post(url)
    }
    func getMyRole() async -> RestResultT<Int> {
        let url = "\(baseUrl)/myRole"
        return await FHttp().get(url, Int.self)
    }
    func getMyState() async -> RestResultT<UserStatus> {
        let url = "\(baseUrl)/myState"
        return await FHttp().get(url, UserStatus.self)
    }
    func getGenerateSas(_ blobName: String) async -> RestResultT<BlobStorageInfoModel> {
        let url = "\(baseUrl)/generate/sas"
        let http = FHttp()
        http.addParam("blobName", blobName)
        return await http.get(url, BlobStorageInfoModel.self)
    }
    func postGenerateSasList(_ blobName: [String]) async -> RestResultT<[BlobStorageInfoModel]> {
        let url = "\(baseUrl)/generate/sas/list"
        let http = FHttp()
        return await http.post(url, blobName, [BlobStorageInfoModel].self)
    }
    func downloadFile(_ url: String) async -> RestResultT<Data> {
        return await FHttp().blob(url)
    }
}
