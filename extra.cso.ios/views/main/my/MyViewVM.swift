import Foundation
class MyViewVM: FBaseViewModel {
    var backgroundService = FDI.backgroundUserFileUploadService
    var myInfoService = FDI.myInfoService
    @Published var thisData = ExtraMyInfoResponse()
    @Published var selectedHos: ExtraMyInfoHospital? = nil
    @Published var multiLoginVisible = false
    @Published var loginDialogVisible = false
    @Published var pwChangeVisible = false
    @Published var trainingListVisible = false
    @Published var userFileSelect: UserFileType? = nil
    @Published var mediaViewModel: MediaViewModel? = nil
    @Published var mediaViewModelIndex: Int? = nil
    
    func getData() async -> RestResultT<ExtraMyInfoResponse> {
        let ret = await myInfoService.getData()
        if ret.result == true {
            thisData = ret.data ?? ExtraMyInfoResponse()
            thisData.hosList.forEach {
                $0.relayCommand = relayCommand
                $0.pharmaList.forEach {
                    $0.relayCommand = relayCommand
                }
            }
        }
        return ret
    }
    func userFileUpload(_ mediaList: [MediaPickerSourceBuffModel]) {
        Task {
            guard let userFileSelect = userFileSelect,
                  let media = await MediaPickerSourceModel().parse(mediaList.first) else { return }
            let queue = UserFileSASKeyQueueModel()
            queue.medias.append(media)
            queue.mediaTypeIndex = userFileSelect.index
            backgroundService.sasKeyEnqueue(queue)
            DispatchQueue.main.async {
                self.userFileSelect = nil
            }
        }
    }
    func getMediaList() -> [MediaViewModel] {
        var ret: [MediaViewModel] = []
        thisData.trainingList.forEach {
            ret.append(MediaViewModel().parse($0))
        }
        return ret
    }
    
    func mqttDisconnect() {
        mqttBackground.mqttDisconnect()
    }
        
    enum ClickEvent: Int, CaseIterable {
        case LOGOUT = 0
        case PASSWORD_CHANGE = 1
        case MULTI_LOGIN = 2
        case IMAGE_TRAINING_ADD = 3
        case IMAGE_TRAINING = 4
        case IMAGE_TAXPAYER = 5
        case IMAGE_BANK_ACCOUNT = 6
        case IMAGE_CSO_REPORT = 7
        case IMAGE_MARKETING_CONTRACT = 8
    }
}
