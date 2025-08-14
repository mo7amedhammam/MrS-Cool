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
    var iconColor : Color?
    
    var placeholder : String
    var placeholderColor : Color? = ColorConstants.Bluegray402
    
    @Binding var text: String
    var textContentType : UITextContentType? = .name
    var keyboardType : UIKeyboardType? = .default
    var Disabled : Bool?
    var isvalid : Bool? = true
    var isdimmed : Bool? = false

    @State private var isSecured: Bool = true
    @FocusState private var focusedField : Bool
    var body: some View {
        //        ZStack {
        HStack(spacing:0){
            if iconName != "" || iconName != nil{
                Image(fieldType == .Password ?  "img_group_512364":iconName ?? "")
//                    .renderingMode( iconColor != nil ? .template:.original)
                    .renderingMode(.template)
                    .foregroundColor(iconColor ?? ColorConstants.MainColor)
                    .font(.system(size: 15))
                    .padding(.horizontal,10)
            }else{
            }
            ZStack (alignment:.leading){
                Text(placeholder.localized())
                    .font(Font.regular(size: 12))
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
                .font(Font.regular(size: 14))
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
            .stroke(isvalid ?? true ? ColorConstants.Bluegray30066:ColorConstants.Red400,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0)
            .fill(isdimmed ?? false ?  ColorConstants.Bluegray30066.opacity(0.5): ColorConstants.WhiteA700))
        .onTapGesture {
            //            DispatchQueue.main.async(execute: {
            focusedField = true
            //            })
        }
    }
}

#Preview {
    CustomTextField(fieldType:.Default, iconName:"img_group172", placeholder: "password", text: .constant("mmm"), isvalid: true,isdimmed:true)
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
//                    .font(Font.regular(size: 12))
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
//                .font(Font.regular(size: 14))
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
//    static func == (lhs: DropDownOption, rhs: DropDownOption) -> Bool {
//        return lhs.id == rhs.id
//    }
    var id:Int? = 0
    var Title:String? = ""
    var subTitle:Int? = 0
    var subject:SubjectsByAcademicLevelM? = SubjectsByAcademicLevelM()
    var LessonItem:LessonForListM? = LessonForListM()
    var isSelected: Bool? = false
}

struct CustomDropDownField: View {
    var fieldType : inputfields? = .Default
    var iconName : String? = ""
    var rightIconName : String?
    var iconColor : Color?
    
    var placeholder : String
    var placeholderColor : Color? = ColorConstants.Bluegray402
    
    @Binding var selectedOption: DropDownOption?
    var options: [DropDownOption]
    @State private var isMenuVisible = false
    
