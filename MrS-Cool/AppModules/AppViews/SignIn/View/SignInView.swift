//
//  SignInView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct SignInView: View {
    @AppStorage("language")
    var language = LocalizationService.shared.language

    var body: some View {
        VStack{
            HStack {
                Text("Hello, World!".localized(language))
                Text("Mohamed")
                
            }
            HStack{
            Button(action: {
                LocalizationService.shared.language = .arabic
                Helper.setLanguage(currentLanguage: "ar")
                
            }, label: {
                Text("عربى")
            })
            Button(action: {
                LocalizationService.shared.language = .english_us
                Helper.setLanguage(currentLanguage: "en")
                
            }, label: {
                Text("english")
            })
        }
        }
        .environment(\.layoutDirection, language.rawValue == "en" ? .leftToRight : .rightToLeft)
    }
}

#Preview {
    SignInView()
}
