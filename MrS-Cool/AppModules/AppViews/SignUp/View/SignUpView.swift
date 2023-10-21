//
//  SignUpView.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

struct SignUpView: View {

    @State private var selectedUser : UserType = UserType.init()
    
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    
//    @State var isPush = false
//    @State var destination = AnyView(OTPVerificationView())

    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "sign_up",hideImage: false)
            VStack{
                UserTypesList(selectedUser: $selectedUser)
                VStack{
                    TabView(selection:$selectedUser.id){
                        Group{
                            StudentSignUpView()
                            .tag(0)
                            
                            ParentSignUpView()
                            .tag(1)
                            
                            TeacherSignUpView()
                            .tag(2)
                        }
                        .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .padding(.horizontal)
        }
        .background(ColorConstants.Gray50.ignoresSafeArea()
            .onTapGesture {
                hideKeyboard()
            }
        )
        
//        NavigationLink(destination: destination, isActive: $isPush, label: {})

    }
    private func handleSwipe(translation: CGFloat) {
        print("handling swipe! horizontal translation was \(translation)")
    }
}


#Preview {
    SignUpView()
}


struct StudentSignUpView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false

    @State var isPush = false
    @State var destination = AnyView(OTPVerificationView())

    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        SignUpHeaderTitle()
                        
                        // -- inputs --
                        Group {
                            CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $Password,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", text: $phone)
                            
                            CustomDropDownField(iconName:"img_group148",rightIconName:"img_daterange",placeholder: "Birthdate *", text: $phone)
                            CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", text: $phone)
                            CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", text: $phone)
                            CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", text: $phone)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $Password)
                        }
                        .padding([.top])
                        CheckboxField(label: "Accept the Terms and Privacy Policy",
                                      color: ColorConstants.Black900, textSize: 13,
                                      isMarked: $acceptTerms)
                        .padding(.top,15)
                    }.padding(.top,20)
                    Spacer()
                    
                    CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {
                        isPush = true
                        destination = AnyView(OTPVerificationView().hideNavigationBar())
                    })
                        .padding(.top,40)
                    
                    haveAccountView(){
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .frame(minHeight: gr.size.height)
                
            }
            NavigationLink(destination: destination, isActive: $isPush, label: {})

        }

    }
}
#Preview{
    StudentSignUpView()
}


struct ParentSignUpView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        SignUpHeaderTitle()
                        
                        // -- inputs --
                        Group {
                            CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $Password,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", text: $phone)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $Password)
                        }
                        .padding([.top])
                        CheckboxField(label: "Accept the Terms and Privacy Policy",
                                      color: ColorConstants.Black900, textSize: 13,
                                      isMarked: $acceptTerms)
                        .padding(.top,15)
                    }.padding(.top,20)
                    Spacer()
                    
                    CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {
                        
                    })
                        .padding(.top,40)

                    haveAccountView(){
                        presentationMode.wrappedValue.dismiss()
                    }

                }
                .frame(minHeight: gr.size.height)
                
            }
        }
    }
}

#Preview{
    ParentSignUpView()
        .padding(.all)
}


struct TeacherSignUpView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false

    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        SignUpHeaderTitle()
                        
                        // -- inputs --
                        Group {
                            CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $Password,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            
                            //                    CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", text: $phone)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $Password)
                        }
                        .padding([.top])
                        
                        
                        CheckboxField(label: "Accept the Terms and Privacy Policy",
                                      color: ColorConstants.Black900, textSize: 13,
                                      isMarked: $acceptTerms)
                        .padding(.top,15)
                    }.padding(.top,20)
                    Spacer()
                    
                    CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {})
                        .padding(.top,40)

                    haveAccountView(){
                        presentationMode.wrappedValue.dismiss()
                    }

                }
                .frame(minHeight: gr.size.height)
                
            }
        }
        
    }
}

#Preview{
    TeacherSignUpView()
        .padding(.all)
}

struct haveAccountView: View {
    var action:(()->())?
    var body: some View {
        HStack(spacing:5){
            Text("Already have an account ?".localized())
                .foregroundColor(ColorConstants.Gray900)
                .font(Font.SoraRegular(size: 12))
            
            Button(action: {
                action?()
            }, label: {
                Text("sign_in".localized())
            })
            .foregroundColor(ColorConstants.Red400)
            .font(Font.SoraRegular(size: 13))
            
        }
        .frame(minWidth:0,maxWidth:.infinity)
        .multilineTextAlignment(.center)
        .padding(.vertical, 10)
    }
}

struct SignUpHeaderTitle: View {
    var Title:String? = "Personal Information"
    var subTitle:String? = "Enter subtitle here"
    
    var body: some View {
        VStack (alignment: .leading,spacing: 5){
            Text(Title?.localized() ?? "")
                .font(Font.SoraBold(size:18))
                .fontWeight(.bold)
                .foregroundColor(ColorConstants.Black900)
                .multilineTextAlignment(.leading)
            
            Text(subTitle?.localized() ?? "")
                .font(Font.SoraRegular(size: 10.0))
                .fontWeight(.regular)
                .foregroundColor(ColorConstants.Black900)
                .multilineTextAlignment(.leading)
        }
    }
}
