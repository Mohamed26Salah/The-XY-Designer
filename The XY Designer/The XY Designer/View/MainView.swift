//
//  MainView.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @State private var tabSelected: Tab = .house
    @EnvironmentObject var coordinator: Coordinator
    
    init() {
        UITabBar.appearance().isHidden = true
    }
        let screens: [String: AnyView] = [
            "House": AnyView(Home()),
            "Plus": AnyView(RoomPlaneApi()),
            "Person": AnyView(Profile()),
        ]
    var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    var body: some View {
//        TabView {
//            Home()
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("Home")
//                }
//            RoomPlaneApi()
//                .tabItem {
//                    Image(systemName: "plus.circle")
//                    Text("Add Room")
//                }
//            Profile()
//                .tabItem {
//                    Image(systemName: "person")
//                    Text("Profile")
//                }
//
//        }
//        .accentColor(.primary)
        
        ZStack {
            VStack {
                TabView(selection: $tabSelected) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        screens["\(tab.rawValue.capitalized)"]!.offset(y: -20)
                            .tag(tab)
                    }
                }
            }
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $tabSelected)
            }
            .ignoresSafeArea(edges: [.bottom])
        }
        
    }
    
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
