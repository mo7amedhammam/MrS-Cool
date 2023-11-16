//
//  CustomSuccessView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/11/2023.
//

import SwiftUI

enum successSteps{
    case teacherRegistered, accountCreated, passwordReset, passwordCahnged
}
struct CustomSuccessView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var title : String = ""
    @State var subtitle : String = ""
    @State var describtion : String = ""
    
        var action : (()->())?
    //    @State var isPush = false
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    @Binding var successStep : successSteps
    var body: some View {
        VStack(spacing:0){
            CustomTitleBarView(title: title,hideImage: true)
            GeometryReader{gr in
                ScrollView(.vertical){
                    VStack{
                        Image("successicon")
                            .padding(30)
                        
                        VStack(spacing:15){
                            
                            Text(subtitle.localized())
                                .font(Font.SoraBold(size: 18.0))
                                .fontWeight(.bold)
                                .foregroundColor(.mainBlue)
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
                            action?()
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
        .onAppear(perform: {
            switch successStep{
            case .teacherRegistered:
                title = "Phone Verification"
                subtitle = "Account Created!"
                describtion = "Your account had beed created\nsuccessfully\nPlease Submit to compelete your\naccount and enjoy"
                
            case .accountCreated:
                title = "Account Created"
                subtitle = "Account Created!"
                describtion = "Your account had beed created\nsuccessfully\nPlease sign in to use your account\nand enjoy"
                
            case .passwordReset:
                title = "Reset Password"
                subtitle = "Reset Your New Password"
                describtion = "Your password had beed changed\nsuccessfully\nPlease sign in to use your\naccount and enjoy"
            case .passwordCahnged:
                title = "Reset Password"
                subtitle = "Change Your New Password"
                describtion = "Your password had beed changed\nsuccessfully\nPlease sign in to use your\naccount and enjoy"
            }
        })
        
        //        .onDisappear(perform: {
        ////            action?()
        //        })
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
    }
}

#Preview {
    CustomSuccessView( successStep: .constant(.teacherRegistered))
}
