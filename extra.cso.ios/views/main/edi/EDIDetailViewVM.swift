import Foundation
import SwiftUI

class EDIDetailViewVM: FBaseViewModel {
    var ediListService = FDI.ediListService
    var backgroundService = FDI.backgroundEDIFileUploadService
    var thisPK: String = ""
    @Published var item = ExtraEDIDetailResponse()
    @Published var closeAble = true
    @Published var addPharmaFilePK: String? = nil
    @Published var hospitalTempDetail = false
    @Published var mediaView: EDIUploadPharmaFileModel? = nil
    @Published var mediaListView: EDIUploadPharmaFileModel? = nil
    @Published var hospitalDetailVisible = false
    
    init(_ appState: FAppState, _ thisPK: String) {
        self.thisPK = thisPK
        super.init(appState)
    }
    
    func getData() async -> RestResultT<ExtraEDIDetailResponse> {
        if thisPK.isEmpty {
            return RestResultT<ExtraEDIDetailResponse>().emptyResult()
        }
        
        let ret = await ediListService.getData(thisPK)
        if ret.result == true {
            item = ret.data ?? ExtraEDIDetailResponse()
            item.relayCommand = relayCommand
            item.pharmaList.forEach {
                $0.relayCommand = relayCommand
                $0.fileList.forEach { $0.relayCommand = relayCommand }
            }
            item.responseList.forEach { $0.relayCommand = relayCommand }
        }
        return ret
    }
    func getMediaViewPharmaFiles(_ data: EDIUploadPharmaFileModel) -> [MediaViewModel] {
        var ret: [MediaViewModel] = []
        if let findBuff = item.pharmaList.first(where: { x in x.fileList.first(where: { y in y.thisPK == data.thisPK }) != nil }) {
            findBuff.fileList.forEach { ret.append(MediaViewModel().parse($0)) }
        }
        return ret
    }
    func delImage(_ imagePK: String) {
        if let findBuff = item.pharmaList.first(where: { x in x.uploadItems.first(where: { y in y.thisPK == imagePK }) != nil }) {
            findBuff.uploadItems.removeAll(where: { $0.thisPK == imagePK })
        }
        objectWillChange.send()
    }
    func reSetImage(_ pharmaBuffPK: String, _ mediaList: [MediaPickerSourceBuffModel]) {
        mediaList.forEach { $0.relayCommand = relayCommand }
        if let findBuff = item.pharmaList.first(where: { $0.thisPK == pharmaBuffPK }) {
            findBuff.uploadItems = mediaList
        }
        addPharmaFilePK = nil
    }
    func getMedia(_ pharmaBuffPK: String) -> [MediaPickerSourceBuffModel] {
        var ret: [MediaPickerSourceBuffModel] = []
        if let findBuff = item.pharmaList.first(where: { $0.thisPK == pharmaBuffPK }) {
            findBuff.uploadItems.forEach { ret.append($0) }
        }
        return ret
    }
    func startBackgroundService(_ data: ExtraEDIPharma) async {
        closeAble = false
        let queue = EDISASKeyQueueModel()
        queue.pharmaPK = data.thisPK
        let ediUploadModel = EDIUploadModel()
        ediUploadModel.ediType = item.ediType
        ediUploadModel.year = item.year
        ediUploadModel.month = item.month
        ediUploadModel.tempHospitalPK = item.tempHospitalPK
        ediUploadModel.tempOrgName = item.tempOrgName
        ediUploadModel.pharmaList.append(await data.toEDIUploadPharmaModel())
        queue.ediUploadModel = ediUploadModel
        backgroundService.sasKeyEnqueue(queue)
    }
    
    enum ClickEvent: Int, CaseIterable {
        case CLOSE = 0
        case HOSPITAL_DETAIL = 1
    }
}
