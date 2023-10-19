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
                        VStack(alignment: .leading, spacing: 0){
                            Group {
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                                CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            }
                            .padding([.top])
                            Group {
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                                CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            }
                            .padding([.top])
                            Group {
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                                CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            }
                            .padding([.top])
                            Group {
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                                CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            }
                            .padding([.top])
                            Group {
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                                CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            }
                            .padding([.top])
                            Spacer()
                            CheckboxField(label: "Accept the Terms and Privacy Policy",
                                          color: ColorConstants.Black900, textSize: 13,
                                          isMarked: $acceptTerms)
                            .padding(.top,12)
                            
                            CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {})
                                .padding(.top,40)
                            
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
        .localizeView()
}
