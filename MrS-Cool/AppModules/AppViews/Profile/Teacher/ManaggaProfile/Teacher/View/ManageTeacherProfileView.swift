//
//  ManageTeacherProfileView.swift
//  MrS-Cool
//
//  Created by wecancity on 08/11/2023.
//

import SwiftUI

struct ManageTeacherProfileView: View {
    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var manageprofilevm : ManageTeacherProfileVM
    
    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .camera // Track the selected file type
    @State private var startPickingImage = false
    
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Edit Profile")
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        ZStack(alignment: .topLeading){
                            if let image = manageprofilevm.image{
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130,height: 130)
                                    .clipShape(Circle())
                            }else{
                                AsyncImage(url: URL(string: Constants.baseURL+(manageprofilevm.imageStr ?? "")  )){image in
                                    image
                                        .resizable()
                                }placeholder: {
                                    Image("img_younghappysmi")
                                        .resizable()
                                }
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
                        
                        Text(manageprofilevm.name)
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.black900)
                        
                        Text(manageprofilevm.id)
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.black900)
                            .padding(.top,2)
                        TeacherAccountStatus(profileStatus: .Approved)
                        
                        VStack(alignment: .leading, spacing: 0){
                            // -- Data Title --
                            
                            // -- inputs --
                            Group {
                                CustomTextField(iconName:"img_group51",placeholder: "Teacher Name *", text: $manageprofilevm.name,textContentType:.name)
                                
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $manageprofilevm.phone,textContentType:.telephoneNumber,keyboardType:.numberPad)
                                
                                CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $manageprofilevm.selectedGender,options:lookupsvm.GendersList)
                                
                                CustomTextField(iconName:"img_vector_black_900_20x20",placeholder: "Are You Teacher ? *", text: .constant(""),Disabled: true)
                                    .overlay{
                                        RadioCheck(isSelected: $manageprofilevm.isTeacher)
                                    }
                                
                                CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $manageprofilevm.country,options:lookupsvm.CountriesList)
                                
                                CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $manageprofilevm.governorte,options:lookupsvm.GovernoratesList)
                                
                                CustomDropDownField(iconName:"img_group_512374",placeholder: "ِCity *", selectedOption: $manageprofilevm.city,options:lookupsvm.CitiesList)
                                
                                CustomTextField(iconName:"img_group_512411",placeholder: "Email Address", text: $manageprofilevm.email,textContentType:.emailAddress,keyboardType: .emailAddress)
                                
                                CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedDateStr:$manageprofilevm.birthDateStr)
                                
                                CustomTextEditor(iconName:"img_group512375",placeholder: "Teacher BIO *", text: $manageprofilevm.bio,charLimit: 1000)
                            }
                            .padding([.top])
                            
                        }.padding(.top,20)
                        Spacer()
                        
                        CustomButton(Title:"Update Profile",IsDisabled: .constant(false), action: {
                            
                        })
                        .padding(.top,40)
                    }
                    .frame(minHeight: gr.size.height)
                    .padding(.horizontal)
                }
            }
            .onAppear(perform: {
                lookupsvm.getGendersArr()
                lookupsvm.getCountriesArr()
            })
            .onChange(of: manageprofilevm.country, perform: { value in
                lookupsvm.SelectedCountry = value
                manageprofilevm.governorte = nil
                manageprofilevm.city = nil
                lookupsvm.getGovernoratesArr()
                lookupsvm.CitiesList.removeAll()
            })
            .onChange(of: manageprofilevm.governorte, perform: { value in
                lookupsvm.SelectedGovernorate = value
                manageprofilevm.city = nil
                lookupsvm.getCitiesArr()
            })
        }
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
                    ImagePicker(sourceType: sourceType , selectedImage: $manageprofilevm.image)
                }
            }
    }
}

#Preview {
    ManageTeacherProfileView()
        .environmentObject(LookUpsVM())
        .environmentObject(ManageTeacherProfileVM())
    
}


enum ProfileStatus{
    case Approved,Regected,InProgress
}

struct TeacherAccountStatus: View {
    var profileStatus : ProfileStatus = .Approved
    //    var isActive : Bool?
    var body: some View {
        HStack {
            Spacer()
            
            Image(profileStatus == .Approved ? "img_line1" : profileStatus == .InProgress ? "img_infofill" : "img_subtract")
                .frame(width:18.0,
                       height: 18.0, alignment: .center)
                .background(RoundedCorners(topLeft: 9.0, topRight: 9.0, bottomLeft: 9.0, bottomRight: 9.0)
                    .fill(profileStatus == .Approved ? ColorConstants.LightGreen800 : profileStatus == .InProgress ? ColorConstants.Black900 : ColorConstants.WhiteA700))
                .padding(.vertical, 4.0)
            
            Text(profileStatus == .Approved ? "Approved".localized() : profileStatus == .InProgress ? "In Progress".localized() : "Rejected".localized())
                .font(Font.SoraRegular(size: 14.0))
                .fontWeight(.regular)
                .foregroundColor(profileStatus == .Approved ? ColorConstants.LightGreen800 : profileStatus == .InProgress ? ColorConstants.Black900 : ColorConstants.Red400)
                .multilineTextAlignment(.leading)
            //                .frame(width: 71.0,height: 18.0,alignment: .topLeading)
                .padding(.trailing)
            VStack {
                HStack {
                    ZStack {}
                        .frame(width: 7.0,
                               height: 7.0,
                               alignment: .bottom)
                        .background(RoundedCorners(topLeft: 3.5,topRight:3.5, bottomLeft: 3.5,bottomRight: 3.5)
                            .fill(profileStatus == .Approved ? ColorConstants.LightGreen800 : ColorConstants.Red400))
                    Text(profileStatus == .Approved ? "Active".localized():"Not Active".localized())
                        .font(Font.SoraRegular(size: 14.0))
                        .fontWeight(.regular)
                        .foregroundColor(profileStatus == .Approved ? ColorConstants.LightGreen800 : ColorConstants.Red400)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 14.0)
            }
            .frame(height: 26.0, alignment: .center)
            .background(RoundedCorners(topLeft: 4.0, topRight: 4.0, bottomLeft: 4.0, bottomRight: 4.0)
                .fill(ColorConstants.Gray305))
            Spacer()
        }
    }
}