    var textContentType : UITextContentType? = .name
    var keyboardType : UIKeyboardType? = .default
    var Disabled : Bool?
    var isdimmed : Bool?
    var isvalid : Bool? = true

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
                        .renderingMode( .template)
                        .foregroundColor(ColorConstants.MainColor)
                        .font(.system(size: 15))
                        .padding(.horizontal,10)
                }else{
                }
                ZStack (alignment:.leading){
                    Text(placeholder.localized())
                        .font(Font.regular(size: 12))
                        .foregroundColor(placeholderColor == .red ?  .red:placeholderColor)
                        .offset(y: selectedOption == nil ? 0 : -20)
                        .scaleEffect(selectedOption == nil ? 1.2 : 0.8, anchor: .leading)
                    
                    var localizedTitle: String {
                            NSLocalizedString(selectedOption?.Title ?? "", comment: "")
                        }
                    TextField("", text:.constant(localizedTitle))
                        .focused($focusedField)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 57.0,alignment: .leading)
                        .disabled(true)
                    
                }
                .animation(.easeInOut(duration: 0.2), value: isSecured)
                .frame( height: 57.0,alignment: .leading)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(Font.regular(size: 14))
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
                        VStack(alignment:.leading,spacing:8){
                            ForEach(options,id:\.self){option in
                                Button(action: {
                                    if selectedOption != option{
                                        selectedOption = option
                                        print("selected option" ,option)
                                    }
                                    withAnimation{
                                        isMenuVisible = false
                                    }
                                }) {
                                    HStack() {
                                        Text(option.Title?.localized() ?? "")
                                            .multilineTextAlignment(.leading)
                                            .lineSpacing(5)
                                        Spacer()
                                    }
                                    .frame(minWidth:0,maxWidth:.infinity)
                                    .frame( minHeight: 35,alignment: .leading)
                                    .font(Font.regular(size: 14))
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
        
        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,bottomRight: 5.0).stroke(isvalid ?? true ? ColorConstants.Bluegray30066:ColorConstants.Red400,lineWidth: 1))
        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0).fill(isdimmed ?? false ?  ColorConstants.Bluegray30066.opacity(0.5):ColorConstants.WhiteA700))
        
        .onTapGesture {
            withAnimation{
                isMenuVisible.toggle()
            }
        }
        .disabled(Disabled ?? false)
        .onChange(of: isdimmed){newval in
            if newval == true{
                isMenuVisible = false
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


struct MultiSelectDropDownField: View {
    var fieldType: inputfields? = .Default
    var iconName: String? = ""
    var rightIconName: String?
    var iconColor: Color?

    var placeholder: String
    var placeholderColor: Color? = ColorConstants.Bluegray402

    @Binding var selectedOptions: [DropDownOption]
    var options: [DropDownOption]
    @State private var isMenuVisible = false

    var textContentType: UITextContentType? = .name
    var keyboardType: UIKeyboardType? = .default
    var Disabled: Bool?
    var isdimmed: Bool?
    var isvalid: Bool? = true

    @State private var isSecured: Bool = true
    @FocusState private var focusedField: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: -15) {
            HStack(spacing: 0) {
                if iconName != "" || iconName != nil {
                    Image(fieldType == .Password ? "img_group_512364" : iconName ?? "")
                        .renderingMode(.template)
                        .foregroundColor(ColorConstants.MainColor)
                        .font(.system(size: 15))
                        .padding(.horizontal, 10)
                }
                ZStack(alignment: .leading) {
                    Text(placeholder.localized())
                        .font(Font.regular(size: 12))
                        .foregroundColor(placeholderColor == .red ? .red : placeholderColor)
                        .offset(y: selectedOptions.isEmpty ? 0 : -20)
                        .scaleEffect(selectedOptions.isEmpty ? 1.2 : 0.8, anchor: .leading)
                    
                    var localizedTitles: String {
                        selectedOptions.map { $0.Title ?? "" }.joined(separator: ", ")
                    }

                    TextField("", text: .constant(localizedTitles))
                        .focused($focusedField)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 57.0, alignment: .leading)
                        .disabled(true)
                }
                .animation(.easeInOut(duration: 0.2), value: isSecured)
                .frame(height: 57.0, alignment: .leading)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(Font.regular(size: 14))
                .foregroundColor(ColorConstants.Black900)

                Image(rightIconName ?? "\(isMenuVisible ? "img_arrowup" : "img_arrowdown")")
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(iconColor == .clear ? .clear : iconColor)
                    .font(.system(size: 15))
                    .padding(.horizontal, 10)
            }

            if isMenuVisible && !options.isEmpty {
                GeometryReader { gr in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Button(action: {
                                if selectedOptions.count == options.count {
                                    selectedOptions.removeAll()
                                } else {
                                    selectedOptions = options
                                }
                                print("selected options", selectedOptions)
                            }) {
                                HStack {
                                    Text(selectedOptions.count == options.count ? "Deselect All".localized() : "Select All".localized())
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    if selectedOptions.count == options.count {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(minHeight: 35, alignment: .leading)
                                .font(Font.regular(size: 14))
                                .foregroundColor(ColorConstants.Black900)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            }
                                                        
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    if selectedOptions.contains(option) {
                                        selectedOptions.removeAll { $0 == option }
                                    } else {
                                        selectedOptions.append(option)
                                    }
                                    print("selected options", selectedOptions)
                                }) {
                                    HStack {
                                        Text(option.Title?.localized() ?? "")
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        if selectedOptions.contains(option) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(minHeight: 35, alignment: .leading)
                                    .font(Font.regular(size: 14))
                                    .foregroundColor(ColorConstants.Black900)
                                    .padding(.horizontal)
                                    .padding(.bottom, 5)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(width: gr.size.width)
                    }
                }
            }
        }
        .frame(height: withAnimation { isMenuVisible ? ((options.count + 1) * 35 > 235 ? 235 : CGFloat(options.count > 0 ? options.count + 1 : options.count) * 35) + 57 : 57 })
        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0).stroke(isvalid ?? true ? ColorConstants.Bluegray30066 : ColorConstants.Red400, lineWidth: 1))
        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0).fill(isdimmed ?? false ? ColorConstants.Bluegray30066.opacity(0.5) : ColorConstants.WhiteA700))
        .onTapGesture {
            withAnimation {
                isMenuVisible.toggle()
            }
        }
        .disabled(Disabled ?? false)
        .onChange(of: isdimmed) { newval in
            if newval == true {
                isMenuVisible = false
            }
        }
    }
}

