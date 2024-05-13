//
//  AddNewStudentView.swift
//  MrS-Cool
//
//  Created by wecancity on 30/03/2024.
//

import SwiftUI

struct AddNewStudentView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var lookupsvm = LookUpsVM()
    @StateObject var addnewstudentvm = AddNewStudentVM()
    
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    @State private var isVerified = false

    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .photoLibrary // Track the selected file type
    @State private var startPickingImage = false

    var body: some View {
        VStack {
            CustomTitleBarView(title: "Add New Student Account")

            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        ZStack(alignment: .topLeading){
                            if let image = addnewstudentvm.image{
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130,height: 130)
                                    .clipShape(Circle())
                            }else{
//                                AsyncImage(url: URL(string: Constants.baseURL+(studentsignupvm.imageStr ?? "")  )){image in
//                                    image
//                                        .resizable()
//                                }placeholder: {
//                                    Image("img_younghappysmi")
//                                        .resizable()
//                                }
                                let imageURL : URL? = URL(string: Constants.baseURL+(addnewstudentvm.imageStr ?? "").reverseSlaches())
                                KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130,height: 130)
                                .clipShape(Circle())
                            }
                                Image("img_vector_black_900_14x14")
                                    .frame(width: 30,height: 30)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .offset(x:-7,y:20)
                                .onTapGesture(perform: {
                                    showImageSheet = true
                                })

                        }
                        Text(addnewstudentvm.name)
                            .font(Font.SoraBold(size: 18))
                            .foregroundStyle(ColorConstants.MainColor)
                        
                        Text(addnewstudentvm.code)
                            .font(Font.SoraBold(size: 18))
                            .foregroundStyle(ColorConstants.MainColor)
                            .padding(.top,2)

                        VStack(alignment: .leading, spacing: 0){
                            // -- Data Title --
                            
                            // -- inputs --
                            Group {
                                CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $addnewstudentvm.name,textContentType:.name)
                                
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $addnewstudentvm.phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                                
                                CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $addnewstudentvm.selectedGender,options:lookupsvm.GendersList)
                                
                                CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedDateStr:$addnewstudentvm.birthDateStr)
                                
                                CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $addnewstudentvm.educationType,options:lookupsvm.EducationTypesList)
                                    .onChange(of: addnewstudentvm.educationType, perform: { val in
                                        lookupsvm.SelectedEducationType = val
                                    })
                                
                                CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $addnewstudentvm.educationLevel,options:lookupsvm.EducationLevelsList)
                                    .onChange(of: addnewstudentvm.educationLevel, perform: { val in
                                        lookupsvm.SelectedEducationLevel = val
                                    })
                                
                                CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $addnewstudentvm.academicYear,options:lookupsvm.AcademicYearsList)
                                
                                CustomTextField(iconName:"img_group_512411",placeholder: "Email Address", text: $addnewstudentvm.email,textContentType:.emailAddress,keyboardType: .emailAddress)
                                
                                CustomTextField(iconName:"img_group51",placeholder: "School Name *", text: $addnewstudentvm.SchoolName,textContentType:.name)

                                CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $addnewstudentvm.country,options:lookupsvm.CountriesList)
                                    .onChange(of: addnewstudentvm.country, perform: { val in
                                        lookupsvm.SelectedCountry = val
                                    })
                                
                                CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $addnewstudentvm.governorte,options:lookupsvm.GovernoratesList)
                                    .onChange(of: addnewstudentvm.governorte, perform: { val in
                                        lookupsvm.SelectedGovernorate = val
                                    })
                                
                                CustomDropDownField(iconName:"img_group_512374",placeholder: "ِCity *", selectedOption: $addnewstudentvm.city,options:lookupsvm.CitiesList)
                                
                                CustomTextField(fieldType:.Password,placeholder: "Password *", text: $addnewstudentvm.Password)
                                
                                CustomTextField(fieldType:.Password,placeholder: "Confirm Password *", text: $addnewstudentvm.confirmPassword)

                            }
                            .padding([.top])
                        }
                        .padding(.top,20)
                        Spacer()
                        
                        CustomButton(Title:"Submit",IsDisabled: .constant(false), action: {
                            addnewstudentvm.AddNewStudent()
                        })
                        .frame(height: 50)
                        .padding(.top,40)
                    }
                    .frame(minHeight: gr.size.height)
                    .padding(.horizontal)
                }
            }
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onAppear(perform: {
                lookupsvm.getGendersArr()
                lookupsvm.GetEducationTypes()
                lookupsvm.getCountriesArr()
        })
//        .showHud(isShowing: $studentsignupvm.isLoading)
//        .showAlert(hasAlert: $studentsignupvm.isError, alertType: studentsignupvm.error)

        //MARK: -------- imagePicker From Camera and Library ------
        .confirmationDialog("Choose_Image_From".localized(), isPresented: $showImageSheet) {
            Button("photo_Library".localized()) {
                self.imagesource = .photoLibrary
                self.showImageSheet = false
                self.startPickingImage = true
            }
            Button("Camera".localized()) {
                self.imagesource = .camera
                self.showImageSheet = false
                self.startPickingImage = true
            }
            Button("Cancel".localized(), role: .cancel) { }
        } message: {Text("Choose_Image_From".localized())}
            .sheet(isPresented: $startPickingImage) {
                if let sourceType = imagesource {
                    // Pick an image from the photo library:
                    ImagePicker(sourceType: sourceType , selectedImage: $addnewstudentvm.image)
                }
            }
            .fullScreenCover(isPresented: $addnewstudentvm.isDataUploaded, onDismiss: {
                print("dismissed ")
                if isVerified {
//                    destination = AnyView(StudentHomeView())
//                    currentStep = .subjectsData
//                    isPush = true
                    dismiss()

                }
            }, content: {
                OTPVerificationView(PhoneNumber:addnewstudentvm.phone,CurrentOTP: addnewstudentvm.OtpM?.otp ?? 0, verifycase: .addnewstudent, secondsCount:addnewstudentvm.OtpM?.secondsCount ?? 0, isVerified: $isVerified, sussessStep: .constant(.childrenAccountAdded))
                    .hideNavigationBar()
            })
        
//        NavigationLink(destination: destination, isActive: $isPush, label: {})

    }
}
#Preview{
    AddNewStudentView()
//        .environmentObject(LookUpsVM())
//        .environmentObject(StudentEditProfileVM())
}

