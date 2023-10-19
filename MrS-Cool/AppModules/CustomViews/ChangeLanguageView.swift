//
//  ChangeLanguageView.swift
//  MrS-Cool
//
//  Created by wecancity on 19/10/2023.
//

import SwiftUI

struct ChangeLanguageView: View {
    var body: some View {
        HStack{
            Button(action: {
                LocalizeHelper.shared.setLanguage(language: .arabic)
                
                //                print(LocalizeHelper.shared.currentLanguage)
                //                print(Helper.getLanguage())
                
            }, label: {
                Text("عربى")
            })
            Spacer()
            Button(action: {
                LocalizeHelper.shared.setLanguage(language: .english_us)
                
                //                print(LocalizeHelper.shared.currentLanguage)
                //                print(Helper.getLanguage())
                
            }, label: {
                Text("english")
            })
        }
        .foregroundColor(ColorConstants.Black900)
    }
}

#Preview {
    ChangeLanguageView()
}