#Preview {
    MultiSelectDropDownField(
        fieldType: .Default,
        iconName: "img_group172",
        placeholder: "Select Options",
        selectedOptions: .constant([]),
        options: [
            DropDownOption(id: 1, Title: "Option 1", subject: nil)
//             , DropDownOption(id: 2, Title: "Option 2", subject: nil)
//            ,DropDownOption(id: 3, Title: "Option 3", subject: nil)
        ]
    )
}




struct CustomTextEditor: View {
    var iconName : String? = ""
    var iconColor : Color? = .clear
    
    var placeholder : String
    var insidePlaceholder : String? = "Tell us about yourself"
    var placeholderColor : Color? = ColorConstants.Bluegray402
    
    @Binding var text: String
    var charLimit: Int

    var textContentType : UITextContentType? = .name
    var keyboardType : UIKeyboardType? = .default
    var isvalid : Bool? = true
    @FocusState private var focusedField : Bool
    var body: some View {
        VStack (spacing:0){
                    HStack(spacing:10){
                        if iconName != "" || iconName != nil{
                            Image(iconName ?? "")
                                .renderingMode( iconColor != .clear ? .template:.original)
                                .foregroundColor(iconColor == .clear ? .clear:iconColor)
                                .font(.system(size: 15))
                        }
                        
                        HStack{
                            Text(placeholder.localized())
                                .font(Font.regular(size: 12))
                                .foregroundColor(placeholderColor == .red ?  .red:placeholderColor)
                                .scaleEffect(1.2, anchor: .leading)
                            
                            Spacer()
                            Text("\(text.count) / \(charLimit)")
                                .font(Font.regular(size: 12))
                                .foregroundColor(placeholderColor == .red ?  .red:placeholderColor)
                            
                        }
                        .frame(height: 57.0,alignment: .leading)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(Font.regular(size: 14))
                        .foregroundColor(ColorConstants.Black900)
                        
                    }
            
                    ZStack(alignment: .topLeading) {
                        if text.isEmpty {
                            Text("\(insidePlaceholder ?? "")".localized())
                                .disabled(true)
                                .font(.regular(size: 12))
                                .foregroundColor(.gray)
                                .padding(.top,8)
                        }
                        
                        TextEditor(text: $text)
                            .focused($focusedField)
                            .font(.regular(size: 14))
                            .opacity(text.isEmpty ? 0.25 : 1)
                            .foregroundColor(ColorConstants.Black900)
                            .onChange(of: text) { newText in
                                // Limit the text length to charLimit
                                text = newText.CharCountLimit(limit: charLimit)
                            }
                    }
                        .padding([.horizontal,.bottom],8)
                        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,bottomRight: 5.0)
                            .stroke(ColorConstants.Bluegray30066,
                                    lineWidth: 1))
                        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0)
                            .fill(ColorConstants.WhiteA700))
        }
                     
        .frame( height: 160, alignment: .center)
        .padding([.horizontal,.bottom],12)
        .disableAutocorrection(true)
        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0)
            .stroke(isvalid ?? true ? ColorConstants.Bluegray30066:ColorConstants.Red400,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0)
            .fill(ColorConstants.WhiteA700))
        .onTapGesture {
            focusedField = true
        }
    }
}

