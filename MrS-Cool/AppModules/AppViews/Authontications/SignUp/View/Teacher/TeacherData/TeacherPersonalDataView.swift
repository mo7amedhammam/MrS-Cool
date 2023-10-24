//
//  TeacherPersonalDataView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI


struct TeacherPersonalDataView: View {
//    @Environment(\.dismiss) var dismiss
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

                            CustomTextField(iconName:"img_vector_black_900_20x20",placeholder: "Are You Teacher ? *", text: $signupvm.bio,Disabled: true)
                                    .overlay{
                                        RadioCheck(isSelected: $signupvm.isTeacher)
                                    }
                            
                            CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                       
                            CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                         
                            CustomDropDownField(iconName:"img_group_512374",placeholder: "ِCity *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $signupvm.Password)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $signupvm.confirmPassword)
                            
                            CustomTextField(iconName:"img_group512375",placeholder: "Teacher BIO *", text: $signupvm.bio)

                        }
                        .padding([.top])
                        CheckboxField(label: "Accept the Terms and Privacy Policy",
                                      color: ColorConstants.Black900, textSize: 13,
                                      isMarked: $signupvm.acceptTerms)
                        .padding(.top,15)
                    }.padding(.top,20)
                    Spacer()
                }
                .frame(minHeight: gr.size.height)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    TeacherPersonalDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}


