import Foundation

class MediaViewDialogVM: FBaseViewModel {
    @Published var item: MediaViewModel
    @Published var scale = CGFloat(1)
    @Published var lastScale = CGFloat(1)
    @Published var offset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero
    
    init (_ appState: FAppState, _ data: MediaViewModel) {
        item = data
        super.init(appState)
    }
    
    enum ClickEvent: Int, CaseIterable {
        case CLOSE = 0
    }
}
