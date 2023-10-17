//
//  SignInView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct SignInView: View {
    @AppStorage(Helper.Languagekey)
    var language = LocalizationService.shared.language
    @State private var selectedUser : UserType = UserType.init()
    var body: some View {
        VStack {
            CustomTitleBarView(title: "sign_in",hideImage: true)

            VStack{
                UserTypesList(selectedUser: $selectedUser)
                Spacer()

                HStack {
                    Text("Hello, World!".localized())
                    Text(selectedUser.title)

                }
                Spacer()
                
                CustomButton(Title:"sign_in",IsDisabled: .constant(false), action: {})

                HStack(spacing:5){
                    Text("Don't have an account ?".localized())
                    
                NavigationLink("sign_up".localized()){
                                            SignUpView()
                                        }

                }
                .font(Font.SoraRegular(size: getRelativeHeight(12.0)))
                //            .fontWeight(.regular)
                .foregroundColor(ColorConstants.Gray900)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
                .padding(.top, getRelativeHeight(12.0))
                
                
                HStack{
                    Button(action: {
                        language = .arabic
                    }, label: {
                        Text("عربى")
                    })
                    Spacer()
                    Button(action: {
                        language = .english_us
                    }, label: {
                        Text("english")
                    })
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
    SignInView()
        .environment(\.layoutDirection, Helper.getLanguage() == "en" ? .leftToRight : .rightToLeft)
}
