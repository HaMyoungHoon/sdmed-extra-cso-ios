import SwiftUI

struct QnAView: FBaseView {
    @StateObject var dataContext: QnAViewVM
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: QnAViewVM(appState))
    }
    
    var body: some View {
        VStack {
            Text(dataContext.label)
        }.onAppear {
            dataContext.addEventListener(self)
        }
    }
    
    func onEvent(_ data: Any?) async {
        
    }
}
