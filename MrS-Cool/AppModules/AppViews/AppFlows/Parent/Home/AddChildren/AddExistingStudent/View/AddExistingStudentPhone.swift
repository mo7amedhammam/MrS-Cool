//
//  AddExistingStudentPhone.swift
//  MrS-Cool
//
//  Created by wecancity on 27/03/2024.
//

import SwiftUI

struct AddExistingStudentPhone: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var verifystudentvm = AddExistingStudentVM()
    var hideImage : Bool? = false
    @State private var isVerified : Bool = false
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
@State var mobileLength : Int = Helper.shared.getAppCountry()?.mobileLength ?? 11
    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "Add Existing Account",hideImage: hideImage)                      

            VStack{
                GeometryReader{gr in
                    ScrollView(.vertical){
                        VStack{
                            VStack(alignment: .leading, spacing: 0) {

                                Group {
                                    Text("Add Existing Student Account".localized())
                                        .foregroundColor(Color.mainBlue)
                                        .font(.bold(size: 18))

                                    CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $verifystudentvm.phone ,textContentType:.telephoneNumber,keyboardType:.numberPad)
                                        .onChange(of: verifystudentvm.phone) { newValue in
                                            if newValue.count > mobileLength {
                                                verifystudentvm.phone = String(newValue.prefix(mobileLength))
                                            }
                                        }

                                    Text("NewStudent_We will send  you otp to your mobile number\nto reset a new password".localized())
                                        .foregroundColor(Color.mainBlue)
                                        .font(.regular(size: 13))
                                        .frame(maxWidth:.infinity,alignment:.center)
                                        .multilineTextAlignment(.center)
                                }
                                .padding([.top])
                                
                            }
                            .padding(.top, 20)
                            Spacer()
                            VStack{
                                CustomButton(Title:"Verify",IsDisabled:.constant(!(verifystudentvm.isPhoneValid)) , action: {
                                //    sendotp for student "student\sendotp"
//                                    resetpasswordvm.SendResetOtp()
                                    verifystudentvm.SendVerifyOtp()
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
        
        .fullScreenCover(isPresented: $verifystudentvm.isOtpReceived, onDismiss: {
            print("dismissed ")
            if isVerified {
////                destination = AnyView(ResetPasswordView().environmentObject(verifystudentvm))
////                    isPush = true
//                dismiss()
                Helper.shared.changeRoot(toView: ParentTabBarView())

            }
        }, content: {
            OTPVerificationView(PhoneNumber:verifystudentvm.phone,CurrentOTP: verifystudentvm.OtpM?.otp ?? 0, ShowOTP: verifystudentvm.OtpM?.showOtp ?? false,verifycase: .addexistingstudent, secondsCount:verifystudentvm.OtpM?.secondsCount ?? 0, isVerified: $isVerified, sussessStep: .constant(.childrenAccountAdded))
                .hideNavigationBar()
        })
        
        .showHud(isShowing: $verifystudentvm.isLoading)
        .showAlert(hasAlert: $verifystudentvm.isError, alertType: .error( message: "\(verifystudentvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))

        NavigationLink(destination: destination, isActive: $isPush, label: {})

    }
}

#Preview {
    AddExistingStudentPhone()
//        .environmentObject(ResetPasswordVM())
}
