//
//  OTPTextField.swift
//  MrS-Cool
//
//  Created by wecancity on 25/10/2023.
//

import SwiftUI

struct OTPTextField: View {
    let numberOfFields: Int
    @FocusState private var fieldFocus: Int?
    @State var enteredValue: [String]
    @State var oldValue = ""
    @State var isFilled: [Bool] // Array to track filled state for each field

    @Binding var finalOTP: String?

    init(numberOfFields: Int, finalOTP: Binding<String?>) {
        self.numberOfFields = numberOfFields
        self.enteredValue = Array(repeating: "", count: numberOfFields)
        self.isFilled = Array(repeating: false, count: numberOfFields)
        self._finalOTP = finalOTP
    }

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<numberOfFields, id: \.self) { index in
                ZStack(alignment: .bottom) {
                    TextField("", text: $enteredValue[index])
                        .keyboardType(.numberPad)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                        .multilineTextAlignment(.center)
                        .focused($fieldFocus, equals: index)
                        .tag(index)
                        .onChange(of: enteredValue[index]) { newValue in
                            if newValue.count > 1 {
                                enteredValue[index] = String(newValue.prefix(1))
                            }
                            isFilled[index] = !newValue.isEmpty
                            if newValue.isEmpty {
                                if index > 0 {
                                    fieldFocus = index - 1
                                }
                            } else {
                                if index < numberOfFields - 1 {
                                    fieldFocus = index + 1
                                } else {
                                    fieldFocus = nil
                                    let finalCode = enteredValue.joined()
                                    guard finalCode.count == numberOfFields else { return }
                                    finalOTP = finalCode
                                    print("Code:", finalCode)
                                }
                            }
                        }
                    Color(isFilled[index] ? .black : .clear)
                        .frame(width: 40, height: 2)
                        .offset(y: isFilled[index] ? -0.5 : 0)
                }
                .background(
                    RoundedCorners(
                        topLeft: 10.0, topRight: 10.0,
                        bottomLeft: 10.0, bottomRight: 10.0
                    ).fill(ColorConstants.Gray51)
                )
                .overlay(
                    RoundedCorners(
                        topLeft: 10.0, topRight: 10.0,
                        bottomLeft: 10.0, bottomRight: 10.0
                    ).stroke(ColorConstants.Bluegray100, lineWidth: 1)
                )
            }
        }
        .onChange(of: finalOTP, perform: { value in
            if value == nil {
                enteredValue = Array(repeating: "", count: numberOfFields)
                isFilled = Array(repeating: false, count: numberOfFields)
                fieldFocus = nil
            }
        })
        
    }
}

#Preview{
    OTPTextField(numberOfFields: 4, finalOTP: .constant(""))
}
