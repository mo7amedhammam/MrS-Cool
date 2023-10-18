//
//  LocalizationService.swift
//  SalamTech
//
//  Created by wecancity agency on 3/29/22.
//

import Foundation
import UIKit

class LocalizationService {
    static let shared = LocalizationService()
//    static let changedLanguage = Notification.Name("languagekey")
    private init() {}
    
    var language: Language {
        get {
//            guard let languageString = UserDefaults.standard.string(forKey: "languagekey") else {
//                return .english_us
//            }
//            return Language(rawValue: languageString) ?? .english_us
            return Helper.getLanguage() == "en" ? .english_us : .arabic
        }
        set {
            if newValue != language {
                print(newValue.rawValue)
                Helper.setLanguage(currentLanguage: newValue.rawValue)
//                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
    }
    
//    private func updateLayoutDirection() {
//        switch language {
//        case .english_us:
//            // Set layout direction to left-to-right for English.
//            UIApplication.shared.userInterfaceLayoutDirection = .leftToRight
//        case .arabic:
//            // Set layout direction to right-to-left for Arabic.
//            UIApplication.shared.userInterfaceLayoutDirection = .rightToLeft
//        }
//    }

}
