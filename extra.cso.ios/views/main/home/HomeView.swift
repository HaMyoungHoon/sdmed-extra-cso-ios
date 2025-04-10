import SwiftUI

struct HomeView: View {
    @StateObject var dataContext: HomeViewVM = HomeViewVM()
    var body: some View {
        VStack {
            Text(dataContext.label)
        }.padding()
    }
}
