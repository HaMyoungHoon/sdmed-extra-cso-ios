import Foundation
import SwiftUI
import Photos

class MediaPickerDialogVM: FBaseViewModel {
    var thisPK: String = UUID().uuidString
    @Published var clickItemBuff: [MediaPickerSourceBuffModel] = []
    @Published var items: [MediaPickerSourceBuffModel] = []
    @Published var lastClickItem: MediaPickerSourceBuffModel? = nil
    var maxItemCount = 0
    init(_ appState: FAppState, _ maxItemCount: Int, _ clickBuff: [MediaPickerSourceBuffModel] = []) {
        self.clickItemBuff = clickBuff
        self.maxItemCount = maxItemCount
        super.init(appState)
    }
    
    func setLastClickedItem(_ data: MediaPickerSourceBuffModel) {
        clickItemBuff.forEach { $0.lastClick = false }
        data.lastClick = true
    }
    func appendClickedItem(_ data: MediaPickerSourceBuffModel) {
        data.num = clickItemBuff.count + 1
        data.clickState = true
        clickItemBuff.append(data)
    }
    func removeClickedItem(_ data: MediaPickerSourceBuffModel) {
        clickItemBuff.removeAll(where: { $0.thisPK == data.thisPK })
        data.clickState = false
        data.num = nil
    }
    func resetClickedItem(_ data: [MediaPickerSourceBuffModel]) {
        clickItemBuff.removeAll()
        data.forEach { appendClickedItem($0) }
    }

    enum ClickEvent: Int, CaseIterable {
        case SELECT = 0
        case CLOSE = 1
    }
}
