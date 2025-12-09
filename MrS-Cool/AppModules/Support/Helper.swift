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

var appCurrency : String? {
    Helper.shared.getLanguage().lowercased() == "ar" ? Helper.shared.getAppCountry()?.currencyAr: Helper.shared.getAppCountry()?.currency
}


extension DateFormatter {
    static let cachedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // Add this to help parsing ambiguous/invalid DST dates
        formatter.isLenient = true
//        formatter.timeZone = appTimeZone
        return formatter
    }()
}
var appTimeZone: TimeZone {
      if let utc = Helper.shared.getAppCountry()?.countryUTC  {
//          print("utc",utc,"timezone",Int(utc * 3600))
//          print("timezone",TimeZone(secondsFromGMT: Int(utc * 3600)) ?? TimeZone.current)
//          print(DateFormatter.cachedFormatter.timeZone)
//          
          //          DateFormatter.cachedFormatter.calendar.timeZone = TimeZone(secondsFromGMT: Int(utc * 3600)) ?? TimeZone.current
//          print("cachedFormatter tz",DateFormatter.cachedFormatter.timeZone)
//          print(Date())
        return TimeZone(secondsFromGMT: Int(utc * 3600)) ?? TimeZone.current
    } else {
         return Helper.shared.getAppCountry()?.id == 5 ? TimeZone(identifier: "Asia/Riyadh") ?? TimeZone.current : TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current
    }
    
}



class Helper: NSObject {
    static let shared = Helper()
    
    @available(iOS 13.0, *)
    let userDef = UserDefaults.standard
    
    let onBoardKey = "onBoard"
    let LoggedInKey = "LoggedId"
    let UserDataKey = "UserDataKey"
    let Languagekey = "languagekey"
    let UserTypeKey = "setSelectedUserTypeKey"
    let AppCountryKey = "AppCountryIdKey"
    
    func saveUser(user: TeacherModel?) {
//        print("LoginModel : ",user)
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
    
    
    func saveAppCountry(country: AppCountryM){
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(country) {
           userDef.set(encoded, forKey: AppCountryKey)
           userDef.synchronize()
       }
   }

    func getAppCountry() -> AppCountryM?{
       if let data = userDef.object(forKey: AppCountryKey) as? Data {
           let decoder = JSONDecoder()
           if let user = try? decoder.decode(AppCountryM.self, from: data) {
               return user
           }
       }
       return nil
   }
    func removeAppCountry() {
        userDef.removeObject(forKey:AppCountryKey )
    }
    
//    func AppCountryId(AppCountry:AppCountryM?) {
//       UserDefaults.standard.set(AppCountry, forKey: AppCountryKey)
//   }
//    func AppCountryId() -> AppCountryM? {
//       return UserDefaults.standard.integer(forKey: AppCountryKey)
//   }
    
    //save password
//    func setPassword(password : String){
//        let def = UserDefaults.standard
//        def.setValue(password, forKey: "password")
//        def.synchronize()
//    }
    
//    func getPassword()->String{
//        let def = UserDefaults.standard
//        return (def.object(forKey: "password") as! String)
//    }
    
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
            let signInHostingController = UIHostingController(rootView: signInView.environment(\.layoutDirection, layoutDirection))
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
    
    
    func GetEgyptDateTime() async -> String{

            let target = teacherServices.GetEgyptDateTime
        var date = ""
                do{
                    let response = try await BaseNetwork.shared.request(target, String.self)
                    print(response)
//                    EgyptDateTime = response
                    date = response

//                    } catch let error as NetworkError {
//                        self.isLoadingComments = false
//                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                        self.isError = true
//        //                print("Network error: \(error.errorDescription)")
                } catch {
//                        self.isLoadingComments = false
                }
            
        return date
        }
    
     func openChat(phoneNumber: String, message: String = "") {
         // Ensure number is in international format (no leading 0)
            var cleaned = phoneNumber.replacingOccurrences(of: " ", with: "")
            if cleaned.hasPrefix("0") {
                cleaned.removeFirst()
            }
            // Prefix with Saudi country code
//            cleaned = "966" + cleaned

          let urlString = "https://wa.me/\(cleaned)?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
          
          if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url)
          } else {
              // WhatsApp not installed → open App Store
              if let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id310633997") {
                  UIApplication.shared.open(appStoreURL)
              }
          }
      }
    
    func checkAppStoreVersion(completion: @escaping (Bool, String?) -> Void) {
//        let locale = Locale(identifier: Locale.preferredLanguages.first ?? "en_US")
//        let countryCode = locale.regionCode?.lowercased() ?? "us"
//        let appId = "6737163953"
        let bundleId = Bundle.main.bundleIdentifier ?? ""

        //        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=com.wecancityagency.MrS-Cool") else {
//            completion(false, nil)
//            return
//        }
        
        guard let url = URL(string: "https://itunes.apple.com/eg/lookup?bundleId=\(bundleId)") else {
            completion(false, nil)
            return
        }
        
        print(url)
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let results = json["results"] as? [[String: Any]],
                let appStoreVersion = results.first?["version"] as? String
            else {
                completion(false, nil)
                return
            }
            print("JSON:", json)
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
            print(currentVersion, appStoreVersion)

            if currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending {
                completion(true, appStoreVersion) // Update available
            } else {
                completion(false, nil)
            }
        }
        .resume()
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
            let keyWindow = UIApplication.shared.connectedScenes
                           .compactMap { $0 as? UIWindowScene }
                           .flatMap { $0.windows }
                           .first { $0.isKeyWindow }

                       let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
            
//            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
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

