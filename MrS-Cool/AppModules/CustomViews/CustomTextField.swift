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
    var placeholderColor : Color? = ColorConstants.Bluegray402
    
    @Binding var text: String
    var textContentType : UITextContentType? = .name
    var keyboardType : UIKeyboardType? = .default
    var Disabled : Bool?
    
    @State private var isSecured: Bool = true
    @FocusState private var focusedField : Bool
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
            ZStack (alignment:.leading){
                Text(placeholder.localized())
                    .font(Font.SoraRegular(size: 12))
                    .foregroundColor(placeholderColor == .red ?  .red:placeholderColor)
                    .offset(y: text.isEmpty ? 0 : -20)
                    .scaleEffect(text.isEmpty ? 1.2 : 0.8, anchor: .leading)
                    .padding(.leading,fieldType == .Phone ? text.isEmpty ? 55:0:0)
                HStack{
                    if fieldType == .Password{
                        if isSecured {
                            SecureField("", text: $text)
                                .focused($focusedField)
                                .textContentType(.password)
                        } else {
                            TextField("", text: $text)
                                .focused($focusedField)
                        }
                    }else{
                        TextField("", text: $text)
                            .focused($focusedField)
                            .frame( minHeight: 57.0,
                                    alignment: .leading)
                            .keyboardType(keyboardType ?? .default)
                            .textContentType(textContentType)
                        //                            .background(.red)
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
        .disableAutocorrection(true)
        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,
                                bottomRight: 5.0)
            .stroke(ColorConstants.Bluegray30066,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,
                                   bottomRight: 5.0)
            .fill(ColorConstants.WhiteA700))
        .onTapGesture {
            //            DispatchQueue.main.async(execute: {
            focusedField = true
            //            })
        }
    }
}

#Preview {
    CustomTextField(fieldType:.Default, iconName:"img_group172", placeholder: "password", text: .constant("mmm"))
}


//struct CustomDropDownField: View {
//    var fieldType : inputfields? = .Default
//    var iconName : String? = ""
//    var rightIconName : String?
//    var iconColor : Color? = .clear
//
//    var placeholder : String
//    var placeholderColor : Color? = ColorConstants.Bluegray100
//
//    @Binding var text: String
//    var textContentType : UITextContentType? = .name
//    var keyboardType : UIKeyboardType? = .default
//    var Disabled : Bool?
//    
//    @State private var isSecured: Bool = true
//    @FocusState private var focusedField : Bool
//    var body: some View {
////        ZStack {
//        HStack(spacing:0){
//            if iconName != "" || iconName != nil{
//                Image(fieldType == .Password ?  "img_group_512364":iconName ?? "")
//                    .renderingMode( iconColor != .clear ? .template:.original)
//                    .foregroundColor(iconColor == .clear ? .clear:iconColor)
//                    .font(.system(size: 15))
//                    .padding(.horizontal,10)
//            }else{
//            }
//            
////            Button(action: {
////                // Activate the text field when the entire view is tapped
////                focusedField = true
////
////            }, label: {
//            ZStack (alignment:.leading){
//                Text(placeholder.localized())
//                    .font(Font.SoraRegular(size: 12))
//                    .foregroundColor(placeholderColor == .red ?  .red:placeholderColor)
//                    .offset(y: text.isEmpty ? 0 : -20)
//                    .scaleEffect(text.isEmpty ? 1 : 0.8, anchor: .leading)
//                    .padding(.leading,fieldType == .Phone ? text.isEmpty ? 55:0:0)
//
//                        TextField("", text: $text)
//                            .focused($focusedField)
//                            .frame( minHeight: 57.0,
//                                    alignment: .leading)
//                            .keyboardType(keyboardType ?? .default)
//                            .textContentType(textContentType)
////                            .background(.red)
//                            .disabled(true)
//                    
//                }
//                .animation(.easeInOut(duration: 0.2), value: isSecured)
//                .frame( height: 57.0,
//                        alignment: .leading)
//                .frame(minWidth: 0, maxWidth: .infinity)
//                .font(Font.SoraRegular(size: 14))
//                .disabled(Disabled ?? false)
//                .foregroundColor(ColorConstants.Black900)
//                .autocapitalization(.none)
//                .textInputAutocapitalization(.never)
//            
//            
//                Image(rightIconName ?? "img_arrowdown")
//                .frame(width: 30, height: 30, alignment: .center)
////                    .renderingMode( iconColor != .clear ? .template:.original)
//                    .foregroundColor(iconColor == .clear ? .clear:iconColor)
//                    .font(.system(size: 15))
//                    .padding(.horizontal,10)
//            }
//
//        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,
//                                bottomRight: 5.0)
//                .stroke(ColorConstants.Bluegray30066,
//                        lineWidth: 1))
//        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,
//                                   bottomRight: 5.0)
//                .fill(ColorConstants.WhiteA700))
//    }
//}
//
//#Preview {
//    CustomDropDownField(fieldType:.Default, iconName:"img_group172",rightIconName:"img_daterange", placeholder: "password", text: .constant("mmm"))
//}



