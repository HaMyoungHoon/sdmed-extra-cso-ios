enum UserFileType: String, Decodable, CaseIterable {
    case Taxpayer
    case BankAccount
    case CsoReport
    case MarketingContract
    var index: Int {
        switch self {
        case UserFileType.Taxpayer: return 0
        case UserFileType.BankAccount: return 1
        case UserFileType.CsoReport: return 2
        case UserFileType.MarketingContract: return 3
        }
    }
    
    static func parseIndex(_ index: Int?) -> UserFileType {
        return UserFileType.allCases.first(where: { $0.index == index }) ?? UserFileType.Taxpayer
    }
}