#Preview {
    CustomTextEditor(iconName:"img_group172", placeholder: "Teacher BIO *", text: .constant("gooo"), charLimit: 1000)
}

//struct CustomDatePickerField: View {
//    var fieldType: inputfields? = .Default
//    var iconName: String? = ""
//    var rightIconName: String?
//    var iconColor: Color?
//
//    var placeholder: String
//    var placeholderColor: Color? = ColorConstants.Bluegray402
//
//    @State private var selectedDate: Date? = nil
//    @Binding var selectedDateStr: String?
//    var startDate: Date? = nil
//    var endDate: Date? = nil
////    var timeZone:TimeZone? = .init(identifier: "GMT")
////    var timeZone:TimeZone? = TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current ] \\ok
//    var timeZone:TimeZone? = appTimeZone
//    var local:SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english : .arabic
//
//    @State private var isCalenderVisible = false
//    var datePickerComponent: DatePickerComponents = .date
//    var Disabled : Bool?
//    var isdimmed : Bool?
//    var isvalid: Bool? = true
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: -15) {
//            Button(action: {
//                isCalenderVisible.toggle()
//            }, label: {
//                HStack(spacing: 0) {
//                    if iconName != "" || iconName != nil {
//                        Image(iconName ?? "img_group148")
//                            .renderingMode(.template)
//                            .foregroundColor(ColorConstants.MainColor)
//                            .font(.system(size: 15))
//                            .padding(.horizontal, 10)
//                    }
//                    HStack() {
//                        ZStack(alignment: .leading) {
//                            Text(placeholder.localized())
//                                .font(Font.regular(size: 12))
//                                .foregroundColor(placeholderColor == .red ? .red : placeholderColor)
//                                .offset(y: selectedDateStr == nil ? 0 : -20)
//                                .scaleEffect(selectedDateStr == nil ? 1.2 : 0.8, anchor: .leading)
//
//                            TextField("", text: .constant(selectedDateStr ?? ""))
//                                .multilineTextAlignment(.leading)
//                                .frame(minHeight: 57.0, alignment: .leading)
//                                .disabled(true)
//                        }
//                        .frame(height: 57.0, alignment: .leading)
//                        .font(Font.regular(size: 14))
//                        .foregroundColor(ColorConstants.Black900)
//
//                        Spacer()
//                    }
//                    .frame(minWidth: 0, maxWidth: .infinity)
//
//                    if rightIconName?.count ?? 0 > 0 || rightIconName != nil {
//                        Image(rightIconName ?? "img_daterange")
//                            .renderingMode(.template)
//                            .frame(width: 30, height: 30, alignment: .center)
//                            .foregroundColor(ColorConstants.MainColor)
//                            .font(.system(size: 15))
//                            .padding(.horizontal, 10)
//                    }
//                }
//            })
//
//            if isCalenderVisible {
//                DatePicker(
//                    "birthDate",
////                    selection: Binding(
////                        get: { selectedDate ?? Date() },
////                        set: { newDate in
//////                            print("newDate",newDate)
////                            selectedDate = newDate
//////                            updateSelectedDateStr(with: newDate)
////                            
////                            print("newDate raw:", newDate.formatDate(format:datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a" ))//"yyyy-MM-dd'T'HH:mm:ss'Z'")) // Always UTC internally
////
////                              // Local display
////                              let localFormatter = DateFormatter.cachedFormatter
////                              localFormatter.dateFormat = datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a"// "dd MMM yyyy"
////                              localFormatter.timeZone = appTimeZone
////                              selectedDateStr = localFormatter.string(from: newDate)
////
////                              // UTC for API
////                              let utcFormatter = DateFormatter.cachedFormatter
////                              utcFormatter.dateFormat = datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a" // "yyyy-MM-dd'T'HH:mm:ss'Z'"
//////                              utcFormatter.timeZone = TimeZone(secondsFromGMT: 0)
////                                utcFormatter.timeZone = appTimeZone
////                              let apiDate = utcFormatter.string(from: newDate)
////
////                              print("Selected date (local):", selectedDateStr ?? "")
////                              print("API startDate (UTC):", apiDate)
////                            
////                        }
////                    )
//                    selection: Binding(
//                        get: { selectedDate ?? Date() },
//                        set: { newDate in
//                            selectedDate = newDate
//                            // Only format for display here
//                            let formatter = DateFormatter.cachedFormatter
//                            formatter.dateFormat = datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a"
//                            formatter.timeZone = appTimeZone
//                            selectedDateStr = formatter.string(from: newDate)
//                        }
//                    )
//                    ,
//                    in: (startDate ?? Date.distantPast)...(endDate ?? Date.distantFuture),
//                    displayedComponents: datePickerComponent
//                )
//                .padding(.horizontal)
//                .tint(ColorConstants.MainColor)
//                .labelsHidden()
//                .conditionalDatePickerStyle(datePickerComponent: datePickerComponent)
////                .onAppear {
//////                    print("selectedDate",selectedDate)
//////                    print("selectedDateStr",selectedDateStr)
//////                    print("startDate",startDate)
//////                    print("endDate",endDate)
////                    
////                    // Ensure selectedDateStr is initialized correctly on appear
////                    if let selectedDateStr = selectedDateStr, !selectedDateStr.isEmpty {
////                        selectedDate = selectedDateStr.toDate(withFormat: datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a",inputTimeZone:timeZone,inputLocal:local)
////                    }else{
////
////                        if startDate == nil {
////                            print("Date",Date())
////                            selectedDate = Date()
////                            selectedDateStr = Date().formatDate(format: datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a")
////                        }else{
//////                            print("startDate",startDate)
////                            selectedDate = startDate
////                        }
////                    }
////                    
////                    if let startdate = startDate, selectedDateStr == nil {
////                        selectedDateStr = startdate.formatDate(format: datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a")
////                    }else{
////                    
////                      if let startdate = startDate,let seldate = selectedDate, startdate > seldate{
////                          selectedDate = startdate
////                        selectedDateStr = startdate.formatDate(format: datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a")
////                      }
////                    }
////                }
////                .onAppear {
////                    if selectedDate == nil {
////                        if let startDate = startDate {
////                            selectedDate = startDate
////                        } else {
////                            selectedDate = Date()
////                        }
////                    }
////                }
//                .onAppear {
//                    if selectedDate == nil {
//                        selectedDate = startDate ?? Date()
//                    }
//                    // Always refresh string based on current timezone
//                    updateDisplayString()
//                }
//                .onChange(of: appTimeZone) { _ in
//                    updateDisplayString()
//                }
//                .onChange(of: selectedDate) { _ in
//                    updateDisplayString()
//                }
//                
////                .onDisappear{
////                    print("selectedDate",selectedDate)
//////                    print("selectedDateStr",selectedDateStr)
////                    print("startDate",startDate)
////                    print("endDate",endDate)
////
////                }
//            }
//        }
//        .disabled(Disabled == true ? true:false)
//        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0).stroke(isvalid ?? true ? ColorConstants.Bluegray30066 : ColorConstants.Red400, lineWidth: 1))
//        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0).fill(Disabled == true ? ColorConstants.Bluegray30066.opacity(0.6) : ColorConstants.WhiteA700))
//    }
//    private func updateDisplayString() {
//        guard let date = selectedDate else { return }
//        let formatter = DateFormatter.cachedFormatter
//        formatter.dateFormat = datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a"
//        formatter.timeZone = appTimeZone
//        selectedDateStr = formatter.string(from: date)
//    }
//    // Function to update the selected date string and print the date
////    private func updateSelectedDateStr(with date: Date) {
////        selectedDateStr = date.formatDate(format: datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a",inputLocal: local)
////        print("Selected date: \(selectedDateStr ?? "")")
////    }
//}

struct CustomDatePickerField: View {
    var fieldType: inputfields? = .Default
    var iconName: String? = ""
    var rightIconName: String?
    var iconColor: Color?

    var placeholder: String
    var placeholderColor: Color? = ColorConstants.Bluegray402

    @State private var selectedDate: Date? = nil
    @Binding var selectedDateStr: String?
    var startDate: Date? = nil
    var endDate: Date? = nil
    var timeZone: TimeZone? = appTimeZone
    var local: SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english : .arabic

    @State private var isCalenderVisible = false
    var datePickerComponent: DatePickerComponents = .date
    var Disabled: Bool?
    var isdimmed: Bool?
    var isvalid: Bool? = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: -15) {
            Button(action: {
                isCalenderVisible.toggle()
            }, label: {
                HStack(spacing: 0) {
                    if iconName != "" || iconName != nil {
                        Image(iconName ?? "img_group148")
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor)
                            .font(.system(size: 15))
                            .padding(.horizontal, 10)
                    }
                    HStack() {
                        ZStack(alignment: .leading) {
                            Text(placeholder.localized())
                                .font(Font.regular(size: 12))
                                .foregroundColor(placeholderColor == .red ? .red : placeholderColor)
                                .offset(y: selectedDateStr == nil ? 0 : -20)
                                .scaleEffect(selectedDateStr == nil ? 1.2 : 0.8, anchor: .leading)

                            TextField("", text: .constant(selectedDateStr ?? ""))
                                .multilineTextAlignment(.leading)
                                .frame(minHeight: 57.0, alignment: .leading)
                                .disabled(true)
                        }
                        .frame(height: 57.0, alignment: .leading)
                        .font(Font.regular(size: 14))
                        .foregroundColor(ColorConstants.Black900)

                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)

                    if rightIconName?.count ?? 0 > 0 || rightIconName != nil {
                        Image(rightIconName ?? "img_daterange")
                            .renderingMode(.template)
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(ColorConstants.MainColor)
                            .font(.system(size: 15))
                            .padding(.horizontal, 10)
                    }
                }
            })

            if isCalenderVisible {
                DatePicker(
                    "birthDate",
                    selection: Binding(
                        get: { selectedDate ?? Date() },
                        set: { newDate in
                            selectedDate = newDate
                            updateSelectedDateString(from: newDate)
                        }
                    ),
                    in: (startDate ?? Date.distantPast)...(endDate ?? Date.distantFuture),
                    displayedComponents: datePickerComponent
                )
                .padding(.horizontal)
                .tint(ColorConstants.MainColor)
                .labelsHidden()
                .conditionalDatePickerStyle(datePickerComponent: datePickerComponent)
                .environment(\.timeZone, timeZone ?? TimeZone.current) // Ensure consistent timezone
                .onAppear {
                    initializeSelectedDate()
                }
            }
        }
        .disabled(Disabled == true ? true : false)
        .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0).stroke(isvalid ?? true ? ColorConstants.Bluegray30066 : ColorConstants.Red400, lineWidth: 1))
        .background(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0, bottomRight: 5.0).fill(Disabled == true ? ColorConstants.Bluegray30066.opacity(0.6) : ColorConstants.WhiteA700))
    }
    
    // MARK: - Helper Methods
    
    private func updateSelectedDateString(from date: Date) {
        let formatter = createFormatter()
        selectedDateStr = formatter.string(from: date)
        
        print("Selected date raw:", date)
        print("Selected date formatted:", selectedDateStr ?? "")
        print("Formatter timezone:", formatter.timeZone?.identifier ?? "Unknown")
    }
    
    private func initializeSelectedDate() {
        // If we already have a string value, parse it back to a date
        if let dateString = selectedDateStr, !dateString.isEmpty {
            selectedDate = parseDateString(dateString)
        } else if let startDate = startDate {
            // Use start date as default if no value is set
            selectedDate = startDate
            updateSelectedDateString(from: startDate)
        } else {
            // Default to current date
            selectedDate = Date()
            updateSelectedDateString(from: Date())
        }
        
        // Ensure selected date is within bounds
        if let start = startDate, let selected = selectedDate, selected < start {
            selectedDate = start
            updateSelectedDateString(from: start)
        }
        
        if let end = endDate, let selected = selectedDate, selected > end {
            selectedDate = end
            updateSelectedDateString(from: end)
        }
    }
    
    private func createFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = datePickerComponent == .date ? "dd MMM yyyy" : "hh:mm a"
        formatter.timeZone = timeZone ?? TimeZone.current
        formatter.locale = local?.locale ?? Locale.current
        return formatter
    }
    
    private func parseDateString(_ dateString: String) -> Date? {
        let formatter = createFormatter()
        return formatter.date(from: dateString)
    }
}



