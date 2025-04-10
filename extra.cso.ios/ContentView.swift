//
//  ContentView.swift
//  extra.cso.ios
//
//  Created by 하명훈 on 3/29/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    var body: some View {
        TabView {
            EDIView().tabItem {
                Label("menu_edi_desc", systemImage: "list.bullet.rectangle.portrait")
            }
            PriceView().tabItem {
                Label("menu_price_desc", systemImage: "wonsign.circle")
            }
            HomeView().tabItem {
                Label("menu_home_desc", systemImage: "square.and.arrow.up.badge.clock")
            }
            QnAView().tabItem {
                Label("menu_qna_desc", systemImage: "questionmark.bubble")
            }
            MyView().tabItem {
                Label("menu_my_desc", systemImage: "person")
            }
            
        }
    }
}

#Preview {
    ContentView()
}
