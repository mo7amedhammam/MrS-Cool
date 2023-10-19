//
//  ContentView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView{
            VStack {
                SignInView()
            }
        }
        .hideNavigationBar()
        .localizeView()
    }
}

#Preview {
    ContentView()
    //        .localizeView()
}


//MARK:  --- ViewModifier to hide Navigation Bar---
struct hideNavigationBarModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}
// --- View Extension to apply the modifier ---
extension View {
    public func hideNavigationBar() -> some View {
        modifier(hideNavigationBarModifier())
    }
}



//// Hide default navigation bar from Navigation link screen.
//extension View {
//    func hideNavigationBar() -> some View {
//        self
//            .navigationBarTitle("", displayMode: .inline)
//            .navigationBarHidden(true)
//            .navigationViewStyle(StackNavigationViewStyle())
//    }
//    
//    @ViewBuilder func visibility(_ visibility: ViewVisibility) -> some View {
//        if visibility != .gone {
//            if visibility == .visible {
//                self
//            } else {
//                hidden()
//            }
//        }
//    }
//}
//
//enum ViewVisibility: CaseIterable {
//    case visible, // view is fully visible
//         invisible, // view is hidden but takes up space
//         gone // view is fully removed from the view hierarchy
//}
