import Foundation
class MyViewVM: FBaseViewModel {
    var backgroundService = FDI.backgroundUserFileUploadService
    var myInfoService = FDI.myInfoService
    @Published var thisData = ExtraMyInfoResponse()
    @Published var hosList: [ExtraMyInfoHospital] = []
    @Published var selectedHos = ExtraMyInfoHospital()
    @Published var pharmaList: [ExtraMyInfoPharma] = []
    @Published var multiLoginVisible = false
    @Published var loginDialogVisible = false
    @Published var pwChangeVisible = false
    @Published var trainingListVisible = false
    @Published var filePickerVisible = false
        
    enum ClickEvent: Int, CaseIterable {
        case LOGOUT = 0
        case PASSWORD_CHANEG = 1
        case MULTI_LOGIN = 2
        case IMAGE_TRAINING = 3
        case IMAGE_TAXPAYER = 4
        case IMAGE_BANK_ACCOUNT = 5
        case IMAGE_CSO_REPORT = 6
        case IMAGE_MARKETING_CONTRACT = 7
    }
}
