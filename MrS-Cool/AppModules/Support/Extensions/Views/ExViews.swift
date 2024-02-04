//
//  ExViews.swift
//  MrS-Cool
//
//  Created by wecancity on 03/01/2024.
//

import Foundation
import SwiftUI

struct CornersRadious: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct CornersStroke: Shape {
        
        var radius: CGFloat = .infinity
        var corners: UIRectCorner = .allCorners
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    extension View {
        public func borderRadius<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat, corners: UIRectCorner) -> some View where S : ShapeStyle {
            let roundedRect = CornersStroke(radius: cornerRadius, corners: corners)
            return clipShape(roundedRect)
                .overlay(roundedRect.stroke(content, lineWidth: width))
        }
    }
