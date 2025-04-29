//
//  CustomProgressView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

struct HudView: View {
    @Binding var isShowing: Bool?
    var text: String?
    var size: CGSize? = CGSize(width: 120,height: 120)

    var body: some View {
        ZStack {
            if isShowing ?? false{
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ActivityIndicatorView(style: .medium, color: .white, size: CGSize(width: 200, height: 200))
                        .scaleEffect(1.3, anchor: .center)
                    if let labelText = text {
                        Text(labelText)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: size?.width,height: size?.height)
                    .background(Color.black900.opacity(0.9))
                    .cornerRadius(8)
            }
        }
    }
}

struct ActivityIndicatorView: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style
    let color: UIColor
    let size: CGSize

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = color
        view.frame = CGRect(origin: .zero, size: size)
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}


#Preview{
    HudView(isShowing: .constant(true), text: "text",size: CGSize(width: 120, height: 120))
}

extension View {
    func showHud(isShowing: Binding<Bool?>, text: String? = nil) -> some View {
        return self.overlay(HudView(isShowing: isShowing, text: text))
    }
}

struct HudView1: View {
    @Binding var isShowing: Bool  // Changed from Bool? to Bool
    var text: String?
    var size: CGSize = CGSize(width: 120, height: 120)  // Made non-optional

    var body: some View {
        ZStack {
            if isShowing {  // Removed optional unwrapping
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(9999)  // Ensure it appears above everything

                VStack {
                    ActivityIndicatorView(style: .large, color: .white, size: CGSize(width: 200, height: 200))
                        .scaleEffect(1.3, anchor: .center)
                    
                    if let labelText = text {
                        Text(labelText)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: size.width, height: size.height)  // Removed optional chaining
                .background(Color.black900.opacity(0.9))
                .cornerRadius(8)
                .zIndex(10000)  // Higher than the background
            }
        }
        .animation(.default, value: isShowing)  // Add smooth appearance
    }
}

extension View {
    func showHud1(isShowing: Binding<Bool>, text: String? = nil) -> some View {
        return self.overlay(
            HudView1(isShowing: isShowing, text: text)
                .allowsHitTesting(isShowing.wrappedValue)  // Block interactions when visible
        )
    }
}


