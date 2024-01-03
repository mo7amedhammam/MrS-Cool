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
