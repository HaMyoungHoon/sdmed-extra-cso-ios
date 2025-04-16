enum UserStatus: String, Decodable {
    case None
    case Live
    case Stop
    case Delete
    case Expired
    
    var index: Int {
        switch self {
        case UserStatus.None: return 0
        case UserStatus.Live: return 1
        case UserStatus.Stop: return 2
        case UserStatus.Delete: return 3
        case UserStatus.Expired: return 4
        }
    }
    var desc: String {
        switch self {
        case UserStatus.None: return "user_none_desc"
        case UserStatus.Live: return "user_live_desc"
        case UserStatus.Stop: return "user_stop_desc"
        case UserStatus.Delete: return "user_delete_desc"
        case UserStatus.Expired: return "user_expired_desc"
        }
    }
}
