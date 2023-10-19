//////
//////  Language.swift
//////  SalamTech
//////
//////  Created by wecancity agency on 3/29/22.
//////
////
////import Foundation
//import SwiftUI
////
////enum Language: String {
////    case english_us = "en"
////    case arabic = "ar"
////}
////
//extension String {
////    func localizedString() -> LocalizedStringKey{
////        return LocalizedStringKey(self)
////    }
////    
////    /// Localizes a string using given language from Language enum.
////    /// - parameter language: The language that will be used to localized string.
////    /// - Returns: localized string.
////    
//    func localized() -> LocalizedStringKey {
////        @AppStorage(Helper.Languagekey)
////        var language = LocalizationService.shared.language
//
//        let path = Bundle.main.path(forResource: Helper.getLanguage(), ofType: "lproj")
//        let bundle: Bundle
//        if let path = path {
//            bundle = Bundle(path: path) ?? .main
//        } else {
//            bundle = .main
//        }
//        return self.localizedString()
//    }
////
////    /// Localizes a string using self as key.
////    /// - Parameters:
////    ///   - bundle: the bundle where the Localizable.strings file lies.
////    /// - Returns: localized string.
//////    private func localized(bundle: Bundle) -> String {
//////        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
//////    }
////    
////    
//    private func localizedString() -> LocalizedStringKey{
//       return LocalizedStringKey(self)
//   }
//}
