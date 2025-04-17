import SwiftUI

struct EDIView: FBaseView {
    @StateObject var dataContext: EDIViewVM
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: EDIViewVM(appState))
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
