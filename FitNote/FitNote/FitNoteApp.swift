//
//  FitNoteApp.swift
//  FitNote
//
//  Created by Pavel on 7.06.23.
//

import SwiftUI
import FirebaseCore
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        signOutOldUser()
        return true
    }
}


@main
struct FitNoteApp: App {
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            StartView()
        }
    }
}


extension AppDelegate{
func signOutOldUser(){
    if let _ = UserDefaults.standard.value(forKey: "isNewuser"){}else{
        do{
            UserDefaults.standard.set(true, forKey: "isNewuser")
            try Auth.auth().signOut()
        }catch{}
    }
}
}
