//
//  TeacherSignUp.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

enum teacherSteps{
    case personalData,subjectsData,documentsData
}

struct TeacherSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var signupvmsubjects : TeacherSubjectsVM
    @EnvironmentObject var signupvmdocuments : TeacherDocumentsVM
    
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    
    //    @State var isPush = false
    //    @State var destination = AnyView(Text("destination"))
    
    @State var currentStep:teacherSteps = .personalData
    @State private var isVerified = false
    @State private var isFinish = false
    
    var body: some View {
        VStack(spacing:0) {
            Group{
                switch currentStep{
                case .personalData:
                    TeacherPersonalDataView()
                        .environmentObject(signupvm)
                case .subjectsData:
                    TeacherSubjectsDataView()
                        .environmentObject(signupvmsubjects)
                case .documentsData:
                    TeacherDocumentDataView(isFinish: $isFinish)
                        .environmentObject(signupvmdocuments)
                }
            }
            .environmentObject(lookupsvm)
            
            Spacer()
            HStack {
                CustomButton(Title:"Previous",IsDisabled: .constant(currentStep == .personalData), action: {
                    //                    isPush = true
                    //                    destination = AnyView(OTPVerificationView().hideNavigationBar())
                    switch currentStep{
                    case .personalData:
                        break
                    case .subjectsData:
                        currentStep = .personalData
                    case .documentsData:
                        currentStep = .subjectsData
                    }
                })
                .frame(width: 130,height: 40)
                Spacer()
                CustomButton(Title:currentStep == .personalData ? "Save & Next" : (currentStep == .subjectsData ? "Next":"Submit"),IsDisabled: .constant((currentStep == .subjectsData && !signupvm.isTeacherHasSubjects)||(currentStep == .documentsData && !signupvm.isTeacherHasDocuments)), action: {
                    switch currentStep{
                    case .personalData:
                        signupvm.RegisterTeacherData()
//                        signupvm.isDataUploaded = true
//                        currentStep = .subjectsData
                    case .subjectsData:
                        currentStep = .documentsData
                        
                    case .documentsData:
                        isFinish.toggle()
                    }
                })
                .frame(width: 130,height: 40)
                .fullScreenCover(isPresented: $signupvm.isDataUploaded, onDismiss: {
                    print("dismissed ")
                    if isVerified {
                        currentStep = .subjectsData
                    }
                }, content: {
                    OTPVerificationView(PhoneNumber:signupvm.phone,CurrentOTP: signupvm.OtpM?.otp ?? 0, verifycase: .creatinguser, secondsCount:signupvm.OtpM?.secondsCount ?? 0, isVerified: $isVerified, sussessStep: .constant(.teacherRegistered))
                        .hideNavigationBar()
                })
            }
            .padding([.horizontal,.bottom])
            
            if currentStep == .personalData{
                haveAccountView(){
                    dismiss()
                }
            }
            
        }
        
        //        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    private func handleSwipe(translation: CGFloat) {
        print("handling swipe! horizontal translation was \(translation)")
    }
}

#Preview{
    TeacherSignUpView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}
