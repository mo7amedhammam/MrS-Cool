//
//  FontsExtension.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

extension Font {
    static func SoraBold(of size: CGFloat) -> Self {
        var language = LocalizationService.shared.language
        return Font.custom(language.rawValue == "en" ? "Sora-Bold":"Sora-Bold", size: size)
    }
    static func SoraSemiBold(of size: CGFloat) -> Self {
        var language = LocalizationService.shared.language
        return Font.custom(language.rawValue == "en" ? "Sora-SemiBold":"Sora-SemiBold", size: size)
    }
    static func SoraRegular(of size: CGFloat) -> Self {
        var language = LocalizationService.shared.language
        return Font.custom(language.rawValue == "en" ? "SoraRegular":"SoraRegular", size: size)
    }
    static func RobotoRegular(of size: CGFloat) -> Self {
        var language = LocalizationService.shared.language
        return Font.custom(language.rawValue == "en" ? "Roboto-Regular":"Roboto-Regular", size: size)
    }
    static func InterMedium(of size: CGFloat) -> Self {
        var language = LocalizationService.shared.language
        return Font.custom(language.rawValue == "en" ? "InterMedium":"InterMedium", size: size)
    }
}

