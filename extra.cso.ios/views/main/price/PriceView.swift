import SwiftUI

struct PriceView: View {
    @StateObject var dataContext: PriceViewVM = PriceViewVM()
    var body: some View {
        VStack {
            Text(dataContext.label)
        }.padding()
    }
}
