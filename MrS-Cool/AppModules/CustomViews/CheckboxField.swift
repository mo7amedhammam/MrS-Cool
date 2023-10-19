//
//  CheckboxField.swift
//  MrS-Cool
//
//  Created by wecancity on 18/10/2023.
//

import SwiftUI

struct CheckboxField: View {
    let idValue: String? = "radio"
    let label: String
    var size: CGFloat = 15
    var color: Color = .blue
    var textSize: CGFloat = 14
    @Binding var isMarked: Bool

    var body: some View {
        Button(action: {
            self.isMarked.toggle()
        }, label: {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .resizable()
                    .renderingMode(.template).colorMultiply(self.color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label.localized())
                    .font(Font.system(size: self.textSize))
                Spacer()
            }.foregroundColor(self.color)
        })
        .foregroundColor(Color.white)
    }
}

#Preview{
        CheckboxField(label: "I am Visible?", isMarked: .constant(true))
}
