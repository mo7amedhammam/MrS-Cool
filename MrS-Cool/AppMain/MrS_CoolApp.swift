//
//  MrS_CoolApp.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

@available(iOS 16.0, *)
@main
struct MrS_CoolApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // Set to force light mode
        }
    }
}
