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
    init(isSigned: Bool) {
        self.isSignedIn = isSigned
        UITabBar.appearance().barTintColor = .black
    }
    var body: some View {
        NavigationStack (path: $router.path) {
            
            TabView(selection: $selectedTab) {
                ZStack {
                    Color.white
                        .ignoresSafeArea(.all)
                    Home(isSignedIn: $isSignedIn, selectedTab: $selectedTab)
                }
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .bold()
                    .tag(0)
                    .overlay (
                        EditButton()
                            .font(.system(.title2))
                            .padding()
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(16),
                        alignment: .topTrailing
                    )
                    .overlay(
                        VStack {
                            Text("Scenes")
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                            
                            Spacer()
                        }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(),
                        alignment: .topLeading
                    )
                ZStack {
                    Color.white
                        .ignoresSafeArea(.all)
                    RoomPlaneApi(selectedTab: $selectedTab)
                }
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Add Room")
                    }
                    .bold()
                    .tag(1)
                ZStack {
                    Color.white
                        .ignoresSafeArea(.all)
                    Profile(isSignedIn: $isSignedIn, selectedTab: $selectedTab)
                }
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Profile")
                    }
                    .bold()
                    .tag(2)
                    .overlay(
                        Button("Log Out") {
                            ProfileModel.logOutUser()
                            isSignedIn.toggle()
                        }
                            .padding()
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(16),
                        alignment: .topTrailing
                    )
                
            }
            .tint(Color(hex: "#42C2FF"))
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $isSignedIn) {
            Login(userisNotSignedIn: $isSignedIn)
        }
    }
    
    
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(isSigned: true)
            .environmentObject(Router())
    }
}
