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
    @EnvironmentObject var studentsignupvm : StudentSignUpVM
    
    //    @State var isPush = false
    //    @State var destination = AnyView(EmptyView())
    @State private var isVerified = false
    @State private var showTermsSheet = false // State to control sheet presentation
    @State var mobileLength:Int = Helper.shared.getAppCountry()?.mobileLength ?? 11

    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        SignUpHeaderTitle()
                        
                        // -- inputs --
                        Group {
                            CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $studentsignupvm.name,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $studentsignupvm.phone,textContentType:.telephoneNumber,keyboardType:.asciiCapableNumberPad,isvalid: studentsignupvm.isphonevalid)
                                .onChange(of: studentsignupvm.phone) { newValue in
                                    if newValue.count > mobileLength {
                                        studentsignupvm.phone = String(newValue.prefix(mobileLength))
                                    }
                                }
                            
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $studentsignupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            //                            let twelveYearsAgo = Calendar.current.date(byAdding: .year, value: -12, to: Date()) ?? Date()
                            CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedDateStr:$studentsignupvm.birthDateStr,endDate: Date(),datePickerComponent:.date)
                            
                            CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $studentsignupvm.educationType,options:lookupsvm.EducationTypesList)
                                .onChange(of: studentsignupvm.educationType, perform: { val in
                                    lookupsvm.SelectedEducationType = val
                                })
                            
                            CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $studentsignupvm.educationLevel,options:lookupsvm.EducationLevelsList)
                                .onChange(of: studentsignupvm.educationLevel, perform: { val in
                                    lookupsvm.SelectedEducationLevel = val
                                })
                            
                            CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $studentsignupvm.academicYear,options:lookupsvm.AcademicYearsList)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $studentsignupvm.Password,isvalid: studentsignupvm.isPasswordvalid)
                                .onChange(of: studentsignupvm.Password) { newValue in
                                    if newValue.containsNonEnglishOrNumbers() {
                                        studentsignupvm.Password = String(newValue.dropLast())
                                    }
                                }
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $studentsignupvm.confirmPassword,isvalid: studentsignupvm.isconfirmPasswordvalid)
                                .onChange(of: studentsignupvm.confirmPassword) { newValue in
                                    if newValue.containsNonEnglishOrNumbers() {
                                        studentsignupvm.confirmPassword = String(newValue.dropLast())
                                    }
                                }
                            
                        }
                        .padding([.top])
                        CheckboxField(label: "Accept the Terms and Privacy Policy",color: ColorConstants.Black900,textSize: 13,isMarked: $studentsignupvm.acceptTerms,isunderlined: true,onTabText:{
                            //                            print("open\n",Constants.TermsAndConditionsURL)
                            showTermsSheet = true
                        })
                        .padding(.top,15)
                    }
                    .padding(.top,20)
                    Spacer()
                    
                    CustomButton(Title:"Submit",IsDisabled:.constant(!studentsignupvm.isFormValid), action: {
                        studentsignupvm.RegisterStudent()
                        //                        isPush = true
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
            .fullScreenCover(isPresented: $studentsignupvm.isDataUploaded, onDismiss: {
                print("dismissed ")
                if isVerified {
                    //                    destination = AnyView(StudentHomeView())
                    //                    currentStep = .subjectsData
                    //                    isPush = true
                    //                    dismiss() // after signup back to login
                    Helper.shared.changeRoot(toView: StudentTabBarView(homeIndex: 2)) // after signup go home
                }
            }, content: {
                OTPVerificationView(PhoneNumber:studentsignupvm.phone,CurrentOTP: studentsignupvm.OtpM?.otp ?? 0, verifycase: .creatinguser, secondsCount:studentsignupvm.OtpM?.secondsCount ?? 0, isVerified: $isVerified, sussessStep: .constant(.accountCreated))
                    .hideNavigationBar()
            })
        }
        .onAppear(perform: {
            lookupsvm.getGendersArr()
            lookupsvm.GetEducationTypes()
        })
        
        .sheet(isPresented: $showTermsSheet) {
            if let url = URL(string: Constants.TermsAndConditionsURL) {
                WebView(url: url)
            }
        }
    }
}
#Preview{
    StudentSignUpView()
        .environmentObject(LookUpsVM())
        .environmentObject(StudentSignUpVM())
}