#Preview {
    CustomDatePickerField(fieldType:.Default, iconName:"img_group148", placeholder: "Birthdate", selectedDateStr: .constant(""),datePickerComponent:.date)
}

import FSCalendar

struct FSCalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date
    var startDate: Date?
    var endDate: Date?
    
    class Coordinator: NSObject, FSCalendarDelegate ,FSCalendarDataSource{
        var parent: FSCalendarView
        
        init(parent: FSCalendarView) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        func minimumDate(for calendar: FSCalendar) -> Date {
                 return parent.startDate ?? Date.distantPast
             }

             func maximumDate(for calendar: FSCalendar) -> Date {
                 return parent.endDate ?? Date.distantFuture
             }

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 20)
        calendar.appearance.todayColor = UIColor.init(ColorConstants.MainColor).withAlphaComponent(0.6)
//        calendar.appearance.titleTodayColor = UIColor.init(ColorConstants.MainColor).withAlphaComponent(0.4)

        calendar.appearance.selectionColor = UIColor.init(ColorConstants.MainColor)
        // Adjust the color as needed
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // Optional: Customize FSCalendar appearance here
//        uiView.dataSource = context.coordinator
//        uiView.delegate = context.coordinator
        uiView.select(selectedDate)
        uiView.reloadData()
    }
}



