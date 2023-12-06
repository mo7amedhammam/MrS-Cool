//
//  SignInView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct SignInView: View {
    @StateObject var teachersigninvm = SignInVM()
    @State private var selectedUser : UserType = UserType.init()
    
    @State var rememberMe = false
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "sign_in",hideImage: true)
            VStack{
                UserTypesList(selectedUser: $selectedUser){
                    switch selectedUser.user {
                    case .Student:
                        Helper.shared.setSelectedUserType(userType: .Student)

                    case .Parent:
                        Helper.shared.setSelectedUserType(userType: .Parent)

                    case .Teacher:
                        Helper.shared.setSelectedUserType(userType: .Teacher)
                    }
                }
                GeometryReader{gr in
                    ScrollView(.vertical){
                        VStack{
                            VStack(alignment: .leading, spacing: 0) {
                                VStack (alignment: .leading,spacing: 5){
                                    Text("Welcome Back!".localized())
                                        .font(Font.SoraBold(size:18))
                                        .fontWeight(.bold)
                                        .foregroundColor(ColorConstants.Black900)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text("Sign in to continue".localized())
                                        .font(Font.SoraRegular(size: 10.0))
                                        .fontWeight(.regular)
                                        .foregroundColor(ColorConstants.Black900)
                                        .multilineTextAlignment(.leading)
                                    
                                }
                                Group {
                                    CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $teachersigninvm.phone ,textContentType:.telephoneNumber,keyboardType:.numberPad)
                                        .onChange(of: teachersigninvm.phone) { newValue in
                                            if newValue.count > 11 {
                                                teachersigninvm.phone = String(newValue.prefix(11))
                                            }
                                        }
                                    CustomTextField(fieldType:.Password,placeholder: "Password *", text: $teachersigninvm.Password)
                                }
                                .padding([.top])
                                
                                HStack {
                                    CheckboxField(label: "Remember me",
                                                  color: ColorConstants.Black900, textSize: 13,
                                                  isMarked: $rememberMe)
                                    Spacer()
                                    
                                    Button(action: {
                                        isPush = true
                                        destination = AnyView( Text("Forget password"))
                                    }, label: {
                                        Text("Forget password ?".localized())
                                            .font(Font.SoraRegular(size: 13))
                                            .fontWeight(.regular)
                                            .foregroundColor(ColorConstants.Red400)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 112.0, height: 30,
                                                   alignment: .trailing)
                                    })
                                }
                                .padding(.top,12)
                            }
                            .padding(.top, 20)
                            Spacer()
                            VStack{
                                CustomButton(Title:"sign_in",IsDisabled:.constant(!(teachersigninvm.isFormValid)) , action: {
                                    teachersigninvm.TeacherLogin()
                                })
                                .frame(height: 50)
                                .padding(.top,40)
                                HStack(spacing:5){
                                    Text("Don't have an account ?".localized())
                                        .foregroundColor(ColorConstants.Gray900)
                                        .font(Font.SoraRegular(size: 12))
                                    
                                    Button(action: {
                                        isPush = true
                                        destination = AnyView(SignUpView(selecteduser:$selectedUser).hideNavigationBar())
                                    }, label: {
                                        Text("sign_up".localized())
                                            .foregroundColor(ColorConstants.Red400)
                                            .font(Font.SoraRegular(size: 13))
                                    })
                                }
                                .multilineTextAlignment(.leading)
                                .padding(.vertical, 8)
                            }
                            ChangeLanguageView()
                        }
                        .frame(minHeight: gr.size.height)
                        .padding(.horizontal)
                    }
                }
                .frame(width:UIScreen.main.bounds.width)
            }
            .padding(.horizontal)
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onChange(of: selectedUser.user, perform: { val in
            switch val {
            case .Student:
                Helper.shared.setSelectedUserType(userType: .Student)

            case .Parent:
                Helper.shared.setSelectedUserType(userType: .Parent)

            case .Teacher:
                Helper.shared.setSelectedUserType(userType: .Teacher)
                destination = AnyView(TeacherHomeView())
            }
          })
        .showHud(isShowing: $teachersigninvm.isLoading)
        .showAlert(hasAlert: $teachersigninvm.isError, alertType: .error( message: "\(teachersigninvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))

        NavigationLink(destination: destination, isActive: .constant(teachersigninvm.isLogedin||isPush), label: {})
            .onDisappear{
                teachersigninvm.cleanup()
            }
    }
}

#Preview {
    SignInView()
}

