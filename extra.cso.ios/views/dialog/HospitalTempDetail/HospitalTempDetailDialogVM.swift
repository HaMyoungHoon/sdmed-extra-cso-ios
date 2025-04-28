import Foundation
import SwiftUI
import GoogleMaps
import GoogleMapsUtils

class HospitalTempDetailDialogVM: FBaseViewModel {
    var hospitalTempService = FDI.hospitalTempService
    var hospitalPK: String
    @Published var mapVisible = true
    @Published var pharmacyToggle = true
    @Published var hospitalTempItem = HospitalTempModel()
    @Published var pharmacyTempItems: [PharmacyTempModel] = []
    @Published var selectPharmacyTemp: PharmacyTempModel? = nil
    @Published var singleCluster: MarkerClusterDataModel? = nil
    @Published var listCluster: [MarkerClusterDataModel] = []
    
    init(_ appState: FAppState, _ hospitalPK: String) {
        self.hospitalPK = hospitalPK
        super.init(appState)
    }
    
    func getData() async -> RestResultT<HospitalTempModel> {
        let ret = await hospitalTempService.getData(hospitalPK)
        if ret.result == true {
            hospitalTempItem = ret.data ?? HospitalTempModel()
        }
        return ret
    }
    func getNearby() async -> RestResultT<[PharmacyTempModel]> {
        let ret = await hospitalTempService.getPharmacyListNearby(hospitalTempItem.latitude, hospitalTempItem.longitude, 1000)
        if ret.result == true {
            pharmacyTempItems = ret.data ?? []
        }
        return ret
    }
    func selectPharmacy(_ data: PharmacyTempModel) {
        pharmacyTempItems.filter{ $0.isSelect == true }.forEach { $0.isSelect = false }
        let buff = pharmacyTempItems.first(where: { $0.thisPK == data.thisPK })
        if selectPharmacyTemp?.thisPK == buff?.thisPK {
            selectPharmacyTemp = nil
        } else {
            buff?.isSelect = true
            selectPharmacyTemp = buff
        }
    }
    
    enum ClickEvent: Int, CaseIterable {
        case CLOSE = 0
        case MAP_TOGGLE = 1
        case PHARMACY_TOGGLE = 2
    }
}
