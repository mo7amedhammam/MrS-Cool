//
//  SwiftUIView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/11/2023.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var changepasswordvm : ChangePasswordVM
    var hideImage : Bool? = true
    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "Change Password",hideImage: hideImage)
            VStack{
                GeometryReader{gr in
                    ScrollView(.vertical){
                        VStack{
                            VStack(alignment: .leading, spacing: 0) {

                                Group {
                                    SignUpHeaderTitle(Title: "Reset New Password ", subTitle: "Enter subtitle here")
                                    
                                    CustomTextField(fieldType:.Password,placeholder: "Current password *", text: $changepasswordvm.currentPassword)

                                    CustomTextField(fieldType:.Password,placeholder: "New password *", text: $changepasswordvm.newPassword)

                                    CustomTextField(fieldType:.Password,placeholder: "Confirm new password *", text: $changepasswordvm.confirmNewPassword)
                                }
                                .padding([.top])
                                
                            }
                            .padding(.top, 20)
                            Spacer()
                            VStack{
                                CustomButton(Title:"Save_Password",IsDisabled:.constant(!(changepasswordvm.isFormValid)) , action: {
                                    changepasswordvm.ChangePassword()
                                })
                                .frame(height: 50)
                                .padding(.top,40)

                            }
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
//        .onAppear(perform: {
//            switch Helper.shared.getSelectedUserType(){
//            case .Parent:
//                selectedUser.user = .Parent
//            case .Teacher:
//                selectedUser.user = .Student
//            default:
//                selectedUser.user = .Student
//            }
//        })
        
        .fullScreenCover(isPresented: $changepasswordvm.isPasswordChanged, onDismiss: {
            print("dismissed ")
            //            isVerified = true
            //            self.dismiss()
        }, content: {
            CustomSuccessView(action: {
                dismiss()
//                isVerified = true
            }, successStep: .constant(.passwordCahnged))
        })
        
        .showHud(isShowing: $changepasswordvm.isLoading)
        .showAlert(hasAlert: $changepasswordvm.isError, alertType: .error( message: "\(changepasswordvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))

//        NavigationLink(destination: destination, isActive: $isPush, label: {})

    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(ChangePasswordVM())
}
