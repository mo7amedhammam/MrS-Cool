//
//  NavigationController.swift
//  MrS-Cool
//
//  Created by wecancity on 07/07/2024.
//



import UIKit

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.isEnabled = false
    }
}

import SwiftUI

struct CustomNavigationView<Content: View>: UIViewControllerRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let rootViewController = UIHostingController(rootView: content)
        let navigationController = CustomNavigationController(rootViewController: rootViewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let rootViewController = uiViewController.viewControllers.first as? UIHostingController<Content> {
            rootViewController.rootView = content
        }
    }
}
