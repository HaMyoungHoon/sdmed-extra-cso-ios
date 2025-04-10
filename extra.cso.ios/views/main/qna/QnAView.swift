import SwiftUI

struct QnAView: View {
    @StateObject var dataContext: QnAViewVM = QnAViewVM()
    
    var body: some View {
        VStack {
            Text(dataContext.label)
        }.padding()
    }
}
