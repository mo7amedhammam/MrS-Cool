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

class Helper: NSObject {
    @available(iOS 13.0, *)
    static let userDef = UserDefaults.standard
    
    private static let onBoardKey = "onBoard"
    private static let LoggedInKey = "LoggedId"
    private static let UserDataKey = "UserDataKey"

    class func saveUser(user: SignInModel) {
        IsLoggedIn(value: true)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            userDef.set(encoded, forKey: UserDataKey)
            IsLoggedIn(value: true)
            userDef.synchronize()
        }
    }
    
    class func getUser() -> SignInModel? {
        if let data = userDef.object(forKey: UserDataKey) as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(SignInModel.self, from: data) {
                return user
            }
        }
        return nil
    }
    
    //remove data then logout
    class func logout() {
        IsLoggedIn(value: false)
        userDef.removeObject(forKey:UserDataKey  )
    }
    
    static func onBoardOpened(opened:Bool) {
        UserDefaults.standard.set(opened, forKey: onBoardKey)
    }
    
    static func checkOnBoard() -> Bool {
        return UserDefaults.standard.bool(forKey: onBoardKey)
    }
    static func IsLoggedIn(value:Bool) {
        UserDefaults.standard.set(value, forKey: LoggedInKey)
    }
    static func CheckIfLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: LoggedInKey)
    }
    
    
    //save password
    class func setPassword(password : String){
        let def = UserDefaults.standard
        def.setValue(password, forKey: "password")
        def.synchronize()
    }
    
    class func getPassword()->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "password") as! String)
    }
    
    class func setLanguage(currentLanguage: String) {
    userDef.set(currentLanguage, forKey: "languagekey")
    userDef.synchronize()
    }
    class func getLanguage()->String{
    return userDef.string(forKey: "languagekey") ?? "en"
    }

    
    // Checking internet connection
    class func isConnectedToNetwork() -> Bool {
        
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
