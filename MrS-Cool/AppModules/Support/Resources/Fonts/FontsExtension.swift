//
//  FontsExtension.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

extension Font {
    static func SoraBold( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? "Sora-Bold":"Sora-Bold", size: size)
    }
    static func SoraSemiBold( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? "Sora-SemiBold":"Sora-SemiBold", size: size)
    }
    static func SoraRegular( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? "SoraRegular":"SoraRegular", size: size)
    }
    static func RobotoRegular( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? "Roboto-Regular":"Roboto-Regular", size: size)
    }
    static func InterMedium( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? "InterMedium":"InterMedium", size: size)
    }
}

