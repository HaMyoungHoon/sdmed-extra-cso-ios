import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: FAppState
    
    var body: some View {
        TabView(selection: appState.$notifyIndex) {
            EDIView(appState).tabItem {
                Label("menu_edi_desc", systemImage: "list.bullet.rectangle.portrait")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(0)
            PriceView(appState).tabItem {
                Label("menu_price_desc", systemImage: "wonsign.circle")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(1)
            HomeView(appState).tabItem {
                Label("menu_home_desc", systemImage: "square.and.arrow.up.badge.clock")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(2)
            QnAView(appState).tabItem {
                Label("menu_qna_desc", systemImage: "questionmark.bubble")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(3)
            MyView(appState).tabItem {
                Label("menu_my_desc", systemImage: "person")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(4)
        }.onAppear {
            FStorage.removeNotifyIndex()
        }
    }
}
