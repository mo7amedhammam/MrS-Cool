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
    @State var isPush = false
    @State var destination = AnyView(Text(""))
    var PhoneNumber : String? 
    var CurrentOTP : Int?
    var secondsCount : Int? = 110
    @Binding var isVerified: Bool

    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "Phone Verification")
            GeometryReader{gr in
                ScrollView(.vertical){
                    VStack{
                        Text("OTP Verification".localized())
                            .font(Font.SoraBold(size: 18.0))
                            .fontWeight(.bold)
                            .foregroundColor(ColorConstants.Bluegray901)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 26.0)
                            .padding(.top,60)
                        Text("An authentication code has been sent to".localized())
                            .font(Font.SoraRegular(size: 13.0))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Bluegray402)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .padding(.top, getRelativeHeight(17.0))
                            .padding(.horizontal, getRelativeWidth(26.0))
                        Text("(+2) \(PhoneNumber ?? "")")
                            .font(Font.SoraRegular(size: 13.0))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Bluegray402)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .padding(.top, getRelativeHeight(7.0))
                            .padding(.horizontal, getRelativeWidth(26.0))
                        
                        Text(otpvm.CurrentOtp ?? "")

                        OTPTextField(numberOfFields: 6,finalOTP: $otpvm.EnteredOtp){
                            print(otpvm.EnteredOtp ?? 99)
//                            otpvm.VerifyOtp()
                        }
                            .padding(.vertical)
                        
                        HStack {
                            Text("I didn't receive code.".localized())
                                .font(Font.SoraRegular(size: 12.0))
                                .fontWeight(.regular)
                                .foregroundColor(ColorConstants.Black900)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                            Button(action: {
                                otpvm.SendOtp()
                            }, label: {
                                Text("Resend Code".localized())
                                    .font(Font.SoraSemiBold(size: 13.0))
                                    .fontWeight(.semibold)
                                    .foregroundColor(ColorConstants.Red400)
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.leading)
                            })
                        }
                        
                        Text("\(otpvm.remainingSeconds ?? "") Sec left")
                            .font(Font.SoraSemiBold(size: 13.0))
                            .fontWeight(.semibold)
                            .foregroundColor(ColorConstants.Bluegray901)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 14.0)
                            .padding(.horizontal, 26.0)
                        
                        Spacer()
                        HStack {
                            Text("Mobile number not correct ?".localized())
                                .font(Font.SoraRegular(size: 12.0))
                                .fontWeight(.regular)
                                .foregroundColor(ColorConstants.Black900)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                            Button(action: {
                                
                            }, label:{
                                Text("Modify Now".localized())
                                    .font(Font.SoraSemiBold(size: 13.0))
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
            NavigationLink(destination: destination, isActive: $isPush, label: {})
        }
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .showHud(isShowing: $otpvm.isLoading)
        .showAlert(hasAlert: $otpvm.isError, alertType: .error( message: "\(otpvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))

        .onAppear(perform: {
            if secondsCount ?? 0 > 0 && CurrentOTP ?? 0 > 0{
                otpvm.remainingSeconds = String(secondsCount ?? 0)
                otpvm.CurrentOtp = String(CurrentOTP ?? 0)
            }
            otpvm.mobile = PhoneNumber
        })
        .onChange(of: otpvm.isOTPVerified, perform: { value in
            if value {
                self.isVerified = value
                self.dismiss()
            }
        })

    }
}

#Preview {
    OTPVerificationView(PhoneNumber: "01101201322", CurrentOTP: 0, secondsCount: 110,isVerified: .constant(false))
}
