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
    @EnvironmentObject var signupvm : ParentSignupVM

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
                            CustomTextField(iconName:"img_group51",placeholder: "Parent Name *", text: $signupvm.name,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $signupvm.phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Email *", text: $signupvm.email,textContentType:.emailAddress,keyboardType:.emailAddress)

                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedDateStr:$signupvm.birthDateStr)

                            
                            CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $signupvm.country,options:lookupsvm.CountriesList)
                       
                            CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $signupvm.governorte,options:lookupsvm.GovernoratesList)
                         
                            CustomDropDownField(iconName:"img_group_512374",placeholder: "ِCity *", selectedOption: $signupvm.city,options:lookupsvm.CitiesList)
                            
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
//                        destination = AnyView(OTPVerificationView().hideNavigationBar())
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
            .onAppear(perform: {
                lookupsvm.getGendersArr()
            })
            NavigationLink(destination: destination, isActive: $isPush, label: {})
            
        }
    }
}

#Preview{
    ParentSignUpView()
        .environmentObject(LookUpsVM())
        .environmentObject(ParentSignupVM())
}
