import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: FAppState
    
    var body: some View {
        TabView {
            EDIView(appState).tabItem {
                Label("menu_edi_desc", systemImage: "list.bullet.rectangle.portrait")
            }
            PriceView(appState).tabItem {
                Label("menu_price_desc", systemImage: "wonsign.circle")
            }
            HomeView(appState).tabItem {
                Label("menu_home_desc", systemImage: "square.and.arrow.up.badge.clock")
            }
            QnAView(appState).tabItem {
                Label("menu_qna_desc", systemImage: "questionmark.bubble")
            }
            MyView(appState).tabItem {
                Label("menu_my_desc", systemImage: "person")
            }
        }
    }
}
