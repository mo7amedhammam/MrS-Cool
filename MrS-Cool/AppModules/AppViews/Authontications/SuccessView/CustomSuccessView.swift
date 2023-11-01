//
//  CustomSuccessView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/11/2023.
//

import SwiftUI

struct CustomSuccessView: View {
    @Environment(\.dismiss) private var dismiss

    var title : String = "Phone Verification"
    var subtitle : String = "Account Created!"
    var describtion : String = "Your account had beed created\nsuccessfully\nPlease sign in to use your account\nand enjoy"
    var action : (()->())?
//    @State var isPush = false
    @State var isPush = false
    @State var destination = AnyView(Text(""))

    var body: some View {
        VStack(spacing:0){
            CustomTitleBarView(title: title)
            GeometryReader{gr in
                ScrollView(.vertical){
                    VStack{
                        Image("successicon")
                            .padding(30)
                        
                        VStack(spacing:15){
                            
                            Text(subtitle.localized())
                                .font(Font.SoraBold(size: 18.0))
                                .fontWeight(.bold)
                                .foregroundColor(ColorConstants.Bluegray901)
                                .multilineTextAlignment(.leading)
                            Text(describtion.localized())
                                .font(Font.SoraRegular(size: 14))
                                .fontWeight(.regular)
                                .foregroundColor(ColorConstants.Bluegray402)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                            
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity)
                        .background(ColorConstants.WhiteA700)
                        .cornerRadius(12)
                        Spacer()
                        CustomButton(Title: "Submit", IsDisabled: .constant(false), action: {
                            dismiss()
                        })
                        .frame(height: 50)
                    }
                    .frame(minHeight: gr.size.height)
                    .padding(.horizontal)
                }
                .frame(width:UIScreen.main.bounds.width)
            }
            NavigationLink(destination: destination, isActive: $isPush, label: {})
        }
        .onDisappear(perform: {
            action?()
        })
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
    }
}

#Preview {
    CustomSuccessView()
}
