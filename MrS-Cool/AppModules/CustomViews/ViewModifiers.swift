//
//  ViewModifiers.swift
//  MrS-Cool
//
//  Created by wecancity on 20/10/2023.
//

import SwiftUI

//MARK:  --- ViewModifier to hide Navigation Bar---
struct hideNavigationBarModifier: ViewModifier {
    @ObservedObject var localizeHelper = LocalizeHelper.shared

    public func body(content: Content) -> some View {
        content
        //MARK:  --- ViewModifier to hide Navigation Bar---
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        
        //MARK:  --- add Done key for keyboard to Dismss Keyboard ---
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack{
                        Spacer()
                        Button("Done".localized()) {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
            }
                
    }
}
// --- View Extension to apply the modifier ---
extension View {
    public func hideNavigationBar() -> some View {
        modifier(hideNavigationBarModifier())
    }
}

