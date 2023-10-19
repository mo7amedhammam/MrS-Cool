//
//  LocalizationService.swift
//  SalamTech
//
//  Created by wecancity agency on 3/29/22.
//

import SwiftUI

//MARK:  --- List your languages ---
enum Languages: String {
    case english_us = "en"
    case arabic = "ar"
}

//MARK:  --- observable for Any changes in languages ---
class LocalizeHelper: ObservableObject {
    static var shared = LocalizeHelper()

    @Published var currentLanguage: String {
        didSet {
            Helper.setLanguage(currentLanguage: currentLanguage)
            print("current:",currentLanguage)
            print("helper:",Helper.getLanguage())
        }
    }
    
    private init() {
        self.currentLanguage =  Helper.getLanguage()
    }
    
    func setLanguage(language: Languages) {
        self.currentLanguage = language.rawValue
    }
}

//MARK:  --- ViewModifier to update layout Direction RTL ---
struct LocalizationViewModifier: ViewModifier {
    @ObservedObject var localizeHelper = LocalizeHelper.shared
    public func body(content: Content) -> some View {
        content
            .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage))
            .environment(\.layoutDirection, localizeHelper.currentLanguage == "ar" ? .rightToLeft : .leftToRight)
    }
}
// --- View Extension to apply the modifier ---
extension View {
    public func localizeView() -> some View {
        modifier(LocalizationViewModifier())
    }
}

//MARK:  --- String Ectension to retun localized string ---
extension String {
    func localized() -> LocalizedStringKey{
        return LocalizedStringKey(self)
    }
}
