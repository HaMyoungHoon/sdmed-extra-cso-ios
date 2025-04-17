import SwiftUI

struct PriceView: FBaseView {
    @StateObject var dataContext: PriceViewVM
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: PriceViewVM(appState))
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
