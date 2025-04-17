import SwiftUI

struct HomeView: FBaseView {
    @StateObject var dataContext: HomeViewVM
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: HomeViewVM(appState))
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
