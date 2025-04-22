import Foundation
import SwiftUI

struct DatePickerDialog: FBaseView {
    @StateObject var dataContext: DatePickerDialogVM
    init (_ appState: FAppState, _ title: String = "", _ selectedDate: Binding<Date>) {
        _dataContext = StateObject(wrappedValue: DatePickerDialogVM(appState, title, selectedDate))
    }
    var body: some View {
        ZStack {
            DatePicker(dataContext.title, selection: $dataContext.selectedDate ,displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
        }
    }
    
    func onEvent(_ data: Any?) async {
        
    }
}
