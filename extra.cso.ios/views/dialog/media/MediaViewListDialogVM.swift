import Foundation
import SwiftUI

class MediaViewListDialogVM: FBaseViewModel {
    @Published var items: [MediaViewModel]
    @Published var selectedIndex: Int
    @Published var scale = CGFloat(1)
    @Published var lastScale = CGFloat(1)
    @Published var offset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero
    init (_ appState: FAppState, _ items: [MediaViewModel], _ index: Int) {
        self.items = items
        self.selectedIndex = index
        super.init(appState)
    }
    
    var originalFilename: String {
        if selectedIndex > items.count - 1 {
            return ""
        }
        return items[selectedIndex].originalFilename
    }
    
    enum ClickEvent: Int, CaseIterable {
        case CLOSE = 0
    }
}
