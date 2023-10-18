//
//  MrS_CoolApp.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

@main
struct MrS_CoolApp: App {
    var body: some Scene {
//        @AppStorage(Helper.Languagekey)
//        var language = LocalizationService.shared.language

        WindowGroup {
            ContentView()
//                .environment(\.layoutDirection, Helper.getLanguage() == "en" ? .leftToRight : .rightToLeft)
        }
    }
}
