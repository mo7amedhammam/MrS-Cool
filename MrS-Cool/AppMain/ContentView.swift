//
//  ContentView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(Helper.Languagekey)
    var language = LocalizationService.shared.language
    
    var body: some View {
        NavigationView{
            VStack {
                //            Image(systemName: "globe")
                //                .imageScale(.large)
                //                .foregroundStyle(.tint)
                //            Text("Hello, world!")
                SignInView()
            }
                    .hideNavigationBar()

        }
        //        .environment(\.locale, .init(identifier: Helper.getLanguage()))
//        .hideNavigationBar()
        .environment(\.layoutDirection, language.rawValue == "en" ? .leftToRight : .rightToLeft)
        
        //        .padding()
    }
}

#Preview {
    ContentView()
}


// Hide default navigation bar from Navigation link screen.
extension View {
    func hideNavigationBar() -> some View {
        self
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
    }

    @ViewBuilder func visibility(_ visibility: ViewVisibility) -> some View {
        if visibility != .gone {
            if visibility == .visible {
                self
            } else {
                hidden()
            }
        }
    }
}

enum ViewVisibility: CaseIterable {
    case visible, // view is fully visible
         invisible, // view is hidden but takes up space
         gone // view is fully removed from the view hierarchy
}
