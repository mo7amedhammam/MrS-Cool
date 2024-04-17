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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // Set to force light mode
            
                .task {
                    if notificationManager.hasPermission == false{
                        await notificationManager.request()
                    }
                }
//                .onAppear(perform: {
//                    // Disable swipe back gesture
//                             guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//                             appDelegate.window?.rootViewController?.children.first?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

//                })

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
import FirebaseCore
import FirebaseMessaging

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        do {
             print("app started")
             print("app in: user :", Helper.shared.getSelectedUserType()?.rawValue ?? "")
             print("app in: loged in :", Helper.shared.CheckIfLoggedIn())
             try registerForRemoteNotifications(application: application)
             FirebaseApp.configure()
             Messaging.messaging().delegate = self
             UNUserNotificationCenter.current().delegate = self
            

            if Helper.shared.CheckIfLoggedIn() == false {
                Helper.shared.setSelectedUserType(userType: .Student)
             }

         } catch {
             print("Error initializing app:", error.localizedDescription)
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
       }

       // Handle receiving FCM notifications when the app is in the background or terminated
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           let userInfo = notification.request.content.userInfo
           print("Received FCM notification while app is in foreground/background/terminated:", userInfo)
           completionHandler([.banner, .sound, .badge])
       }
    
    
}


import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject{
    @Published private(set) var hasPermission = false
    
    init() {
        Task{
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

