//
//  SignInView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct SignInView: View {
//    @AppStorage(Helper.Languagekey)
   @State var language = LocalizationService.shared.language
    
    @State private var selectedUser : UserType = UserType.init()
    
    @State var phone = ""
    @State var Password = ""
    @State var rememberMe = false
    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "sign_in",hideImage: true)

            VStack{
                UserTypesList(selectedUser: $selectedUser)

//                ScrollView(.vertical){
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Welcome Back!".localized())
                            .font(Font.SoraBold(size:18))
                            .fontWeight(.bold)
                            .foregroundColor(ColorConstants.Black900)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .frame(width: 143.0, height: 23.0,
                                   alignment: .topLeading)
                            .padding(.horizontal, 15.0)
                        Text("Sign in to continue".localized())
                            .font(Font.SoraRegular(size: 10.0))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Black900)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .frame(width: 95.0, height: 13.0,
                                   alignment: .topLeading)
                            .padding(.horizontal, 15.0)
                        
                        Group {
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                        }
                        .padding([.horizontal,.top])
                        
                        HStack {
                            CheckboxField(label: "Remember me",
                                          color: ColorConstants.Black900,
                                          isMarked: $rememberMe)
                                .minimumScaleFactor(0.5)
                                .frame(width: 113.0, height: 16.0,
                                       alignment: .top)

                            Spacer()
                            Button(action: {
                                
                            }, label: {
                            Text("Forget password ?")
                                    .font(Font.SoraRegular(size: 12.0))
                                .fontWeight(.regular)
                                .foregroundColor(ColorConstants.Red400)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 112.0, height: 16.0,
                                       alignment: .trailing)
                            })

                        }

                        .padding(.top, 14.0)
                        .padding(.horizontal, 15.0)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width,
                           alignment: .leading)
                .padding(.top, 30.0)
//                }
                

                Spacer()
                
                CustomButton(Title:"sign_in",IsDisabled: .constant(false), action: {})

                HStack(spacing:5){
                    Text("Don't have an account ?".localized())
                    
                NavigationLink("sign_up".localized()){
                                            SignUpView()
                                        }

                }
                .font(Font.SoraRegular(size: 12))
                .foregroundColor(ColorConstants.Gray900)
//                .minimumScaleFactor(0.5)
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
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
        }
        .environment(\.layoutDirection, language.rawValue == "en" ? .leftToRight : .rightToLeft)

    }

}

#Preview {
    SignInView()
//        .environment(\.layoutDirection, Helper.getLanguage() == "en" ? .leftToRight : .rightToLeft)
}
