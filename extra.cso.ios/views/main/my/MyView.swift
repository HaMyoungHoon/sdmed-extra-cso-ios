import SwiftUI

struct MyView: View {
    @StateObject var dataContext: MyViewVM = MyViewVM()
    
    var body: some View {
        VStack {
            Text(dataContext.label)
        }.padding()
    }
}
