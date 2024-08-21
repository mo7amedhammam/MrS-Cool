//
//  SignUpView.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var lookupsvm = LookUpsVM()
    @StateObject var signupvm = SignUpViewModel()
    @StateObject var signupvmsubject = TeacherSubjectsVM()
    @StateObject var signupvmdocument = TeacherDocumentsVM()
    @StateObject var studentsignupvm = StudentSignUpVM()
    @StateObject var parentsignupvm = ParentSignupVM()

    @Binding var selecteduser : UserType
    @State var currentStep:teacherSteps = .personalData

    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "sign_up",hideImage: false)
            VStack{
                UserTypesList(selectedUser: $selecteduser){
                    Helper.shared.setSelectedUserType(userType:selecteduser.user)

//                    switch selecteduser.user {
//                    case .Student:
//                        Helper.shared.setSelectedUserType(userType:.Student)
////                        destination = AnyView(StudentTabBarView())
//                        
//                    case .Parent:
//                        Helper.shared.setSelectedUserType(userType:.Parent)
////                        destination = AnyView(ParentTabBarView())
//                        
//                    case .Teacher:
//                        Helper.shared.setSelectedUserType(userType:.Teacher)
////                        destination = AnyView(TeacherTabBarView())
//                    }
                }
                    .padding(.horizontal)
                    .disabled(!signupvm.isUserChangagble)
                VStack{
                    switch selecteduser.user{
                    case .Parent:
                        ParentSignUpView()
                            .environmentObject(parentsignupvm)

                    case .Teacher:
                        TeacherSignUpView(currentStep: currentStep)
                            .environmentObject(signupvmsubject)
                            .environmentObject(signupvmdocument)

//                            .environmentObject(appenvironmenrs)
                    default:
                        StudentSignUpView()
                            .environmentObject(studentsignupvm)
                    }
//                    TabView(selection:$signupvm.selecteduser.id){
//                        Group{
//                            StudentSignUpView()
//                                .tag(0)
//                            
//                            ParentSignUpView()
//                                .tag(1)
//                            
//                            TeacherSignUpView()
//                                .tag(2)
//                        }
//                        .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))
//
//                    }.tabViewStyle(.page(indexDisplayMode: .never))
                }
                .environmentObject(lookupsvm)
                .environmentObject(signupvm)
            }
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea()
            .onTapGesture {
                hideKeyboard()
            }
        )
        .onChange(of: selecteduser.user, perform: { value in
            signupvm.clearSelections()
            parentsignupvm.clearSelections()
            lookupsvm.SelectedCountry = nil
            lookupsvm.SelectedGovernorate = nil
            lookupsvm.SelectedCity = nil
        })
        //        NavigationLink(destination: destination, isActive: $isPush, label: {})
//        .showHud(isShowing: $signupvm.isLoading)

        .showHud(isShowing: .constant( signupvm.isLoading ?? false || signupvmsubject.isLoading ?? false || signupvmdocument.isLoading ?? false || studentsignupvm.isLoading ?? false || parentsignupvm.isLoading ?? false))
        
        .showAlert(hasAlert: $studentsignupvm.isError, alertType: studentsignupvm.error)
        .showAlert(hasAlert: $parentsignupvm.isError, alertType: parentsignupvm.error)
        
        .showAlert(hasAlert: $signupvm.isError, alertType: signupvm.error)
        
        .showAlert(hasAlert: $signupvmsubject.isError, alertType: signupvmsubject.error)
        .showAlert(hasAlert: $signupvmsubject.showConfirmDelete, alertType: signupvmsubject.error)
        
        .showAlert(hasAlert: $signupvmdocument.isError, alertType: signupvmdocument.error)
        .showAlert(hasAlert: $signupvmdocument.showConfirmDelete, alertType: signupvmdocument.error)

    }
    private func handleSwipe(translation: CGFloat) {
        print("handling swipe! horizontal translation was \(translation)")
    }
}


#Preview {
    SignUpView(selecteduser: .constant(UserType(id: 2, imgName: "teacher-vector", user: .Teacher, tintColor: .teacherTint)))
}

struct haveAccountView: View {
    var action:(()->())?
    var body: some View {
        HStack(spacing:5){
            Text("Already have an account ?".localized())
                .foregroundColor(ColorConstants.Gray900)
                .font(Font.SoraRegular(size: 12))
            Button(action: {
                action?()
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
}

struct SignUpHeaderTitle: View {
    var Title:String? = "Personal Information"
    var subTitle:String? = "Enter subtitle here"
    var subTitleView:AnyView? 

    var body: some View {
        VStack (alignment: .leading,spacing: 5){
            Text(Title?.localized() ?? "")
                .font(Font.SoraBold(size:18))
                .fontWeight(.bold)
//                .foregroundColor(ColorConstants.Black900)
                .multilineTextAlignment(.leading)
            
            if let subTitleView = subTitleView{
                subTitleView
            }else{
                Text(subTitle?.localized() ?? "")
                    .font(Font.SoraRegular(size: 12))
                    .fontWeight(.regular)
                    .foregroundColor(ColorConstants.Black900)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}





