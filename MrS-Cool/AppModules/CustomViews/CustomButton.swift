//
//  CustomButton.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

struct CustomButton: View {
//    @State private var language = LocalizationService.shared.language

    var imageName:String?
//    var imageColor:Color?
    var Title = ""
    @Binding var IsDisabled:Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
                action()
        }, label: {
            HStack(alignment:.center) {
                if let imageName = imageName{
                    Image(imageName)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20,
                               height: 20, alignment: .center)
//                        .font(Font.system(size: 2))
//                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                }
                if Title.count > 0 {
                    Text(Title.localized())
                        .font(Font.SoraSemiBold(size:14))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(minHeight: 0, maxHeight: .infinity)

            .padding()
            .foregroundColor(IsDisabled ? ColorConstants.Bluegray400:ColorConstants.WhiteA700)

            .background(
                RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0, bottomRight: 8.0)
                .fill(IsDisabled ? ColorConstants.Gray300:ColorConstants.MainColor)
//                .opacity(IsDisabled ? 0.5:1)
            )

            .cornerRadius(8)
        })
            .disabled(IsDisabled)
    }
}

#Preview {
    CustomButton(imageName:"icons8-plus-90",Title: "",IsDisabled: .constant(false), action:{})
        .frame(width:40,height: 40)
}


struct CustomBorderedButton: View {
    var imageName:String?
    var Title = ""
    @Binding var IsDisabled:Bool
    var action: () -> Void
    var body: some View {
        
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 0) {
                if let imageName = imageName{
                    Image(imageName)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20,
                               height: 20, alignment: .center)
//                        .font(Font.system(size: 2))
//                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                }
                Text(Title.localized())
                    .font(Font.SoraSemiBold(size: 14))
                    .fontWeight(.semibold)
//                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(IsDisabled ? ColorConstants.Bluegray400:ColorConstants.Black900)

            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(minHeight: 0, maxHeight: .infinity)
            .padding()

            .overlay(RoundedCorners(topLeft: 8, topRight: 8, bottomLeft: 8,
                                    bottomRight: 8)
                .stroke(IsDisabled ? ColorConstants.Gray300: ColorConstants.MainColor,
                        lineWidth: 2))
            .background(RoundedCorners(topLeft:8,topRight:8,bottomLeft:8,bottomRight:8)
                .fill(ColorConstants.WhiteA700))
        })
        .disabled(IsDisabled)
        
    }
}
#Preview{
    CustomBorderedButton(IsDisabled: .constant(false), action: {})
}
