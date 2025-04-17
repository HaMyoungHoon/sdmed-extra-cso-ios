import SwiftUI

struct MyView: FBaseView {
    @StateObject var dataContext: MyViewVM
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: MyViewVM(appState))
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
