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
        
//    @State var isPush = false
//    @State var destination = EmptyView()
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        HStack(alignment:.top){
                            SignUpHeaderTitle()
                            Spacer()
                            Text("(1 / 3)")
                                .font(.SoraRegular(size: 14))
                                .foregroundColor(.black)
                        }
                        // -- inputs --
                        Group {
                            CustomTextField(iconName:"img_group51",placeholder: "Teacher Name *", text: $signupvm.name,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $signupvm.phone,textContentType:.telephoneNumber,keyboardType:.asciiCapableNumberPad)
                                .onChange(of: signupvm.phone) { newValue in
                                    if newValue.count > 11 {
                                        signupvm.phone = String(newValue.prefix(11))
                                    }
                                }
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)

                            CustomTextField(iconName:"img_vector_black_900_20x20",placeholder: "Are You Teacher ? *", text: .constant(""),Disabled: true)
                                    .overlay{
                                        RadioCheck(isSelected: $signupvm.isTeacher)
                                    }
                            
                            CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $signupvm.country,options:lookupsvm.CountriesList)
                       
                            CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $signupvm.governorte,options:lookupsvm.GovernoratesList)
                         
                            CustomDropDownField(iconName:"img_group_512374",placeholder: "ِCity *", selectedOption: $signupvm.city,options:lookupsvm.CitiesList)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $signupvm.Password)
                                .onChange(of: signupvm.Password) { newValue in
                                        if newValue.containsNonEnglishOrNumbers() {
                                            signupvm.Password = String(newValue.dropLast())
                                        }
                                    }
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $signupvm.confirmPassword)
                                .onChange(of: signupvm.confirmPassword) { newValue in
                                        if newValue.containsNonEnglishOrNumbers() {
                                            signupvm.confirmPassword = String(newValue.dropLast())
                                        }
                                    }
                            
                            CustomTextEditor(iconName:"img_group512375",placeholder: "Teacher BIO *", text: $signupvm.bio,charLimit: 1000)
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
        .onAppear(perform: {
                lookupsvm.getGendersArr()
                lookupsvm.getCountriesArr()
        })
        .onChange(of: signupvm.country, perform: { value in
            lookupsvm.SelectedCountry = value
            signupvm.governorte = nil
            signupvm.city = nil
            lookupsvm.getGovernoratesArr()
            lookupsvm.CitiesList.removeAll()
        })
        .onChange(of: signupvm.governorte, perform: { value in
            lookupsvm.SelectedGovernorate = value
            signupvm.city = nil
            lookupsvm.getCitiesArr()
        })
    }
}

#Preview {
    TeacherPersonalDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}
