import Foundation

class FStorage {
    static func save<T: Codable>(_ key: String, _ value: T) {
        do {
            let data = try JSONEncoder().encode(value)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
            ]

            SecItemDelete(query as CFDictionary)

            let attributes: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
            ]

            SecItemAdd(attributes as CFDictionary, nil)
        } catch {
            
        }
    }
    static func load<T: Codable>(_ type: T.Type, _ key: String, _ defValue: T? = nil) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            return defValue
        }

        do {
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            return defValue
        }
    }
    static func delete(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }
    
    static func getNotifyIndex() -> Int {
        return UserDefaults.standard.integer(forKey: FConstants.NOTIFY_INDEX)
    }
    static func setNotifyIndex(_ index: Int) {
        UserDefaults.standard.set(index, forKey: FConstants.NOTIFY_INDEX)
    }
    static func removeNotifyIndex() {
        UserDefaults.standard.removeObject(forKey: FConstants.NOTIFY_INDEX)
    }
    static func getNotifyPK() -> String {
        return UserDefaults.standard.string(forKey: FConstants.NOTIFY_PK) ?? ""
    }
    static func setNotifyPK(_ pk: String) {
        UserDefaults.standard.set(pk, forKey: FConstants.NOTIFY_PK)
    }
    static func removeNotifyPK() {
        UserDefaults.standard.removeObject(forKey: FConstants.NOTIFY_PK)
    }
    
    static func getAuthToken() -> String {
        return getString(FConstants.AUTH_TOKEN)
    }
    static func setAuthToken(_ token: String?) {
        guard let token = token else {
            return
        }
        putString(FConstants.AUTH_TOKEN, token)
    }
    static func removeAuthToken() {
        delete(FConstants.AUTH_TOKEN)
    }
    static func getMultiLoginData() -> [UserMultiLoginModel]? {
        return getList(FConstants.MULTI_LOGIN_TOKEN)
    }
    static func setMultiLoginData(_ data: [UserMultiLoginModel]) {
        putList(FConstants.MULTI_LOGIN_TOKEN, data)
    }
    static func logoutMultiLoginData() {
        guard let item = getMultiLoginData() else {
            return
        }
        item.forEach { $0.isLogin = false }
        removeMultiLoginData()
        setMultiLoginData(item)
    }
    static func addMultiLoginData(_ data: UserMultiLoginModel?) {
        guard let data = data else {
            return
        }
        let pastData = getMultiLoginData() ?? []
        var seen = Set<UserMultiLoginModel>()
        var ret: [UserMultiLoginModel] = pastData.filter { seen.insert($0).inserted }
        ret.forEach { $0.isLogin = false }
        if let findBuff = ret.first(where: { $0.thisPK == data.thisPK }) {
            _ = findBuff.safeCopy(data)
        } else {
            ret.append(data)
        }
        removeMultiLoginData()
        setMultiLoginData(ret)
    }
    static func delMultiLoginData(_ data: UserMultiLoginModel?) {
        guard let data = data else {
            return
        }
        let pastData = getMultiLoginData() ?? []
        var seen = Set<UserMultiLoginModel>()
        var ret: [UserMultiLoginModel] = pastData.filter { seen.insert($0).inserted }
        ret.removeAll { $0.thisPK == data.thisPK }
        removeMultiLoginData()
        setMultiLoginData(ret)
    }
    static func removeMultiLoginData() {
        delete(FConstants.MULTI_LOGIN_TOKEN)
    }
    
    static func getString(_ key: String, _ defValue: String = "") -> String {
        return load(String.self, key, defValue) ?? defValue
    }
    static func putString(_ key: String, _ data: String) {
        save(key, data)
    }
    static func getInt(_ key: String, _ defValue: Int = 0) -> Int {
        return load(Int.self, key, defValue) ?? defValue
    }
    static func putInt(_ key: String, _ data: Int) {
        save(key, data)
    }
    static func getBool(_ key: String, _ defValue: Bool = false) -> Bool {
        return load(Bool.self, key, defValue) ?? defValue
    }
    static func putBool(_ key: String, _ data: Bool) {
        save(key, data)
    }
    static func getDouble(_ key: String, _ defValue: Double = 0.0) -> Double {
        return load(Double.self, key, defValue) ?? defValue
    }
    static func putDouble(_ key: String, _ data: Double) {
        save(key, data)
    }
    static func getList<T: Codable>(_ key: String, _ defValue: [T] = []) -> [T] {
        return load([T].self, key) ?? defValue
    }
    static func putList<T: Codable>(_ key: String, _ data: [T]) {
        save(key, data)
    }
}
