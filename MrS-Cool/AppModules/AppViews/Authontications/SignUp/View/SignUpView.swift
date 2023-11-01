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

    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "sign_up",hideImage: false)
            VStack{
                UserTypesList(selectedUser: $signupvm.selecteduser)
                    .padding(.horizontal)
                    .disabled(!signupvm.isUserChangagble)
                VStack{
                    switch signupvm.selecteduser.id{
                    case 1:
                        ParentSignUpView()
                    case 2:
                        TeacherSignUpView()
                            .environmentObject(signupvmsubject)
                            .environmentObject(signupvmdocument)

//                            .environmentObject(appenvironmenrs)
                    default:
                        StudentSignUpView()
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
        .background(ColorConstants.Gray50.ignoresSafeArea()
            .onTapGesture {
                hideKeyboard()
            }
        )
        .onChange(of: signupvm.selecteduser.id, perform: { value in
            signupvm.clearSelections()
        })
        //        NavigationLink(destination: destination, isActive: $isPush, label: {})
//        .showHud(isShowing: $signupvm.isLoading)

        .showHud(isShowing: .constant( signupvm.isLoading ?? false || signupvmsubject.isLoading ?? false || signupvmdocument.isLoading ?? false))
        
//        .showAlert(hasAlert: $signupvm.isError, alertType: .error( message: "\(signupvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
//        .showHud(isShowing: $appenvironmenrs.isLoading)

//        .showHud(isShowing: $signupvmsubject.isLoading)
//        .showAlert(hasAlert: $signupvmsubject.isError, alertType: .error( message: "\(signupvmsubject.error?.localizedDescription ?? "")",buttonTitle:"Done"))
        
//        .showHud(isShowing: $signupvmdocument.isLoading)
//        .showAlert(hasAlert: $signupvmdocument.isError, alertType: .error( message: "\(signupvmdocument.error?.localizedDescription ?? "")",buttonTitle:"Done"))

        .showAlert(hasAlert: $signupvm.isError, alertType: signupvm.error)
        .showAlert(hasAlert: $signupvmsubject.isError, alertType: signupvmsubject.error)
        .showAlert(hasAlert: $signupvmdocument.isError, alertType: signupvmdocument.error)

            
    }
    private func handleSwipe(translation: CGFloat) {
        print("handling swipe! horizontal translation was \(translation)")
    }
}


#Preview {
    SignUpView()
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
    
    var body: some View {
        VStack (alignment: .leading,spacing: 5){
            Text(Title?.localized() ?? "")
                .font(Font.SoraBold(size:18))
                .fontWeight(.bold)
                .foregroundColor(ColorConstants.Black900)
                .multilineTextAlignment(.leading)
            
            Text(subTitle?.localized() ?? "")
                .font(Font.SoraRegular(size: 10.0))
                .fontWeight(.regular)
                .foregroundColor(ColorConstants.Black900)
                .multilineTextAlignment(.leading)
        }
    }
}





