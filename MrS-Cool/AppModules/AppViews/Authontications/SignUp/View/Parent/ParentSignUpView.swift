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
    
    //    @State var isPush = false
    //    @State var destination = AnyView(ParentTabBarView())
    @State private var isVerified = false
    
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
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $signupvm.phone,textContentType:.telephoneNumber,keyboardType:.asciiCapableNumberPad,isvalid:signupvm.isphonevalid)
                                .onChange(of: signupvm.phone) { newValue in
                                    if newValue.count > 11 {
                                        signupvm.phone = String(newValue.prefix(11))
                                    }
                                }
                            CustomTextField(iconName:"img_group172",placeholder: "Email *", text: $signupvm.email,textContentType:.emailAddress,keyboardType:.emailAddress,isvalid: signupvm.isemailvalid)
                            
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedDateStr:$signupvm.birthDateStr)
                            
                            CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $signupvm.country,options:lookupsvm.CountriesList)
                                .onChange(of: signupvm.country, perform: { value in
                                    lookupsvm.SelectedCountry = value
                                    signupvm.governorte = nil
                                    signupvm.city = nil
                                })
                            
                            CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $signupvm.governorte,options:lookupsvm.GovernoratesList)
                                .onChange(of: signupvm.governorte, perform: { value in
                                    lookupsvm.SelectedGovernorate = value
                                    signupvm.city = nil
                                })
                            
                            CustomDropDownField(iconName:"img_group_512374",placeholder: "ِCity *", selectedOption: $signupvm.city,options:lookupsvm.CitiesList)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $signupvm.Password,isvalid:signupvm.isPasswordvalid)
                                .onChange(of: signupvm.Password) { newValue in
                                    if newValue.containsNonEnglishOrNumbers() {
                                        signupvm.Password = String(newValue.dropLast())
                                    }
                                }
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $signupvm.confirmPassword,isvalid:signupvm.isconfirmPasswordvalid)
                                .onChange(of: signupvm.confirmPassword) { newValue in
                                    if newValue.containsNonEnglishOrNumbers() {
                                        signupvm.confirmPassword = String(newValue.dropLast())
                                    }
                                }
                        }
                        .padding([.top])
                        CheckboxField(label: "Accept the Terms and Privacy Policy",
                                      color: ColorConstants.Black900, textSize: 13,
                                      isMarked: $signupvm.acceptTerms)
                        .padding(.top,15)
                    }
                    
                    .padding(.top,20)
                    Spacer()
                    
                    CustomButton(Title:"Submit",IsDisabled: .constant(!signupvm.isFormValid), action: {
                        signupvm.RegisterParent()
                        //                        isPush = true
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
            .fullScreenCover(isPresented: $signupvm.isDataUploaded, onDismiss: {
                print("dismissed ")
                if isVerified {
                    //                    destination = AnyView(StudentHomeView())
                    //                    currentStep = .subjectsData
                    //                    isPush = true
//                    dismiss() // after signup back to login
                    Helper.shared.changeRoot(toView: ParentTabBarView())// after signup go home

                }
            }, content: {
                OTPVerificationView(PhoneNumber:signupvm.phone,CurrentOTP: signupvm.OtpM?.otp ?? 0, verifycase: .creatinguser, secondsCount:signupvm.OtpM?.secondsCount ?? 0, isVerified: $isVerified, sussessStep: .constant(.accountCreated))
                    .hideNavigationBar()
            })
            .onAppear(perform: {
                lookupsvm.getGendersArr()
                lookupsvm.getCountriesArr()
            })
            
            
            //            NavigationLink(destination: destination, isActive: $signupvm.isDataUploaded, label: {})
        }
        
    }
}

#Preview{
    ParentSignUpView()
        .environmentObject(LookUpsVM())
        .environmentObject(ParentSignupVM())
}
