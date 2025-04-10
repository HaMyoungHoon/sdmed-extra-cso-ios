import SwiftUI

struct EDIView: View {
    @StateObject var dataContext: EDIViewVM = EDIViewVM()
    var body: some View {
        VStack {
            Text(dataContext.label)
        }.padding()
    }
}
