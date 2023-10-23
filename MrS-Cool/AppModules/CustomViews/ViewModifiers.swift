//
//  ViewModifiers.swift
//  MrS-Cool
//
//  Created by wecancity on 20/10/2023.
//

import SwiftUI

//MARK:  --- ViewModifier to hide Navigation Bar---
//@available(iOS 16.0, *)
struct hideNavigationBarModifier: ViewModifier {
    @ObservedObject var localizeHelper = LocalizeHelper.shared
    @Environment(\.dismiss) var dismiss

    public func body(content: Content) -> some View {
        content
        //MARK:  --- ViewModifier to hide Navigation Bar---
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationViewStyle(.stack)
                    
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
        
        //MARK:  --- Slide to Diamiss ---
        //            .highPriorityGesture(
        //                DragGesture(minimumDistance: 70, coordinateSpace: .local)
        //                    .onEnded { value in
        //                        let edgeGestureThreshold: CGFloat = 30 // Adjust the value as needed
        //                        let translation = value.translation.width
        //                        let isSwipeFromLeadingEdge = translation > 0 && value.startLocation.x < edgeGestureThreshold
        //                        let isSwipeFromTrailingEdge = translation < 0 && (UIScreen.main.bounds.width - value.startLocation.x) < edgeGestureThreshold
        //
        //                        if isSwipeFromLeadingEdge {
        //                            // Swipe from left edge
        //                            guard localizeHelper.currentLanguage == "en" else { return }
        //                            self.dismiss()
        //                        } else if isSwipeFromTrailingEdge {
        //                            // Swipe from right edge
        //                            guard localizeHelper.currentLanguage == "ar" else { return }
        //                            self.dismiss()
        //                        }
        //                    }
        //            )
        
    }
        private var backButton: some View {
            @Environment(\.dismiss) var dismiss
            return Button(action: {
                  dismiss()
              }) {
                  Image(systemName: "arrow.left")
                      .foregroundColor(.white)
              }
          }
    
}

// --- View Extension to apply the modifier ---
extension View {
    public func hideNavigationBar() -> some View {
        modifier(hideNavigationBarModifier())
    }
}



struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            configure(nc)
        }
    }
}
