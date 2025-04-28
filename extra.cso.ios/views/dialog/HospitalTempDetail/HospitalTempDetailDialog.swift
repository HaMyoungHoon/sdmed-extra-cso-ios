import Foundation
import SwiftUI

struct HospitalTempDetailDialog: FBaseView {
    @Environment(\.dismiss) var dismiss
    @StateObject var dataContext: HospitalTempDetailDialogVM
    init(_ appState: FAppState, _ hospitalPK: String) {
        _dataContext = StateObject(wrappedValue: HospitalTempDetailDialogVM(appState, hospitalPK))
    }
    
    var body: some View {
        ZStack {
            VStack {
                topContainer
                mapContainer
                ScrollView {
                    pharmacyListContainer
                }
            }
        }.onAppear {
            dataContext.addEventListener(self)
            getData()
        }
    }
    var topContainer: some View {
        Group {
            HStack {
                FAppImage.close
                    .padding(.top, 8)
                    .padding(.trailing, 20)
                    .onTapGesture { dataContext.relayCommand.execute(HospitalTempDetailDialogVM.ClickEvent.CLOSE) }
                Spacer()
                HStack {
                    Button(action: { dataContext.relayCommand.execute(HospitalTempDetailDialogVM.ClickEvent.PHARMACY_TOGGLE)}) {
                        Text(FAppLocalString.pharmacyToggle)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                    }
                    .background(FAppColor.buttonBackground)
                    .foregroundColor(FAppColor.buttonForeground)
                    .cornerRadius(5)
                    Button(action: { dataContext.relayCommand.execute(HospitalTempDetailDialogVM.ClickEvent.MAP_TOGGLE)}) {
                        Text(FAppLocalString.mapToggle)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                    }
                    .background(FAppColor.buttonBackground)
                    .foregroundColor(FAppColor.buttonForeground)
                    .cornerRadius(5)
                }
            }
        }
    }
    var mapContainer: some View {
        Group {
            MapViewControllerBridge()
        }.frame(height: dataContext.mapVisible ? 500 : 0)
    }
    var pharmacyListContainer: some View {
        Group {
            if dataContext.pharmacyToggle {
                LazyVStack {
                    ForEach(dataContext.pharmacyTempItems, id: \.thisPK) { item in
                        pharmacyItemContainer(item)
                    }
                }
            }
        }
    }
    @ViewBuilder
    func pharmacyItemContainer(_ item: PharmacyTempModel) -> some View {
        Group {
            HStack {
                Text(item.orgName)
                    .foregroundColor(FAppColor.accent)
                Text(item.address)
                    .foregroundColor(FAppColor.foreground)
                    .lineLimit(1)
                    .truncationMode(.tail)
                if !item.phoneNumber.isEmpty {
                    Text(item.phoneNumber)
                        .foregroundColor(FAppColor.foreground)
                        .onTapGesture { item.onClick(PharmacyTempModel.ClickEvent.PHONE_NUMBER, PharmacyTempModel.self) }
                }
            }
            .onTapGesture { item.onClick(PharmacyTempModel.ClickEvent.THIS, PharmacyTempModel.self) }
        }
    }
    
    func onEvent(_ data: Any?) async {
        setThisCommand(data)
        setPharmacyCommand(data)
    }
    func setThisCommand(_ data: Any?) {
        guard let eventName = data as? HospitalTempDetailDialogVM.ClickEvent else { return }
        switch eventName {
        case HospitalTempDetailDialogVM.ClickEvent.CLOSE:
            close()
            break
        case HospitalTempDetailDialogVM.ClickEvent.MAP_TOGGLE:
            mapToggle()
            break
        case HospitalTempDetailDialogVM.ClickEvent.PHARMACY_TOGGLE:
            pharmacyToggle()
            break
        }
    }
    func setPharmacyCommand(_ data: Any?) {
        guard let array = data as? [Any?],
              let eventName = array[0] as? PharmacyTempModel.ClickEvent,
              let dataBuff = array[1] as? PharmacyTempModel else { return }
        switch eventName {
        case PharmacyTempModel.ClickEvent.THIS:
            selectPharmacy(dataBuff)
            break
        case PharmacyTempModel.ClickEvent.PHONE_NUMBER:
            openTelephony(dataBuff)
            break
        }
    }
    
    func getData() {
        dataContext.loading()
        Task {
            let ret = await dataContext.getData()
            if ret.result != true {
                dataContext.toast(ret.msg)
                dataContext.loading(false)
                return
            }
            getNearby()
        }
    }
    func getNearby() {
        dataContext.loading()
        Task {
            let ret = await dataContext.getNearby()
            dataContext.loading(false)
            if ret.result != true {
                dataContext.toast(ret.msg)
                return
            }
        }
    }
    
    func close() {
        dismiss()
    }
    func mapToggle() {
        dataContext.mapVisible.toggle()
    }
    func pharmacyToggle() {
        dataContext.pharmacyToggle.toggle()
    }
    func selectPharmacy(_ data: PharmacyTempModel) {
        dataContext.selectPharmacy(data)
    }
    func openTelephony(_ data: PharmacyTempModel) {
        let phoneNumber = FExtensions.ins.regexNumberReplace(data.phoneNumber)
        if phoneNumber.isEmpty {
            return
        }
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
