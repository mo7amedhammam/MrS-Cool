//
//  OTPVerificationView.swift
//  MrS-Cool
//
//  Created by wecancity on 21/10/2023.
//

import SwiftUI

struct OTPVerificationView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var otpvm = OTPVerificationVM()
    //    @State var isPush = false
    //    @State var destination = AnyView(Text(""))
    var PhoneNumber : String?
    var CurrentOTP : Int?
    var verifycase : VerifyCases

    @State var secondsCount : Int? = 110
    @Binding var isVerified: Bool
    @Binding var sussessStep : successSteps

    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "Phone Verification"){
                isVerified = false
                dismiss()
            }
            GeometryReader{gr in
                ScrollView(.vertical){
                    VStack{
                        Text("OTP Verification".localized())
                            .font(Font.bold(size: 18.0))
                            .fontWeight(.bold)
                            .foregroundColor(ColorConstants.Bluegray901)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 26.0)
                            .padding(.top,60)
                        Text("An authentication code has been sent to".localized())
                            .font(Font.regular(size: 13.0))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Bluegray402)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .padding(.top, getRelativeHeight(17.0))
                            .padding(.horizontal, getRelativeWidth(26.0))
                        Text("(+2) \(PhoneNumber ?? "")")
                            .font(Font.regular(size: 13.0))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Bluegray402)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .padding(.top, getRelativeHeight(7.0))
                            .padding(.horizontal, getRelativeWidth(26.0))
                        
//                        Text(otpvm.CurrentOtp ?? "")
                        
                        OTPTextField(numberOfFields: 6,finalOTP: $otpvm.EnteredOtp)
                            .padding(.vertical)
                            .environment(\.layoutDirection,.leftToRight )

                        
                        HStack {
                            Text("I didn't receive code.".localized())
                                .font(Font.regular(size: 12.0))
                                .fontWeight(.regular)
                                .foregroundColor(ColorConstants.Black900)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                            Button(action: {
                                otpvm.SendOtp()
                            }, label: {
                                Text("Resend Code".localized())
                                    .font(Font.semiBold(size: 13.0))
                                    .fontWeight(.semibold)
                                    .foregroundColor(ColorConstants.Red400)
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.leading)
                            })
                            .opacity(otpvm.remainingSeconds > 0 ? 0.4:1.0)
                            .disabled(otpvm.remainingSeconds > 0)
                        }
                        
                        Text("\(otpvm.remainingSeconds.formattedTime() ) Sec left")
                            .font(Font.semiBold(size: 13.0))
                            .fontWeight(.semibold)
                            .foregroundColor(ColorConstants.Bluegray901)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 14.0)
                            .padding(.horizontal, 26.0)
                        
                        Spacer()
                        HStack {
                            Text("Mobile number not correct ?".localized())
                                .font(Font.regular(size: 12.0))
                                .fontWeight(.regular)
                                .foregroundColor(ColorConstants.Black900)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                            Button(action: {
//                                otpvm.isOTPVerified.toggle()
                                isVerified = false
                                dismiss()
                            }, label:{
                                Text("Modify Now".localized())
                                    .font(Font.semiBold(size: 13.0))
                                    .fontWeight(.semibold)
                                    .foregroundColor(ColorConstants.LightGreen800)
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.leading)
                            })
                        }
                    }
                    .frame(minHeight: gr.size.height)
                    .padding(.horizontal)
                }
                .frame(width:UIScreen.main.bounds.width)
            }
        }
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        //        NavigationLink(destination: destination, isActive: $isPush, label: {})
        .showHud(isShowing: $otpvm.isLoading)
        .showAlert(hasAlert: $otpvm.isError, alertType: .error( message: "\(otpvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
        
        .onAppear(perform: {
            otpvm.mobile = PhoneNumber
            otpvm.verifycase = verifycase
            if secondsCount ?? 0 > 0{
                otpvm.CurrentOtp = String(CurrentOTP ?? 0)
                otpvm.remainingSeconds = secondsCount ?? 0
                otpvm.startCountdownTimer(seconds: otpvm.remainingSeconds)
            }
        })
//        .onChange(of: otpvm.remainingSeconds, perform: { value in
//            if value > 0{
//                otpvm.CurrentOtp = String(CurrentOTP ?? 0)
//                otpvm.remainingSeconds = secondsCount ?? 0
//                otpvm.startCountdownTimer(seconds: otpvm.remainingSeconds)
//            }
//        })
        
        .onChange(of: otpvm.isResetOTPVerified, perform: { value in
            guard value == true else {return}
            dismiss()
            isVerified = true
        })
        
        .fullScreenCover(isPresented: $otpvm.isOTPVerified, onDismiss: {
            print("dismissed ")
            //            isVerified = true
            //            self.dismiss()
        }, content: {
            CustomSuccessView(action: {
                dismiss()
                isVerified = true
                
            }, successStep: $sussessStep)
        })
    }
}

#Preview {
    OTPVerificationView(PhoneNumber: "01101201322", CurrentOTP: 0, verifycase: .creatinguser, secondsCount: 110,isVerified: .constant(false), sussessStep: .constant(.teacherRegistered))
}