struct DropDownOption:Hashable{
    var id:Int? = 0
    var Title:String? = ""
}

struct CustomDropDownField: View {
    var fieldType : inputfields? = .Default
    var iconName : String? = ""
    var rightIconName : String?
    var iconColor : Color? = .clear
    
    var placeholder : String
    var placeholderColor : Color? = ColorConstants.Bluegray402
    
    @Binding var selectedOption: DropDownOption?
    var options: [DropDownOption]
    @State private var isMenuVisible = false
    
    var textContentType : UITextContentType? = .name
    var keyboardType : UIKeyboardType? = .default
    var Disabled : Bool?
    
    @State private var isSecured: Bool = true
    @FocusState private var focusedField : Bool
    var body: some View {
        //        ZStack {
        //        Menu {
        //            ForEach(options, id: \.self) { option in
        //                Button(action: {
        //                    selectedOption = option
        ////                    isMenuVisible = false
        //                }) {
        //                    Text(option)
        //                }
        //            }
        //        } label: {
        
        
        VStack(alignment:.leading,spacing:-15){
            HStack(spacing:0){
                if iconName != "" || iconName != nil{
                    Image(fieldType == .Password ?  "img_group_512364":iconName ?? "")
                        .renderingMode( iconColor != .clear ? .template:.original)
                        .foregroundColor(iconColor == .clear ? .clear:iconColor)
                        .font(.system(size: 15))
                        .padding(.horizontal,10)
                }else{
                }
                ZStack (alignment:.leading){
                    Text(placeholder.localized())
                        .font(Font.SoraRegular(size: 12))
                        .foregroundColor(placeholderColor == .red ?  .red:placeholderColor)
                        .offset(y: selectedOption == nil ? 0 : -20)
                        .scaleEffect(selectedOption == nil ? 1.2 : 0.8, anchor: .leading)
                    
                    TextField("", text:.constant( selectedOption?.Title ?? "") )
                        .focused($focusedField)
                        .multilineTextAlignment(.leading)
                        .frame( minHeight: 57.0,alignment: .leading)
                        .disabled(true)
                    
                }
                .animation(.easeInOut(duration: 0.2), value: isSecured)
                .frame( height: 57.0,alignment: .leading)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(Font.SoraRegular(size: 14))
                .foregroundColor(ColorConstants.Black900)
                
                Image(rightIconName ?? "\(isMenuVisible ? "img_arrowup":"img_arrowdown")")
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(iconColor == .clear ? .clear:iconColor)
                    .font(.system(size: 15))
                    .padding(.horizontal,10)
            }
            
            if isMenuVisible && !options.isEmpty{
                GeometryReader { gr in
                    ScrollView(.vertical,showsIndicators: false){
                        VStack(alignment:.leading,spacing:0){
                            ForEach(options,id:\.self){option in
                                Button(action: {
                                    selectedOption = option
                                    withAnimation{
                                        isMenuVisible = false
                                    }
                                    print("selected option" ,option)
                                }) {
                                    HStack() {
                                        Text(option.Title ?? "")
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .frame(minWidth:0,maxWidth:.infinity)
                                    .frame( minHeight: 35,alignment: .leading)
                                    .font(Font.SoraRegular(size: 14))
                                    .foregroundColor(ColorConstants.Black900)
                                    .padding(.horizontal)
                                    .padding(.bottom,5)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(width:gr.size.width)
                    }
                }
            }
        }
        .frame(height:withAnimation{isMenuVisible ? (options.count*35 > 200 ? 200:CGFloat(options.count)*35) + 57:57})
        
        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,bottomRight: 5.0).stroke(ColorConstants.Bluegray30066,lineWidth: 1))
        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0).fill(ColorConstants.WhiteA700))
        
        .onTapGesture {
            withAnimation{
                isMenuVisible.toggle()
            }
        }
        //        }
        //        .menuStyle(BorderlessButtonMenuStyle()) // Use BorderlessButtonMenuStyle for a clean appearance
        
        //            .overlay(alignment:.top){
        //                if isMenuVisible{
        //                    VStack(spacing:0){
        //                        Spacer(minLength: 60)
        //                        List(options,id:\.self){option in
        //                            Button(action: {
        //                                selectedOption = option
        //                                isMenuVisible = false
        //                                print(option)
        //                            }) {
        //                                Text(option)
        ////                                    .frame(height:20)
        //                            }
        //                            .buttonStyle(.plain)
        //                            .listRowSeparator(.hidden)
        //                            .listRowSpacing(-15)
        //                        }
        //                        .listStyle(.plain)
        //                        .frame( height: options.count*35 >= 200 ? 200:CGFloat(options.count)*35)
        //                        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,bottomRight: 5.0).stroke(ColorConstants.Bluegray30066,lineWidth: 1))
        //
        ////                        .padding(.leading)
        //                    }
        //                }
        //            }
        
    }
}

#Preview {
    
    CustomDropDownField(fieldType:.Default, iconName:"img_group172", placeholder: "password", selectedOption: .constant(DropDownOption()), options: [DropDownOption(id: 1, Title: "Male"),DropDownOption(id: 2, Title: "FeMale")])
}

