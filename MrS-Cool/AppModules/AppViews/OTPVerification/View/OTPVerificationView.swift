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



struct OTPTextField: View {
    let numberOfFields: Int
    @FocusState private var fieldFocus: Int?
    @State var enterValue: [String]
    @State var oldValue = ""
    @State var isFilled: [Bool] // Array to track filled state for each field

    init(numberOfFields: Int) {
        self.numberOfFields = numberOfFields
        self.enterValue = Array(repeating: "", count: numberOfFields)
        self.isFilled = Array(repeating: false, count: numberOfFields)
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<numberOfFields, id: \.self) { index in
                ZStack(alignment:.bottom) {
                    TextField("", text: $enterValue[index], onEditingChanged: { editing in
                        if editing {
                            oldValue = enterValue[index]
                        }
                    })
                    .keyboardType(.numberPad)
                    .frame(width: 50, height: 50)
                    //                .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
                    .multilineTextAlignment(.center)
                    .focused($fieldFocus, equals: index)
                    .tag(index)
                    .onChange(of: enterValue[index]) { newValue in
                        if !newValue.isEmpty {
                            isFilled[index] = !newValue.isEmpty // Track filled state for this field

                            // Update to new value if there is already an value.
                            if enterValue[index].count > 1 {
                                let currentValue = Array(enterValue[index])
                                
                                // ADD THIS IF YOU DON'T HAVE TO HIDE THE KEYBOARD WHEN THEY ENTERED
                                // THE LAST VALUE.
                                // if oldValue.count == 0 {
                                //    enterValue[index] = String(enterValue[index].suffix(1))
                                //    return
                                // }
                                
                                if currentValue[0] == Character(oldValue) {
                                    enterValue[index] = String(enterValue[index].suffix(1))
                                } else {
                                    enterValue[index] = String(enterValue[index].prefix(1))
                                }
                            }
                            
                            // MARK: - Move to Next
                            if index == numberOfFields-1 {
                                // COMMENT IF YOU DON'T HAVE TO HIDE THE KEYBOARD WHEN THEY ENTERED
                                // THE LAST VALUE.
                                fieldFocus = nil
                                 let finalCode = enterValue.joined()
                                print("Code :",Int(finalCode) ?? 0)
                                
                            } else {
                                fieldFocus = (fieldFocus ?? 0) + 1
                            }
                        } else {
                            isFilled[index] = false
                            // Track filled state for this field
                            // MARK: - Move back
                            fieldFocus = (fieldFocus ?? 0) - 1
                        }
                    }
                    
                    Color(isFilled[index] ? .black : .clear)
                                            .frame(width: 40, height: 2)
                                            .offset(y: isFilled[index] ? -0.5 : 0)
                }
                    .background(RoundedCorners(topLeft: 10.0, topRight: 10.0,
                                               bottomLeft: 10.0,
                                               bottomRight: 10.0)
                            .fill(ColorConstants.Gray51))
                    .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0,
                                            bottomLeft: 10.0, bottomRight: 10.0)
                            .stroke(ColorConstants.Bluegray100,
                                lineWidth: 1))
            }
        }
    }
    
}

#Preview{
    OTPTextField(numberOfFields: 4)
}
