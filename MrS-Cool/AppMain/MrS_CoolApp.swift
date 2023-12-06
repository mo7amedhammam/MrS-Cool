//
//  MrS_CoolApp.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

@main
struct MrS_CoolApp: App {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // Set to force light mode
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                // App becomes active (foreground)
                print("App is active")
                // Perform any necessary actions here
            case .inactive:
                // App becomes inactive (background)
                print("App is inactive")
                // Perform any necessary actions here when the app goes into the background
            case .background:
                // App moves to the background
                print("App moved to the background")
                // Perform any necessary actions here when the app is about to be closed or moved to the background
                
            @unknown default:
                break
            }
        }
    }
}


import UIKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        print("app started")
        
        print("app in: user :",Helper.shared.getSelectedUserType()?.rawValue ?? "")
        print("app in: loged in :",Helper.shared.CheckIfLoggedIn())

//                Helper.shared.IsLoggedIn(value: false)

        if Helper.shared.CheckIfLoggedIn() == false{
            Helper.shared.setSelectedUserType(userType: .Student)
        }

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // The app entered the background
        // Handle actions when the app moves to the background
        print("app in background")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // The app is about to terminate
        // Handle actions before the app gets terminated
        print("app terminated")
    }
}
