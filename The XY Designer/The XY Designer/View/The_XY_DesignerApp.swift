//
//  The_XY_DesignerApp.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

enum Route: Hashable {
    case login
    case register
    case mainView
}
var isSignedIn: Bool {
    return Auth.auth().currentUser != nil
}
class Coordinator: ObservableObject {
    @Published var path = [Route]()
    func reset(){
        path = [Route]()
    }
}
@ViewBuilder
func userFirstView() -> some View{
    if (isSignedIn) {
        AnyView(MainView())
    }else {
        AnyView(Login())
    }
}
@main
struct The_XY_DesignerApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var coordinator = Coordinator()
    var body: some Scene {
        WindowGroup {
            NavigationStack (path: $coordinator.path){
//               AnyView(isSignedIn ? AnyView(MainView()) : AnyView(Login()))
                // MARK: problem here isSignedIn 2 times
                userFirstView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .login:
                        Login()
                    case .register:
                        Register()
                    case .mainView:
                        MainView()
                    }
                }

                
            }.environmentObject(coordinator)
            
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
