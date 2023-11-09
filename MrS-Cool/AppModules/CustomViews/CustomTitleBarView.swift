//
//  CustomTitleBarView.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

struct CustomTitleBarView: View {

    var imageName: String?
    var title: String
    var hideImage: Bool? = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
//        VStack{
            HStack {
                if hideImage == false{
                    Image(imageName ?? (Helper.shared.getLanguage() == "en" ? "img_arrowleft":"img_arrowright"))
                        .resizable()
                        .frame(width: 12.0,
                               height: 20.0, alignment: .center)
                        .scaledToFit()
                        .clipped()
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                
                Spacer()
                Text(title.localized())
                    .font(Font.SoraBold(size:18.0))
                    .fontWeight(.bold)
                    .foregroundColor(ColorConstants.Gray900)
//                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.leading)
                Spacer()
                if hideImage == false{
                    Color(.clear).frame(width: 12.0,height: 20.0)
                }
            }
//            .frame(width:UIScreen.main.bounds.width)
            .padding(.bottom,15)
            .padding(.horizontal)
            .background(ColorConstants.WhiteA700)
            .onTapGesture {
                hideKeyboard()
            }
        }
//        Spacer()
//    }
}

#Preview {
    CustomTitleBarView( title: "تسجيل دخول ")
        .localizeView()
}

