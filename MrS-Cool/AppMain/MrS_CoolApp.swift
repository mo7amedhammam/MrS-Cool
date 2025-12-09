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
        @StateObject var notificationManager = NotificationManager()

    @State var showForceUpdate : Bool = false
    
    var body: some Scene {
        WindowGroup {
//            NavigationView{
                ContentView()
                    .preferredColorScheme(.light) // Set to force light mode
                    .task {
                        if notificationManager.hasPermission == false{
                            await notificationManager.request()
                        }
                    }
                    .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage == "ar" ? .rightToLeft : .leftToRight)
                    .fullScreenCover(isPresented: $showForceUpdate) {
//                        if let url = versionManager.updateURL {
                            ForceUpdateView()
//                        }
                    }
            //            }
        }
        
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                // App becomes active (foreground)
                print("App is active")
                // Perform any necessary actions here
                appDelegate.LocalizationInit()
                checkAppUpdate()
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
    
    func checkAppUpdate(){
        //            .onAppear {
                Helper.shared.checkAppStoreVersion { updateAvailable, appStoreVersion in
                    print("Checking for app updates...")
                            if updateAvailable {
                                DispatchQueue.main.async {
                                    showForceUpdate = true
                                }
                            }
                        }
        //            }

    }
}


import UIKit
import FirebaseCore
import FirebaseMessaging

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
//    var locationService: LocationService? = LocationService.shared

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        do {
             print("app started: For :", Helper.shared.getSelectedUserType()?.rawValue ?? "")
            
            LocalizationInit()

            try registerForRemoteNotifications(application: application)
             FirebaseApp.configure()
             Messaging.messaging().delegate = self
             UNUserNotificationCenter.current().delegate = self
             UIApplication.shared.applicationIconBadgeNumber = 0

            if Helper.shared.CheckIfLoggedIn() == false {
                Helper.shared.setSelectedUserType(userType: .Student)
             }
            
         } catch {
             print("Error initializing app:", error.localizedDescription)
         }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("app became active")
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
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
         .portrait
     }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    private func registerForRemoteNotifications(application: UIApplication) throws {
            application.registerForRemoteNotifications()
        }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    // Handle receiving FCM token
       func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
           guard let token = fcmToken else { return }
           print("FCM Token:", token)
       }

       // Handle receiving FCM notifications when the app is in the foreground
       func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
           print("Received FCM notification while app is in foreground:", userInfo)
           handleRemoteNotificationForeground(userInfo: userInfo)
       }

       // Handle receiving FCM notifications when the app is in the background or terminated
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           let userInfo = notification.request.content.userInfo
           handleRemoteNotificationForeground(userInfo: userInfo)
           print("Received FCM notification while app is in foreground/background/terminated:", userInfo)
           completionHandler([.banner, .sound, .badge,.list])
       }
    
}

extension AppDelegate {
    func handleRemoteNotification(userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let body = alert["body"] as? String {
            // Display the full notification body text
            print("Received FCM notification with full body text: \(body)")
        }
    }

    // Handle receiving FCM notifications when the app is in the foreground
    func handleRemoteNotificationForeground(userInfo: [AnyHashable: Any]) {
        print("Received FCM notification while app is in foreground:", userInfo)
        handleRemoteNotification(userInfo: userInfo)
    }

    // Handle receiving FCM notifications when the app is in the background or terminated
    func handleRemoteNotificationBackground(userInfo: [AnyHashable: Any]) {
        print("Received FCM notification while app is in background/terminated:", userInfo)
        handleRemoteNotification(userInfo: userInfo)
    }
}


import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject{
    @Published private(set) var hasPermission = false
    
    init() {
        Task{[weak self] in
            guard let self = self else {return}
            await getAuthStatus()
        }
    }
    
    func request() async{
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
             await getAuthStatus()
        } catch{
            print(error)
        }
    }
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized, .ephemeral, .provisional:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
}


//MARK: --- Localization ---
extension AppDelegate{
    func LocalizationInit() {
        LocalizationManager.shared.setLanguage(Helper.shared.getLanguage()) { _ in }
        
//        let currentLanguage = Locale.current.languageCode ?? "en" // Detect user's language
//        LocalizationManager.shared.fetchTranslations(language: currentLanguage) { success in
//            if success {
//                print("✅ Localization updated successfully")
//            } else {
//                print("❌ Failed to update localization")
//            }
//        }
    }
    
    
//    func detectCountry() {
////        locationService = LocationService() // keep a strong reference
//
//        LocationService.shared.onCountryDetected = { countryCode in
//           if let code = countryCode {
//               print("Detected Country: \(code)")
//
//               // Example: Set global flags or variables
//               if code == "EG" {
//                   print("🇪🇬 User is in Egypt")
//               } else if code == "SA" {
//                   print("🇸🇦 User is in Saudi Arabia")
//               }
//           } else {
//               print("❌ Failed to detect country")
//           }
//       }
//   }
    
}

