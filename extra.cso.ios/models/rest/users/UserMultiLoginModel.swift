class UserMultiLoginModel: FDataModelClass<UserMultiLoginModel.ClickEvent>, Decodable, Encodable, Hashable, Equatable {
    var thisPK: String = ""
    var id: String = ""
    var name: String = ""
    var token: String = ""
    var isLogin: Bool = false
    
    func safeCopy(_ rhs: UserMultiLoginModel) -> UserMultiLoginModel {
        self.thisPK = rhs.thisPK
        self.id = rhs.id
        self.name = rhs.name
        self.token = rhs.token
        self.isLogin = rhs.isLogin
        return self
    }
    enum ClickEvent: Int, CaseIterable {
        case THIS = 0
    }
    
    
    public static func == (_ lhs: UserMultiLoginModel, _ rhs: UserMultiLoginModel) -> Bool {
        if lhs.thisPK != rhs.thisPK{
            return false
        }
        
        return true
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(thisPK)
    }
}
