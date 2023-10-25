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
                    .foregroundColor(.black)
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
