import Foundation

class ExtraMyInfoResponse: Decodable {
    @FallbackString var thisPK: String
    @FallbackString var id: String
    @FallbackString var name: String
    @FallbackString var companyName: String
    @FallbackString var companyNumber: String
    @FallbackString var bankAccount: String
    @FallbackString var csoReportNumber: String
    @FallbackDateNil var contractDate: Date?
    @FallbackDate var regDate: Date
    @FallbackDate var lastLoginDate: Date
    @FallbackDataClass var hosList: [ExtraMyInfoHospital]
    @FallbackDataClass var fileList: [UserFileModel]
    @FallbackDataClass var trainingList: [UserTrainingModel]
    
    var lastLoginDateString: String {
        return FDateTime().setThis(lastLoginDate.timeIntervalSince1970).toString()
    }
    var taxPayerUrl: String? {
        return fileList.first { $0.userFileType == UserFileType.Taxpayer }?.blobUrl
    }
    var taxPayerMimeType: String? {
        return fileList.first { $0.userFileType == UserFileType.Taxpayer }?.mimeType
    }
    var taxPayerFilename: String? {
        return fileList.first { $0.userFileType == UserFileType.Taxpayer }?.originalFilename
    }
    var bankAccountUrl: String? {
        return fileList.first { $0.userFileType == UserFileType.BankAccount }?.blobUrl
    }
    var bankAccountMimeType: String? {
        return fileList.first { $0.userFileType == UserFileType.BankAccount }?.mimeType
    }
    var bankAccountFilename: String? {
        return fileList.first { $0.userFileType == UserFileType.BankAccount }?.originalFilename
    }
    var csoReportUrl: String? {
        return fileList.first { $0.userFileType == UserFileType.CsoReport }?.blobUrl
    }
    var csoReportMimeType: String? {
        return fileList.first { $0.userFileType == UserFileType.CsoReport }?.mimeType
    }
    var csoReportFilename: String? {
        return fileList.first { $0.userFileType == UserFileType.CsoReport }?.originalFilename
    }
    var marketingContractUrl: String? {
        return fileList.first { $0.userFileType == UserFileType.MarketingContract }?.blobUrl
    }
    var marketingContractMimeType: String? {
        return fileList.first { $0.userFileType == UserFileType.MarketingContract }?.mimeType
    }
    var marketingContractFilename: String? {
        return fileList.first { $0.userFileType == UserFileType.MarketingContract }?.originalFilename
    }
    
    var trainingUrl: String? {
        return trainingList.first?.blobUrl
    }
    var trainingMimeType: String? {
        return trainingList.first?.mimeType
    }
    var trainingFilename: String? {
        return trainingList.first?.originalFilename
    }
    var trainingDate: String {
        guard let buff = trainingList.first?.trainingDate else {
            return ""
        }
        
        return FDateTime().setThis(buff.timeIntervalSince1970).toString()
    }
    var contractDateString: String {
        return FDateTime().setThis(_contractDate.wrappedValue).toString()
    }
    
    enum CodingKeys: String, CodingKey {
        case thisPK, id, name, companyName, companyNumber, bankAccount, csoReportNumber, contractDate, regDate, lastLoginDate, hosList, fileList, trainingList
    }
}
