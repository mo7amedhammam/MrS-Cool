//
//  ParentSignUpView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

struct ParentSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var signupvm : SignUpViewModel

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
                            CustomTextField(iconName:"img_group51",placeholder: "Teacher Name *", text: $signupvm.name,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $signupvm.phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $signupvm.Password)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $signupvm.confirmPassword)
                        }
                        .padding([.top])
                        CheckboxField(label: "Accept the Terms and Privacy Policy",
                                      color: ColorConstants.Black900, textSize: 13,
                                      isMarked: $signupvm.acceptTerms)
                        .padding(.top,15)
                    }
                    
                    .padding(.top,20)
                    Spacer()
                    
                    CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {
                        isPush = true
                        destination = AnyView(OTPVerificationView().hideNavigationBar())
                    })
                    .frame(height: 50)
                    .padding(.top,40)
                    
                    haveAccountView(){
                        dismiss()
                    }
                    
                }
                .frame(minHeight: gr.size.height)
                .padding(.horizontal)
                
            }
            NavigationLink(destination: destination, isActive: $isPush, label: {})
            
        }
    }
}

#Preview{
    ParentSignUpView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}
