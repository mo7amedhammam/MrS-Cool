//
//  OTPVerificationView.swift
//  MrS-Cool
//
//  Created by wecancity on 21/10/2023.
//

import SwiftUI

struct OTPVerificationView: View {
    @State var isPush = false
    @State var destination = AnyView(Text(""))
    var PhoneNumber : String = ""
    var secondsCount : Int = 0
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
                        Text("(+20) 111 222 333")
                            .font(Font.SoraRegular(size: 13.0))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Bluegray402)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .padding(.top, getRelativeHeight(7.0))
                            .padding(.horizontal, getRelativeWidth(26.0))
                        
                        OTPTextField(numberOfFields: 6)
                            .padding(.vertical)
                        
                        HStack {
                            Text("I didn't receive code.".localized())
                                .font(Font.SoraRegular(size: 12.0))
                                .fontWeight(.regular)
                                .foregroundColor(ColorConstants.Black900)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                            Button(action: {
                                
                            }, label: {
                                Text("Resend Code".localized())
                                    .font(Font.SoraSemiBold(size: 13.0))
                                    .fontWeight(.semibold)
                                    .foregroundColor(ColorConstants.Red400)
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.leading)
                            })
                        }
                        
                        Text("1:20 Sec left")
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
    }
}

#Preview {
    OTPVerificationView()
}
