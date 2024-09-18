//
//  EditParentProfileView.swift
//  MrS-Cool
//
//  Created by wecancity on 03/04/2024.
//

import SwiftUI

struct EditParentProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var lookupsvm = LookUpsVM()
    @EnvironmentObject var parentprofilevm : ParentProfileVM
    
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
                            if let image = parentprofilevm.image{
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
                                let imageURL : URL? = URL(string: Constants.baseURL+(parentprofilevm.imageStr ?? "").reverseSlaches())
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
                                    .imagePicker(selectedImage: $parentprofilevm.image)
//                                .onTapGesture(perform: {
//                                    showImageSheet = true
//                                })

                        }
                        Text(parentprofilevm.name)
                            .font(Font.bold(size: 18))
                            .foregroundStyle(ColorConstants.MainColor)
                        
                        Text(parentprofilevm.code)
                            .font(Font.bold(size: 18))
                            .foregroundStyle(ColorConstants.MainColor)
                            .padding(.top,2)

                        VStack(alignment: .leading, spacing: 0){
                            // -- Data Title --

                            
                            // -- inputs --
                            Group {
                                CustomTextField(iconName:"img_group51",placeholder: "Parent Name *", text: $parentprofilevm.name,textContentType:.name,isvalid: parentprofilevm.isnamevalid)
                                
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $parentprofilevm.phone,textContentType:.telephoneNumber,keyboardType:.numberPad,Disabled:true,isdimmed: true)
                                
                                CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $parentprofilevm.selectedGender,options:lookupsvm.GendersList)
                                
                                CustomTextField(iconName:"img_group_512411",placeholder: "Email Address", text: $parentprofilevm.email,textContentType:.emailAddress,keyboardType: .emailAddress,isvalid: parentprofilevm.isemailvalid)
                                
                                let endDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()

                                CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedDateStr:$parentprofilevm.birthDateStr,endDate: endDate,local: .current)
                                
                                CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $parentprofilevm.country,options:lookupsvm.CountriesList,isvalid: parentprofilevm.iscountryvalid)
                                    .onChange(of: parentprofilevm.country, perform: { val in
                                        lookupsvm.SelectedCountry = val
                                    })
                                
                                CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $parentprofilevm.governorte,options:lookupsvm.GovernoratesList,isvalid: parentprofilevm.isgovernortevalid)
                                    .onChange(of: parentprofilevm.governorte, perform: { val in
                                        lookupsvm.SelectedGovernorate = val
                                    })
                                
                                CustomDropDownField(iconName:"img_group_512374",placeholder: "ِCity *", selectedOption: $parentprofilevm.city,options:lookupsvm.CitiesList,isvalid: parentprofilevm.iscityvalid)
                            }
                            .padding([.top])
                        }
                        .padding(.top,20)
                        Spacer()
                        
                        CustomButton(Title:"Update Profile",IsDisabled: .constant(false), action: {
                            parentprofilevm.UpdateParentProfile()
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
//        .onAppear(perform: {
//                lookupsvm.getGendersArr()
//                lookupsvm.GetEducationTypes()
//                lookupsvm.getCountriesArr()
//        })
        .onAppear(perform: {
            Task(priority: .background, operation: {
                // if parent is editing student profile
                parentprofilevm.GetParentProfile()

                parentprofilevm.image = nil
                lookupsvm.getGendersArr()
                lookupsvm.getCountriesArr()
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                lookupsvm.SelectedCountry = parentprofilevm.country
                lookupsvm.SelectedGovernorate = parentprofilevm.governorte
                })
            })
        })
        .onChange(of: parentprofilevm.isDataUpdated, perform: { value in
            if value == true{
                dismiss()
            }
        })
        
        
        .showHud(isShowing: $parentprofilevm.isLoading)
        .showAlert(hasAlert: $parentprofilevm.isError, alertType: parentprofilevm.error)

//        //MARK: -------- imagePicker From Camera and Library ------
//        .confirmationDialog("Choose_Image_From".localized(), isPresented: $showImageSheet) {
//            Button("photo_Library".localized()) {
//                self.imagesource = .photoLibrary
//                self.showImageSheet = false
//                self.startPickingImage = true
//            }
//            Button("Camera".localized()) {
//                self.imagesource = .camera
//                self.showImageSheet = false
//                self.startPickingImage = true
//            }
//            Button("Cancel".localized(), role: .cancel) { }
//        } message: {Text("Choose_Image_From".localized())}
//            .sheet(isPresented: $startPickingImage) {
//                if let sourceType = imagesource {
//                    // Pick an image from the photo library:
//                    ImagePicker(sourceType: sourceType , selectedImage: $parentprofilevm.image)
//                }
//            }
//        NavigationLink(destination: destination, isActive: $isPush, label: {})

    }
}
#Preview{
    EditParentProfileView()
//        .environmentObject(LookUpsVM())
        .environmentObject(ParentProfileVM())
}

