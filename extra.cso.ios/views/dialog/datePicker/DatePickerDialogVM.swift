import Foundation
import SwiftUI

class DatePickerDialogVM: FBaseViewModel {
    @Published var title: String = ""
    @Binding var selectedDate: Date
    
    init (_ appState: FAppState, _ title: String, _ date: Binding<Date>) {
        self.title = title
        _selectedDate = date
        super.init(appState)
    }
}
