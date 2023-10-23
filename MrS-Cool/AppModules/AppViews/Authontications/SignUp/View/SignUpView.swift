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
    
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    
    var body: some View {
        VStack(spacing:0) {
            CustomTitleBarView(title: "sign_up",hideImage: false)
            VStack{
                UserTypesList(selectedUser: $signupvm.selecteduser)
                    .padding(.horizontal)
                    .disabled(!signupvm.isUserChangagble)
                VStack{
                    TabView(selection:$signupvm.selecteduser.id){
                        Group{
                            StudentSignUpView()
                                .tag(0)
                            
                            ParentSignUpView()
                                .tag(1)
                            
                            TeacherSignUpView()
                                .tag(2)
                        }
                        .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))
                        .environmentObject(lookupsvm)
                        .environmentObject(signupvm)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
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
    }
    private func handleSwipe(translation: CGFloat) {
        print("handling swipe! horizontal translation was \(translation)")
    }
}


#Preview {
    SignUpView()
}


struct StudentSignUpView: View {
    @Environment(\.presentationMode) var presentationMode
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
                            CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $signupvm.name,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $signupvm.phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)

                            CustomDropDownField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)

                            CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)

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
                        destination = AnyView(OTPVerificationView().hideNavigationBar())
                    })
                    .frame(height: 50)
                    .padding(.top,40)
                    haveAccountView(){
                        presentationMode.wrappedValue.dismiss()
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


struct ParentSignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var signupvm : SignUpViewModel
    
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    @State var gender = ""
    
    @State var isPush = false
    @State var destination = AnyView(OTPVerificationView())
    
    @State var selectedOption = DropDownOption()
    //    var options = [DropDownOption(id: 1, Title: "Male"),DropDownOption(id: 2, Title: "FeMale")]
    
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        SignUpHeaderTitle()
                        
                        // -- inputs --
                        Group {
                            CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $Password,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $Password)
                        }
                        .padding([.top])
                        CheckboxField(label: "Accept the Terms and Privacy Policy",
                                      color: ColorConstants.Black900, textSize: 13,
                                      isMarked: $acceptTerms)
                        .padding(.top,15)
                    }
                    
                    .padding(.top,20)
                    Spacer()
                    
                    CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {
                        isPush = true
                        destination = AnyView(OTPVerificationView().hideNavigationBar())
                    })
                    .frame(height: 50)
                    .padding(.top,40)
                    
                    haveAccountView(){
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }
                .frame(minHeight: gr.size.height)
                .padding(.horizontal)
                
            }
            NavigationLink(destination: destination, isActive: $isPush, label: {})
            
        }
    }
}

#Preview{
    ParentSignUpView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}

enum teacherSteps{
    case personalData,subjectsData,documentsData
}

struct TeacherSignUpView: View {
    @Environment(\.presentationMode) var presentationMode
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
                        currentStep = .subjectsData
                        
                    case .subjectsData:
                        currentStep = .documentsData
                        
                    case .documentsData:
                        isPush = true
                        destination = AnyView(OTPVerificationView().hideNavigationBar())
                        
                    }
                    //                    isPush = true
                    //                    destination = AnyView(OTPVerificationView().hideNavigationBar())
                    
                })
                .frame(width: 130,height: 40)
                //                        .padding(.top,40)
            }
            //            .padding(.top,40)
            .padding(.horizontal)
            
            if currentStep == .personalData{
                haveAccountView(){
                    presentationMode.wrappedValue.dismiss()
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

struct TeacherPersonalDataView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var signupvm : SignUpViewModel
    
    @State var phone = ""
    @State var Password = ""
    @State var acceptTerms = false
    
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
                            CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $Password,textContentType:.name)
                            
                            CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                            
                            CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                       
                            CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                         
                            CustomDropDownField(iconName:"img_group_512374",placeholder: "ِCity *", selectedOption: $signupvm.selectedGender,options:lookupsvm.GendersList)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Password *", text: $Password)
                            
                            CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $Password)
                        }
                        .padding([.top])
                        CheckboxField(label: "Accept the Terms and Privacy Policy",
                                      color: ColorConstants.Black900, textSize: 13,
                                      isMarked: $acceptTerms)
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
struct TeacherSubjectsDataView: View {
    @Environment(\.presentationMode) var presentationMode
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
                        SignUpHeaderTitle(Title: "Subjects Information")
                        // -- inputs --
                        Group {
                            CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $signupvm.educationType,options:lookupsvm.GendersList)
                            
                            CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $signupvm.educationLevel,options:lookupsvm.GendersList)

                            CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $signupvm.academicYear,options:lookupsvm.GendersList)
                            CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject *", selectedOption: $signupvm.subject,options:lookupsvm.GendersList)
                        }
                        .padding([.top])
                    }.padding(.top,20)
                    
                    HStack {
                        Group{
                            CustomButton(Title:"Save",IsDisabled: .constant(false), action: {
                            })
                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                signupvm.clearTeachersSubject()
                            })
                        }
                        .frame(width:120,height: 40)
                        
                    }.padding(.vertical)
                    HStack {
                        Text("* Note: Must be enter one item at least")
                            .font(Font.SoraRegular(size: 14))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(ColorConstants.Black900)

                        Spacer()
                        
                    }
                    Spacer()
                }
                .frame(minHeight: gr.size.height)
                .padding(.horizontal)
            }
        }.onAppear(perform: {
            signupvm.isUserChangagble = false
        })
    }
}
struct TeacherDocumentDataView: View {
    @Environment(\.presentationMode) var presentationMode
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
                        SignUpHeaderTitle(Title: "Subjects Information")
                        // -- inputs --
                        Group {
                            CustomDropDownField(iconName:"img_group_512390",placeholder: "Document Type *", selectedOption: $signupvm.educationType,options:lookupsvm.GendersList)

                            CustomDropDownField(iconName:"img_group_512388",placeholder: "Documents Title *", selectedOption: $signupvm.educationLevel,options:lookupsvm.GendersList)

                            CustomTextField(iconName:"img_group_512386",placeholder: "Order *", text: $signupvm.name,keyboardType: .asciiCapableNumberPad)
                        }
                        .padding([.top])

                        CustomButton(imageName:"img_group_512394",Title: "Choose Files",IsDisabled: .constant(false)){
                        }
                        .frame(height: 50)
                        .padding(.top)
                        .padding(.horizontal,80)
                        
                        
                        Text("Files supported: PDF, JPG, PNG,\nTIFF, GIF, WORD\nMaximum size is : 2MB")
                            .lineSpacing(4)
                            .frame(minWidth: 0,maxWidth: .infinity)
                            .font(Font.SoraRegular(size: getRelativeHeight(12.0)))
                            .foregroundColor(ColorConstants.Gray901)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                        
                    }.padding(.top,20)
                    
                    HStack {
                        Group{
                            CustomButton(Title:"Save",IsDisabled: .constant(false), action: {
                            })
                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                signupvm.clearTeachersSubject()
                            })
                        }
                        .frame(width:120,height: 40)
                    }.padding(.vertical)
                    HStack {
                        Text("* Note: Must be enter one item at least")
                            .font(Font.SoraRegular(size: 14))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(ColorConstants.Black900)

                        Spacer()
                        
                    }
                    Spacer()
                }
                .frame(minHeight: gr.size.height)
                .padding(.horizontal)
            }
        }
    }
}

#Preview{
    TeacherDocumentDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}
