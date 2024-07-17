//
//  SignInView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct SignInView: View {
    @StateObject var teachersigninvm = SignInVM()
    @State var selectedUser : UserType = UserType.init()
    
    @State var rememberMe = false
    @State var isPush = false
    @State var destination = AnyView(StudentTabBarView())
    var hideimage:Bool? = true
    var body: some View {
            VStack(spacing:0) {
                CustomTitleBarView(title: "sign_in",hideImage: hideimage)
                VStack{
                    UserTypesList(selectedUser: $selectedUser){
                        switch selectedUser.user {
                        case .Student:
                            Helper.shared.setSelectedUserType(userType:.Student)
                            destination = AnyView(StudentTabBarView())
                            
                        case .Parent:
                            Helper.shared.setSelectedUserType(userType:.Parent)
                            destination = AnyView(ParentTabBarView())
                            
                        case .Teacher:
                            Helper.shared.setSelectedUserType(userType:.Teacher)
                            destination = AnyView(TeacherTabBarView())
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
                                        CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $teachersigninvm.phone ,textContentType:.telephoneNumber,keyboardType:.asciiCapableNumberPad, isvalid:teachersigninvm.isphonevalid)
                                            .onChange(of: teachersigninvm.phone){ newValue in
                                              if newValue.count > 11 {
                                                    teachersigninvm.phone = String(newValue.prefix(11))
                                                }
                                            }
                                        CustomTextField(fieldType:.Password,placeholder: "Password *", text: $teachersigninvm.Password,isvalid:teachersigninvm.isPasswordvalid)
                                            .onChange(of: teachersigninvm.Password) { newValue in
                                                    if newValue.containsNonEnglishOrNumbers() {
                                                        teachersigninvm.Password = String(newValue.dropLast())
                                                    }
                                                }
                                    }
                                    .padding([.top])
                                    
                                    HStack {
                                        CheckboxField(label: "Remember me",
                                                      color: ColorConstants.Black900, textSize: 13,
                                                      isMarked: $rememberMe)
                                        Spacer()
                                        
                                        Button(action: {
                                            destination = AnyView(EnterMobileView())
                                            isPush = true
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
                                            destination = AnyView(SignUpView(selecteduser:$selectedUser).hideNavigationBar())
                                            isPush = true
                                        }, label: {
                                            Text("sign_up".localized())
                                                .foregroundColor(ColorConstants.Red400)
                                                .font(Font.SoraRegular(size: 13))
                                        })
                                    }
                                    .multilineTextAlignment(.leading)
                                    .padding(.vertical, 8)
                                }
    //                            ChangeLanguageView()
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
                }
              })
            .showHud(isShowing: $teachersigninvm.isLoading)
            .showAlert(hasAlert: $teachersigninvm.isError, alertType: .error( message: "\(teachersigninvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
            .navigationViewStyle(StackNavigationViewStyle()) // Disable swipe back gesture

            NavigationLink(destination: destination, isActive: $isPush, label: {})
            
                .onDisappear{
                    teachersigninvm.cleanup()
                }
                .onChange(of: teachersigninvm.isLogedin) { newval in
                    switch selectedUser.user {
                    case .Student:
    //                    destination = AnyView(StudentTabBarView())
                        Helper.shared.changeRoot(toView: StudentTabBarView())

                    case .Parent:
    //                    destination = AnyView(ParentTabBarView())
                            Helper.shared.changeRoot(toView: ParentTabBarView())
                    case .Teacher:
                        switch teachersigninvm.teachermodel?.profileStatusID {
                        case 1:
                            destination = AnyView(SignUpView(selecteduser: $selectedUser, currentStep: .subjectsData)
                            ) // subject info
                            isPush = newval

                        case 2:
                            destination = AnyView(SignUpView(selecteduser: $selectedUser, currentStep: .documentsData)
                            ) // document info
                            isPush = newval

                        default: // 3
    //                        destination = AnyView(TeacherTabBarView())
                            Helper.shared.changeRoot(toView: TeacherTabBarView())

                        }
                    }
                }
                .gesture(
                    DragGesture().onChanged { _ in
                        // Disable swipe gestures
                    }
            )

        
    }
}

#Preview {
    SignInView()
}

