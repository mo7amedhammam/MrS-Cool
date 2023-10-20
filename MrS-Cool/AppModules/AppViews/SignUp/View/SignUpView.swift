//
//  SignUpView.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedUser : UserType = UserType.init()
    
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    
    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "sign_up",hideImage: false)
            VStack{
                UserTypesList(selectedUser: $selectedUser)
                GeometryReader { gr in
                    ScrollView(.vertical){
                        VStack{
                            switch selectedUser.id{
                            case 0:
                                StudentSignUpView()
                            case 1:
                                ParentSignUpView()
                            case 2:
                                TeacherSignUpView()
                            default:
                                StudentSignUpView()
                            }
                            HStack(spacing:5){
                                Text("Already have an account ?".localized())
                                    .foregroundColor(ColorConstants.Gray900)
                                    .font(Font.SoraRegular(size: 12))
                                
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
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
                        .frame(minHeight: gr.size.height)
                        .padding(.horizontal)
                    }
                }
                .frame(width:UIScreen.main.bounds.width)
            }
            .padding(.horizontal)
        }
        .background(ColorConstants.Gray50.ignoresSafeArea()
            .onTapGesture {
                hideKeyboard()
            }
        )
        
    }
}


#Preview {
    SignUpView()
}

struct StudentSignUpView: View {
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    
    var body: some View {
        VStack{ // (Title - Data - Submit Button)
            VStack(alignment: .leading, spacing: 0){
                // -- Data Title --
                VStack (alignment: .leading,spacing: 5){
                    Text("Pesrsonal Information".localized())
                        .font(Font.SoraBold(size:18))
                        .fontWeight(.bold)
                        .foregroundColor(ColorConstants.Black900)
                        .multilineTextAlignment(.leading)
                    
                    Text("Enter subtitle here".localized())
                        .font(Font.SoraRegular(size: 10.0))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Black900)
                        .multilineTextAlignment(.leading)
                    
                }
                
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
            
            CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {})
                .padding(.top,40)
        }
    }
}
#Preview{
    StudentSignUpView()
}


struct ParentSignUpView: View {
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    
    var body: some View {
        VStack{ // (Title - Data - Submit Button)
            VStack(alignment: .leading, spacing: 0){
                // -- Data Title --
                VStack (alignment: .leading,spacing: 5){
                    Text("Pesrsonal Information".localized())
                        .font(Font.SoraBold(size:18))
                        .fontWeight(.bold)
                        .foregroundColor(ColorConstants.Black900)
                        .multilineTextAlignment(.leading)
                    
                    Text("Enter subtitle here".localized())
                        .font(Font.SoraRegular(size: 10.0))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Black900)
                        .multilineTextAlignment(.leading)
                    
                }
                
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
            
            CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {})
                .padding(.top,40)
        }
    }
}

#Preview{
    ParentSignUpView()
        .padding(.all)
}


struct TeacherSignUpView: View {
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    
    var body: some View {
        VStack{ // (Title - Data - Submit Button)
            VStack(alignment: .leading, spacing: 0){
                // -- Data Title --
                VStack (alignment: .leading,spacing: 5){
                    Text("Pesrsonal Information".localized())
                        .font(Font.SoraBold(size:18))
                        .fontWeight(.bold)
                        .foregroundColor(ColorConstants.Black900)
                        .multilineTextAlignment(.leading)
                    
                    Text("Enter subtitle here".localized())
                        .font(Font.SoraRegular(size: 10.0))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Black900)
                        .multilineTextAlignment(.leading)
                    
                }
                
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
            
            CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {})
                .padding(.top,40)
        }
    }
}

#Preview{
    TeacherSignUpView()
        .padding(.all)
}
