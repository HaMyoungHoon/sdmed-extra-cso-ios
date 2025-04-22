import Foundation
import Combine
import SwiftUI

struct QnAView: FBaseView {
    @StateObject var dataContext: QnAViewVM
    @State var cancellables = Set<AnyCancellable>()
    init(_ appState: FAppState) {
        _dataContext = StateObject(wrappedValue: QnAViewVM(appState))
    }
    
    var body: some View {
        VStack {
            Text(dataContext.label)
        }.onAppear {
            dataContext.addEventListener(self)
            eventWatch()
            checkStoragePK()
        }
    }
    func eventWatch() {
        FEventBus.ins.createEventChannel(QnAUploadEvent.self)
            .sink { _ in
            }.store(in: &cancellables)
    }
    func checkStoragePK() {
        FStorage.removeNotifyPK()
    }
    
    func onEvent(_ data: Any?) async {
        
    }
}
