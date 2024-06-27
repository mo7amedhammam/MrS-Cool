//
//  EnterMobileView.swift
//  MrS-Cool
//
//  Created by wecancity on 20/03/2024.
//

import SwiftUI

struct EnterMobileView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var resetpasswordvm = ResetPasswordVM()
    var hideImage : Bool? = false
    @State private var isVerified : Bool = false
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    @State var passwordresset = false

    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "Forget Password",hideImage: hideImage)
            VStack{
                GeometryReader{gr in
                    ScrollView(.vertical){
                        VStack{
                            VStack(alignment: .leading, spacing: 0) {
                                Group {
                                    Text("Welcome To Mr.S-cool...".localized())
                                        .foregroundColor(Color.mainBlue)
                                        .font(.SoraBold(size: 18))

                                    CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $resetpasswordvm.phone ,textContentType:.telephoneNumber,keyboardType:.asciiCapableNumberPad)
                                        .onChange(of: resetpasswordvm.phone) { newValue in
                                            if newValue.count > 11 {
                                                resetpasswordvm.phone = String(newValue.prefix(11))
                                            }
                                        }

                                    Text("We will send  you otp to your mobile number\nto reset a new password".localized())
                                        .foregroundColor(Color.mainBlue)
                                        .font(.SoraRegular(size: 13))
                                        .frame(maxWidth:.infinity,alignment:.center)
                                        .multilineTextAlignment(.center)
                                }
                                .padding([.top])
                                
                            }
                            .padding(.top, 20)
                            Spacer()
                            VStack{
                                CustomButton(Title:"Verify",IsDisabled:.constant(!(resetpasswordvm.isPhoneValid)) , action: {
                                    resetpasswordvm.SendResetOtp()
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
        
        .fullScreenCover(isPresented: $resetpasswordvm.isOtpReceived, onDismiss: {
            print("dismissed ")
            if isVerified {
                destination = AnyView(ResetPasswordView(hideImage: false, passwordresset: $passwordresset).environmentObject(resetpasswordvm))
//                    currentStep = .subjectsData
                    isPush = true
//                dismiss()
                
            }
        }, content: {
            OTPVerificationView(PhoneNumber:resetpasswordvm.phone,CurrentOTP: resetpasswordvm.OtpM?.otp ?? 0, verifycase: .ressetingpassword, secondsCount:resetpasswordvm.OtpM?.secondsCount ?? 0, isVerified: $isVerified, sussessStep: .constant(.accountCreated))
                .hideNavigationBar()
        })
        .onChange(of: passwordresset, perform: { value in
            if value == true {
                dismiss()
            }
        })
//        .fullScreenCover(isPresented: $resetpasswordvm.isPasswordChanged, onDismiss: {
//            print("dismissed ")
//            //            isVerified = true
//            //            self.dismiss()
//        }, content: {
//            CustomSuccessView(action: {
//                dismiss()
////                isVerified = true
//            }, successStep: .constant(.passwordCahnged))
//        })
        
        .showHud(isShowing: $resetpasswordvm.isLoading)
        .showAlert(hasAlert: $resetpasswordvm.isError, alertType: .error( message: "\(resetpasswordvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))

        NavigationLink(destination: destination, isActive: $isPush, label: {})

    }
}

#Preview {
    EnterMobileView()
//        .environmentObject(ResetPasswordVM())
}
