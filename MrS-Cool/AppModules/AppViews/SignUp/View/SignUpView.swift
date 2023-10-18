//
//  SignUpView.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedUser : UserType = UserType.init()

    var body: some View {

        VStack(spacing:0) {
            CustomTitleBarView(title: "sign_up".localized(),hideImage: false)

            VStack{
                UserTypesList(selectedUser: $selectedUser)

                Spacer()
                HStack {
                    Text("Hello, World!".localized())
                }
                Spacer()
                CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {})
                
                HStack{
                    HStack(spacing:5){
                        Text("Already have an account ?".localized())
                            .foregroundColor(ColorConstants.Gray900)
                            .font(Font.SoraRegular(size: 12))

                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("sign_in".localized())
                                })
                    
                    .foregroundColor(ColorConstants.Red400)
                    .font(Font.SoraRegular(size: 13))

            }
            .multilineTextAlignment(.leading)
            .padding(.top, 8)

                    
//                    .font(Font.SoraRegular(size: getRelativeHeight(12.0)))
//                    //            .fontWeight(.regular)
//                    .foregroundColor(ColorConstants.Gray900)
//                    .minimumScaleFactor(0.5)
//                    .multilineTextAlignment(.leading)
//                    .padding(.top, getRelativeHeight(12.0))

                }
                .foregroundColor(ColorConstants.Black900)
            }
                    .hideNavigationBar()
                    .padding(.horizontal)
                    .background(ColorConstants.Gray50.ignoresSafeArea())
        }
    }
}


#Preview {
    SignUpView()
}
