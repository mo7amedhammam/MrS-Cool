//
//  StudentEditProfileView.swift
//  MrS-Cool
//
//  Created by wecancity on 03/03/2024.
//


import SwiftUI

struct StudentEditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var lookupsvm = LookUpsVM()
    @EnvironmentObject var studentsignupvm : StudentEditProfileVM
    
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    @State private var isVerified = false

    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .photoLibrary // Track the selected file type
    @State private var startPickingImage = false

    var body: some View {
        VStack {
            CustomTitleBarView(title: "Edit Profile")

            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        ZStack(alignment: .topLeading){
                            if let image = studentsignupvm.image{
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
                                let imageURL : URL? = URL(string: Constants.baseURL+(studentsignupvm.imageStr ?? "").reverseSlaches())
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
                        Text(studentsignupvm.name)
                            .font(Font.SoraBold(size: 18))
                            .foregroundStyle(ColorConstants.MainColor)
                        
                        Text(studentsignupvm.code)
                            .font(Font.SoraBold(size: 18))
                            .foregroundStyle(ColorConstants.MainColor)
                            .padding(.top,2)

                        VStack(alignment: .leading, spacing: 0){
                            // -- Data Title --
                            
                            // -- inputs --
                            Group {
                                CustomTextField(iconName:"img_group51",placeholder: "Student Name *", text: $studentsignupvm.name,textContentType:.name,isvalid:studentsignupvm.isnamevalid)
                                
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $studentsignupvm.phone,textContentType:.telephoneNumber,keyboardType:.numberPad,Disabled:true,isdimmed: true)
                                
                                CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $studentsignupvm.selectedGender,options:lookupsvm.GendersList)
                                
                                let twelveYearsAgo = Calendar.current.date(byAdding: .year, value: -12, to: Date()) ?? Date()

                                CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedDateStr:$studentsignupvm.birthDateStr,endDate: twelveYearsAgo)
                                
                                CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $studentsignupvm.educationType,options:lookupsvm.EducationTypesList)
                                    .onChange(of: studentsignupvm.educationType, perform: { val in
                                        guard !studentsignupvm.isFillingData else {return}
                                        lookupsvm.SelectedEducationType = val
                                    })
                                
                                CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $studentsignupvm.educationLevel,options:lookupsvm.EducationLevelsList,isvalid:studentsignupvm.iseducationLevelvalid)
                                    .onChange(of: studentsignupvm.educationLevel, perform: { val in
                                        guard !studentsignupvm.isFillingData else {return}
                                        lookupsvm.SelectedEducationLevel = val
                                    })
                                
                                CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $studentsignupvm.academicYear,options:lookupsvm.AcademicYearsList,isvalid:studentsignupvm.isacademicYearvalid)
                                
                                CustomTextField(iconName:"img_group_512411",placeholder: "Email Address", text: $studentsignupvm.email,textContentType:.emailAddress,keyboardType: .emailAddress,isvalid:studentsignupvm.isemailvalid)
                                
                                CustomTextField(iconName:"img_group51",placeholder: "School Name *", text: $studentsignupvm.SchoolName,textContentType:.name,isvalid:studentsignupvm.isSchoolNamevalid)

                                CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $studentsignupvm.country,options:lookupsvm.CountriesList,isvalid:studentsignupvm.iscountryvalid)
                                    .onChange(of: studentsignupvm.country, perform: { val in
                                        guard !studentsignupvm.isFillingData else {return}
                                        lookupsvm.SelectedCountry = val
                                    })
                                
                                CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $studentsignupvm.governorte,options:lookupsvm.GovernoratesList,isvalid:studentsignupvm.isgovernortevalid)
                                    .onChange(of: studentsignupvm.governorte, perform: { val in
                                        guard !studentsignupvm.isFillingData else {return}
                                        lookupsvm.SelectedGovernorate = val
                                    })
                                
                                CustomDropDownField(iconName:"img_group_512374",placeholder: "ِCity *", selectedOption: $studentsignupvm.city,options:lookupsvm.CitiesList,isvalid:studentsignupvm.iscityvalid)
                            }
                            .padding([.top])
                        }
                        .padding(.top,20)
                        Spacer()
                        
                        CustomButton(Title:"Update Profile",IsDisabled: .constant(false), action: {
                            studentsignupvm.UpdateStudentProfile()
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
            studentsignupvm.GetStudentProfile()
            Task(priority: .background, operation: {
                // if parent is editing student profile
                studentsignupvm.image = nil
                lookupsvm.getGendersArr()
                lookupsvm.GetEducationTypes()
                lookupsvm.getCountriesArr()
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    lookupsvm.SelectedCountry = studentsignupvm.country
                    lookupsvm.SelectedGovernorate = studentsignupvm.governorte
                    lookupsvm.SelectedEducationType = studentsignupvm.educationType
                    lookupsvm.SelectedEducationLevel = studentsignupvm.educationLevel
                })
            })
        })
        .onChange(of: studentsignupvm.isDataUpdated, perform: { value in
            if value == true{
                dismiss()
            }
        })

        .showHud(isShowing: $studentsignupvm.isLoading)
        .showAlert(hasAlert: $studentsignupvm.isError, alertType: studentsignupvm.error)

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
                    ImagePicker(sourceType: sourceType , selectedImage: $studentsignupvm.image)
                }
            }
//        NavigationLink(destination: destination, isActive: $isPush, label: {})

    }
}
#Preview{
    StudentEditProfileView()
//        .environmentObject(LookUpsVM())
        .environmentObject(StudentEditProfileVM())
}

