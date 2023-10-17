//
//  CustomButton.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

struct CustomButton: View {
    @State private var language = LocalizationService.shared.language

    var imageName:String?
    var Title = ""
    @Binding var IsDisabled:Bool
    var action: () -> Void

    var body: some View {
        
        Button(action: {
//            DispatchQueue.main.async{
                action()
//            }
        }, label: {
            HStack {
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
                    .font(Font.SoraSemiBold(size: getRelativeHeight(13.0)))
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
//            .frame(height:40)
            .padding()
            .foregroundColor(IsDisabled ? ColorConstants.Bluegray400:ColorConstants.WhiteA700)

            .background(
                RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                .fill(IsDisabled ? ColorConstants.Gray300:ColorConstants.Black900)
//                .opacity(IsDisabled ? 0.5:1)
            )
            .cornerRadius(12)
        })
            .disabled(IsDisabled)
    }
}

#Preview {
    CustomButton(imageName:"img_group_512394",Title: "Button",IsDisabled: .constant(false), action:{})
}


struct CustomBorderedButton: View {
    var imageName:String?
    var Title = ""
    @Binding var IsDisabled:Bool
    var action: () -> Void
    var body: some View {
        
        Button(action: {}, label: {
            HStack(spacing: 0) {
                Text("button")
                    .font(Font.SoraSemiBold(size: getRelativeHeight(13.0)))
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)

            }
            .foregroundColor(IsDisabled ? ColorConstants.Bluegray400:ColorConstants.Black900)

            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()

            .overlay(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                    bottomRight: 8.0)
                .stroke(IsDisabled ? ColorConstants.Gray300: ColorConstants.Black900,
                        lineWidth: 2))
            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                       bottomRight: 8.0)
                .fill(ColorConstants.WhiteA700))
        })
      
        .disabled(IsDisabled)

        
    }
}
#Preview{
    CustomBorderedButton(IsDisabled: .constant(false), action: {})
}
