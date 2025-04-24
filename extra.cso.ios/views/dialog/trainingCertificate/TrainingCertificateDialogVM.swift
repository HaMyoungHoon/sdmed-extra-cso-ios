import Foundation

class TrainingCertificateDialogVM: FBaseViewModel {
    var myInfoService = FDI.myInfoService
    var backgroundService = FDI.backgroundUserFileUploadService
    @Published var trainingList: [UserTrainingModel] = []
    @Published var uploadBuff: MediaPickerSourceBuffModel? = nil
    @Published var trainingDate: Date = Date()
    @Published var isSavable = false
    @Published var trainingDateSelect = false
    @Published var imageSelect = false
    @Published var mediaViewModelIndex: Int? = nil
    
    func getList() async -> RestResultT<[UserTrainingModel]> {
        let ret = await myInfoService.getTrainingData()
        if ret.result == true {
            trainingList = ret.data ?? []
            trainingList.forEach { $0.relayCommand = relayCommand }
        }
        
        return ret
    }
    func setUploadBuff(_ data: [MediaPickerSourceBuffModel]) {
        if data.isEmpty {
            return
        }
        
        uploadBuff = data.first
        checkSavable()
    }
    
    func getMediaList() -> [MediaViewModel] {
        var ret: [MediaViewModel] = []
        trainingList.forEach {
            ret.append(MediaViewModel().parse($0))
        }
        return ret
    }
    func startBackground() {
        Task {
            guard let uploadItem = await MediaPickerSourceModel().parse(uploadBuff) else {
                return
            }
            let queue = UserTrainingFileSASKeyQueueModel()
            queue.media = uploadItem
            queue.trainingDate = FDateTime().setThis(trainingDate).toString()
            backgroundService.sasKeyEnqueue(queue)
        }
    }
    func checkSavable() {
        isSavable = uploadBuff != nil
    }
    
    enum ClickEvent: Int, CaseIterable {
        case CLOSE = 0
        case TRAINING_DATE = 1
        case ADD = 2
        case SAVE = 3
    }
}
