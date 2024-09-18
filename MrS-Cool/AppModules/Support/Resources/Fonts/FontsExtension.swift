//
//  FontsExtension.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

enum fontsenum:String{
    case extraThinEn = "LamaSans-ExtraLight"
//    case extraThinAr = "Sora-Bold"
//    case extraThinItalicEn = "LamaSans-ThinItalic"
    case extraThinItalicAr = "ArbFONTS-LamaSans-ExtraLightItalic"

    case thinEn = "LamaSans-Thin"
    case thinAr = "ArbFONTS-LamaSans-Light"
    case thinItalicEn = "LamaSans-ThinItalic"
    case thinItalicAr = "ArbFONTS-LamaSans-LightItalic"

    case regularEn = "LamaSans-Regular"
    case regularAr = "ArbFONTS-LamaSans-Medium"
    case regularItalicEn = "LamaSans-RegularItalic"
    case regularItalicAr = "ArbFONTS-LamaSans-MediumItalic"

//    case semiBoldEn = "Sora-Bold"
    case semiBoldAr = "ArbFONTS-LamaSans-SemiBold"
//    case semiBoldItalicEn = "Sora-Bold"
    case semiBoldItalicAr = "ArbFONTS-LamaSans-SemiBoldItalic"

    case boldEn = "LamaSans-Bold"
    case boldAr = "ArbFONTS-LamaSans-Black"
    case boldItalicEn = "LamaSans-BoldItalic"
    case boldItalicAr = "ArbFONTS-LamaSans-BlackItalic"
    
//    case extrBoldEn = "LamaSans-Bold"
    case extraBoldAr = "ArbFONTS-LamaSans-ExtraBold"
//    case extraBoldItalicEn = "LamaSans-BoldItalic"
    case extraBoldItalicAr = "ArbFONTS-LamaSans-ExtraBoldItalic"

}

extension Font {
    static func extraLight( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.extraThinEn.rawValue:fontsenum.extraThinEn.rawValue, size: size)
    }
    static func extraLightItalic( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.thinItalicEn.rawValue:fontsenum.thinItalicEn.rawValue, size: size)
    }
    
    static func light( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.thinEn.rawValue:fontsenum.thinEn.rawValue, size: size)
    }
    static func lightItalic( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.thinItalicEn.rawValue:fontsenum.thinItalicEn.rawValue, size: size)
    }
    
    static func regular( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.regularEn.rawValue:fontsenum.regularEn.rawValue, size: size)
    }
    static func regularItalic( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.regularItalicEn.rawValue:fontsenum.regularItalicEn.rawValue, size: size)
    }
    
    static func semiBold( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.regularEn.rawValue:fontsenum.regularEn.rawValue, size: size)
    }
    static func semiBoldItalic( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.regularItalicEn.rawValue:fontsenum.regularItalicEn.rawValue, size: size)
    }
    
    static func bold( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.boldEn.rawValue:fontsenum.boldEn.rawValue, size: size)
    }
    static func boldItalic( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.boldItalicEn.rawValue:fontsenum.boldItalicEn.rawValue, size: size)
    }
    
    static func extraBold( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.boldEn.rawValue:fontsenum.boldEn.rawValue, size: size)
    }
    static func extraBoldItalic( size: CGFloat) -> Self {
        @State var language = LocalizeHelper.shared.currentLanguage
        return Font.custom(language == "en" ? fontsenum.boldItalicEn.rawValue:fontsenum.boldItalicEn.rawValue, size: size)
    }
    
    
//---------------//
//    static func SoraBold( size: CGFloat) -> Self {
//        @State var language = LocalizeHelper.shared.currentLanguage
//        return Font.custom(language == "en" ? fontsenum.boldEn.rawValue:"Sora-Bold", size: size)
//    }
//    static func SoraSemiBold( size: CGFloat) -> Self {
//        @State var language = LocalizeHelper.shared.currentLanguage
//        return Font.custom(language == "en" ? "Sora-SemiBold":"Sora-SemiBold", size: size)
//    }
//    static func SoraRegular( size: CGFloat) -> Self {
//        @State var language = LocalizeHelper.shared.currentLanguage
//        return Font.custom(language == "en" ? "SoraRegular":"SoraRegular", size: size)
//    }
//    static func RobotoRegular( size: CGFloat) -> Self {
//        @State var language = LocalizeHelper.shared.currentLanguage
//        return Font.custom(language == "en" ? "Roboto-Regular":"Roboto-Regular", size: size)
//    }
//    static func InterMedium( size: CGFloat) -> Self {
//        @State var language = LocalizeHelper.shared.currentLanguage
//        return Font.custom(language == "en" ? "InterMedium":"InterMedium", size: size)
//    }
}

