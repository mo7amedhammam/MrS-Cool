//
//  Helper.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import UIKit
import SystemConfiguration
import MapKit
import Foundation
import SwiftUI

class Helper: NSObject {
    static let shared = Helper()
    
    @available(iOS 13.0, *)
    let userDef = UserDefaults.standard
    
    let onBoardKey = "onBoard"
    let LoggedInKey = "LoggedId"
    let UserDataKey = "UserDataKey"
    let Languagekey = "languagekey"
    let UserTypeKey = "setSelectedUserTypeKey"
    
    func saveUser(user: TeacherModel?) {
        print("LoginModel : ",user)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
//            userDef.removeObject(forKey: UserDataKey) // Clear old data

            userDef.set(encoded, forKey: UserDataKey)
            IsLoggedIn(value: true)
            userDef.synchronize()
        } else {
            print("Failed to encode user")
        }
    }
    
    func getUser() -> TeacherModel? {
        if let data = userDef.object(forKey: UserDataKey) as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(TeacherModel.self, from: data) {
                return user
            } else {
                print("Failed to decode user")
            }

        }
        return nil
    }
    
    //remove data then logout
    func logout() {
        IsLoggedIn(value: false)
        userDef.removeObject(forKey:UserDataKey )
        setSelectedUserType(userType: .Student)
    }
    
    func onBoardOpened(opened:Bool) {
        UserDefaults.standard.set(opened, forKey: onBoardKey)
    }
    
    func checkOnBoard() -> Bool {
        return UserDefaults.standard.bool(forKey: onBoardKey)
    }
    func IsLoggedIn(value:Bool) {
        UserDefaults.standard.set(value, forKey: LoggedInKey)
    }
    func CheckIfLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: LoggedInKey)
    }
    
    //save password
    func setPassword(password : String){
        let def = UserDefaults.standard
        def.setValue(password, forKey: "password")
        def.synchronize()
    }
    
    func getPassword()->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "password") as! String)
    }
    
    func setLanguage(currentLanguage: String) {
        userDef.set(currentLanguage, forKey: Languagekey)
        userDef.synchronize()
    }
    
    func getLanguage()->String{
        let deviceLanguage = Locale.preferredLanguages.first ?? "en"
        let deviceLanguageCode = deviceLanguage.getValidLanguageCode()
        return userDef.string(forKey: Languagekey) ?? deviceLanguageCode
    }
    
    func setSelectedUserType(userType: UserTypeEnum) {
        let rawValue = userType.rawValue
        userDef.set(rawValue, forKey: UserTypeKey)
        userDef.synchronize()
    }
    
    func getSelectedUserType() -> UserTypeEnum? {
        let rawValue = userDef.string(forKey: UserTypeKey)
        return UserTypeEnum(rawValue: rawValue ?? "")
    }
    
    // Checking internet connection
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    var selectedchild:ChildrenM?
    
    
    func changeRoot(toView:any View) {
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        
        //                                    window?.rootViewController = UIHostingController(rootView: SignInView())
        //                                    window?.makeKeyAndVisible()
        
        if let window = window {
            // Determine the layout direction based on the current language
            let layoutDirection = LocalizeHelper.shared.currentLanguage == "ar" ? LayoutDirection.rightToLeft : LayoutDirection.leftToRight
            
            // Apply the layout direction to the root view
            let signInView = AnyView(toView.environment(\.layoutDirection, layoutDirection))
            let signInHostingController = UIHostingController(rootView: signInView)
            let navigationController = CustomNavigationController(rootViewController: signInHostingController)
            
            // Disable swipe back gesture
//            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            navigationController.navigationBar.isHidden = true
            
            // Set up the flip animation
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType(rawValue: "flip")
            transition.subtype = CATransitionSubtype(rawValue: "fromRight")
            window.layer.add(transition, forKey: kCATransition)
            
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}

extension Helper{
    func getAppVersion() -> String {
         if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
             return appVersion
         }
         return "Unknown"
     }

     func getBuildNumber() -> String {
         if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
             return buildNumber
         }
         return "Unknown"
     }
}

//MARK: -- view helper --
func getRelativeHeight(_ size: CGFloat) -> CGFloat {
    return (size * (CGFloat(UIScreen.main.bounds.height) / 812.0)) * 0.97
}

func getRelativeWidth(_ size: CGFloat) -> CGFloat {
    return size * (CGFloat(UIScreen.main.bounds.width) / 375.0)
}

func getRelativeFontSize(_ size: CGFloat) -> CGFloat {
    return size * (CGFloat(UIScreen.main.bounds.width) / 375.0)
}


extension UIDevice {
    var hasNotch: Bool
    {
        if #available(iOS 11.0, *)
        {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else
        {
            // Fallback on earlier versions
            return false
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
#endif

