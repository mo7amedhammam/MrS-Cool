//
//  CustomTextField.swift
//  MrS-Cool
//
//  Created by wecancity on 18/10/2023.
//

import SwiftUI
enum inputfields {
    case Phone,number, Default, Password
}

struct CustomTextField: View {
    var fieldType : inputfields? = .Default
    var iconName : String? = ""
    var iconColor : Color? = .clear

    var placeholder : String
    var placeholderColor : Color? = ColorConstants.Bluegray100

    @Binding var text: String
    var textContentType : UITextContentType? = .name
    var keyboardType : UIKeyboardType? = .default
    var Disabled : Bool?
    
    @State private var isSecured: Bool = true
    @State private var isEditing: Bool = false

    var body: some View {
//        ZStack {
        HStack(spacing:0){
                if iconName != "" || iconName != nil{
                    Image(fieldType == .Password ?  "img_group_512364":iconName ?? "")
                        .renderingMode( iconColor != .clear ? .template:.original)
                        .foregroundColor(iconColor == .clear ? .clear:iconColor)
                        .font(.system(size: 15))
                        .padding(.horizontal,10)
                }else{
                }
                
//                Button(action: {
//                    // Activate the text field when the entire view is tapped
//                }, label: {
                ZStack (alignment:.leading){
                    Text(placeholder.localized())
                        .font(Font.SoraRegular(size: 12))
                        .foregroundColor(placeholderColor == .red ?  .red:placeholderColor)
                        .offset(y: text.isEmpty ? 0 : -20)
                        .scaleEffect(text.isEmpty ? 1 : 0.8, anchor: .leading)
                        .padding(.leading,fieldType == .Phone ? text.isEmpty ? 55:0:0)
                    HStack{
//                        if fieldType == .Phone{
//                            Text("+2 |")
//                                .font(Font.SoraSemiBold(size: getRelativeHeight(12.0)))
//                            .foregroundColor(.gray.opacity(0.5))
//                        }
//                    Group{
                        if fieldType == .Password{
                            if isSecured {
                            SecureField("", text: $text)
                                    .textContentType(.password)
                            } else {
                                TextField("", text: $text)
                            }
                        }else{
                            TextField("", text: $text)
                                .frame( minHeight: 57.0,
                                        alignment: .leading)
                            .keyboardType(keyboardType ?? .default)
                            .textContentType(textContentType)
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: isSecured)
                            .frame( height: 57.0,
                                    alignment: .leading)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .font(Font.SoraRegular(size: 14))
                            .disabled(Disabled ?? false)
                            .foregroundColor(ColorConstants.Black900)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)
                }
                    
                if fieldType == .Password{
                    Button(action: {
                        isSecured.toggle()
                    }, label: {

                    Image(isSecured ? "img_group218":"img_group8733_gray_908")
                        .renderingMode( iconColor != .clear ? .template:.original)
//                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(iconColor == .clear ? .clear:iconColor)
                        .font(.system(size: 15))
                        .padding(.horizontal,10)
                    })
                }else{
                }
            }
        .onTapGesture {
            isEditing = true
        }

            .disableAutocorrection(true)
        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,
                                bottomRight: 5.0)
                .stroke(ColorConstants.Bluegray30066,
                        lineWidth: 1))
        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,
                                   bottomRight: 5.0)
                .fill(ColorConstants.WhiteA700))
        
        .onAppear {
             UITextView.appearance().keyboardAppearance = .default
         }
         .onDisappear {
             UITextView.appearance().keyboardAppearance = .dark
         }
//         .introspectTextField { textField in
//             textField.becomeFirstResponder()
//         }
    }
}

#Preview {
    CustomTextField(fieldType:.Default, iconName:"img_group172", placeholder: "password", text: .constant("mmm"))
}

