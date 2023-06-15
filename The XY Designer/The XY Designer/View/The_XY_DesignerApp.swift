//
//  The_XY_DesignerApp.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

var isLoggedIn: Bool {
    if(Auth.auth().currentUser != nil){
        return false
    }else{
        return true
    }
}
@main
struct The_XY_DesignerApp: App {
    @StateObject var router = Router()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
                MainView(isSigned: isLoggedIn)
                    .environmentObject(router)
        }
        
        
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
