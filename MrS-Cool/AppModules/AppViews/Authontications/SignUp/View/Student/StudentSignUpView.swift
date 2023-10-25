//
//  StudentSignUpView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

struct StudentSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var signupvm : SignUpViewModel
    
    @State var isPush = false
    @State var destination = EmptyView()
    
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        SignUpHeaderTitle()
                        
                        // -- inputs --
                        Group {
                            CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $signupvm.name,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $signupvm.phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)

                            CustomDropDownField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $signupvm.educationType,options:lookupsvm.GendersList)
                            
                            CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $signupvm.educationLevel,options:lookupsvm.GendersList)

                            CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $signupvm.academicYear,options:lookupsvm.GendersList)

                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $signupvm.Password)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $signupvm.confirmPassword)
                        }
                        .padding([.top])
                        CheckboxField(label: "Accept the Terms and Privacy Policy",color: ColorConstants.Black900,textSize: 13,isMarked: $signupvm.acceptTerms)
                        .padding(.top,15)
                    }
                    .padding(.top,20)
                    Spacer()
                    
                    CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {
                        isPush = true
//                        destination = AnyView(OTPVerificationView().hideNavigationBar())
                    })
                    .frame(height: 50)
                    .padding(.top,40)
                    haveAccountView(){
                        self.dismiss()
                    }
                }
                .frame(minHeight: gr.size.height)
                .padding(.horizontal)
            }
            NavigationLink(destination: destination, isActive: $isPush, label: {})
            
        }
        .onAppear(perform: {
            //            lookupsvm.getGendersArr()
            //            print(lookupsvm.GendersArray)
            //            print(lookupsvm.GendersList)
        })
        
    }
}
#Preview{
    StudentSignUpView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}
