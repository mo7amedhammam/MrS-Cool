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
    
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    
    @State var isPush = false
    @State var destination = AnyView(OTPVerificationView())
    
    @State var currentStep:teacherSteps = .personalData
    
    var body: some View {
        VStack(spacing:0) {
            TabView(selection: $currentStep){
                Group {
                    TeacherPersonalDataView().tag(teacherSteps.personalData)
                    TeacherSubjectsDataView().tag(teacherSteps.subjectsData)
                    TeacherDocumentDataView().tag(teacherSteps.documentsData)
                    
                }
                .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))
                .environmentObject(lookupsvm)
                .environmentObject(signupvm)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
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
                CustomButton(Title:currentStep == .personalData ? "Save & Next" : (currentStep == .subjectsData ? "Next":"Submit"),IsDisabled: .constant(false), action: {
                    switch currentStep{
                    case .personalData:
                        signupvm.RegisterTeacherData()
//                        currentStep = .subjectsData

                    case .subjectsData:
                        currentStep = .documentsData
                        
                    case .documentsData:
                        isPush = true
                        destination = AnyView(OTPVerificationView().hideNavigationBar())
                    }
                })
                .frame(width: 130,height: 40)
            }
            .padding([.horizontal,.bottom])
            
            if currentStep == .personalData{
                haveAccountView(){
                   dismiss()
                }
            }
            
            NavigationLink(destination: destination, isActive: $isPush, label: {})
        }
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