struct ConditionalDatePickerStyle: ViewModifier {
    var datePickerComponent: DatePickerComponents
    
    func body(content: Content) -> some View {
        if datePickerComponent == .hourAndMinute {
            return AnyView(content.datePickerStyle(WheelDatePickerStyle()))
        } else {
            return AnyView(content.datePickerStyle(GraphicalDatePickerStyle()))
        }
    }
}

// --- View Extension to apply the modifier ---
extension View {
    public func conditionalDatePickerStyle(datePickerComponent: DatePickerComponents) -> some View {
        modifier(ConditionalDatePickerStyle(datePickerComponent: datePickerComponent))
    }
}



extension Date{
    func formatDate(format: String, inputLocal: SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english:.arabic, inputTimeZone: TimeZone = appTimeZone, outputLocal: SupportedLocale = LocalizeHelper.shared.currentLanguage == "en" ? .english:.arabic, outputTimeZone: TimeZone = appTimeZone) -> String {
//        let dateFormatter = DateFormatter()
        let dateFormatter = DateFormatter.cachedFormatter

        
        // Set up the input formatter
        dateFormatter.dateFormat = format
        dateFormatter.locale = inputLocal?.locale
        dateFormatter.timeZone = inputTimeZone
        
        // Parse the date with the input locale and time zone
        let dateString = dateFormatter.string(from: self)
        
        // Set up the output formatter
        dateFormatter.locale = outputLocal.locale
        dateFormatter.timeZone = outputTimeZone
        
        // Format the date with the output locale and time zone
        return dateFormatter.string(from: dateFormatter.date(from: dateString) ?? self)
    }
}
