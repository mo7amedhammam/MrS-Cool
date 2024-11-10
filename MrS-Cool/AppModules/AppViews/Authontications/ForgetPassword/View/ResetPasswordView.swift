//
//  ResetPasswordView.swift
//  MrS-Cool
//
//  Created by wecancity on 20/03/2024.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var resetpasswordvm : ResetPasswordVM
    var hideImage : Bool? = true
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    @Binding var passwordresset : Bool
    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "Reset New Password",hideImage: hideImage)
            VStack{
                GeometryReader{gr in
                    ScrollView(.vertical){
                        VStack{
                            VStack(alignment: .leading, spacing: 0) {

                                Group {
                                    SignUpHeaderTitle(Title: "Reset New Password ")
                                    
                                    CustomTextField(fieldType:.Password,placeholder: "New password *", text: $resetpasswordvm.newPassword)

                                    CustomTextField(fieldType:.Password,placeholder: "Confirm new password *", text: $resetpasswordvm.confirmNewPassword)
                                }
                                .padding([.top])
                                
                            }
                            .padding(.top, 20)
                            Spacer()
                            VStack{
                                CustomButton(Title:"Submit",IsDisabled:.constant(!(resetpasswordvm.isFormValid)) , action: {
                                    resetpasswordvm.ResetPassword()
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
        .onAppear(perform: {
            resetpasswordvm.monitorTextFields()
//            switch Helper.shared.getSelectedUserType(){
//            case .Parent:
//                selectedUser.user = .Parent
//            case .Teacher:
//                selectedUser.user = .Student
//            default:
//                selectedUser.user = .Student
//            }
        })
        
        .fullScreenCover(isPresented: $resetpasswordvm.isPasswordReset, onDismiss: {
            print("dismissed ")
            //            isVerified = true
            //            self.dismiss()
        }, content: {
            CustomSuccessView(action: {
                dismiss()
//                isVerified = true
//                destination = AnyView(SignInView())
//                    isPush = true
                passwordresset = true

            }, successStep: .constant(.passwordCahnged))
        })
        
        .showHud(isShowing: $resetpasswordvm.isLoading)
        .showAlert(hasAlert: $resetpasswordvm.isError, alertType: .error( message: "\(resetpasswordvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))

        NavigationLink(destination: destination, isActive: $isPush, label: {})

    }
}

#Preview {
    ResetPasswordView( passwordresset: .constant(false))
        .environmentObject(ResetPasswordVM())
}
