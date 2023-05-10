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
    @EnvironmentObject var router: Router
    @State var isSignedIn: Bool
    @State private var selectedTab = 0
    @StateObject var ProfileModel: ProfileViewModel = .init()
    
    var body: some View {
        NavigationStack (path: $router.path) {
            
            TabView(selection: $selectedTab) {
                Home()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .bold()
                    .tag(0)
                
                RoomPlaneApi()
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Add Room")
                    }
                    .bold()
                    .tag(1)
                Profile(isSignedIn: $isSignedIn)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Profile")
                    }
                    .bold()
                    .tag(2)
                    .overlay(
                        Button("Log Out") {
                            ProfileModel.logOutUser()
                            isSignedIn = false
                        }
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(16),
                        alignment: .topTrailing
                    )
                
            }
//            .tint(Gradient(colors: [.lightGrayFancy, .lightGrayFancy, .lightGrayFancy]))
            .navigationBarHidden(true)
        }
//        .onAppear{
//           UITabBar.appearance().isHidden = false
//        }
        .fullScreenCover(isPresented: $isSignedIn) {
            Login(userisNotSignedIn: $isSignedIn)
        }
    }
    
    
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(isSignedIn: true)
            .environmentObject(Router())
    }
}
