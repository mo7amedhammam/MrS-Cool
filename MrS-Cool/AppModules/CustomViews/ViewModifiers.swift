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
            .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage == "ar" ? .rightToLeft : .leftToRight)

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
        modifier(hideNavigationBarModifier()).localizeView()
    }
}

//MARK:  --- Extension to enable swipe to back even if nafigation bar is hidden ---
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
//        interactivePopGestureRecognizer?.isEnabled = false
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


//----------- The Solution: NavigationPopGestureDisabler ------
extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) {
            $0.next
        }.first { $0 is UIViewController } as? UIViewController
    }
}

private struct NavigationPopGestureDisabler: UIViewRepresentable {
    let disabled: Bool
    
    func makeUIView(context: Context) -> some UIView { UIView() }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            uiView
                .parentViewController?
                .navigationController?
                .interactivePopGestureRecognizer?.isEnabled = !disabled
        }
    }
}
public extension View {
    @ViewBuilder
    func navigationPopGestureDisabled(_ disabled: Bool) -> some View {
        background {
            NavigationPopGestureDisabler(disabled: disabled)
        }
    }
}
