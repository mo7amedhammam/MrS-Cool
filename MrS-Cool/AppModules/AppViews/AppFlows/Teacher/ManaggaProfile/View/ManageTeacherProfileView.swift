//
//  ManageTeacherProfileView.swift
//  MrS-Cool
//
//  Created by wecancity on 08/11/2023.
//

import SwiftUI

struct ManageTeacherProfileView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var lookupsvm = LookUpsVM()
    @EnvironmentObject var manageprofilevm : ManageTeacherProfileVM
    
//    @State private var showImageSheet = false
//    @State private var imagesource: UIImagePickerController.SourceType? = .photoLibrary // Track the selected file type
//    @State private var startPickingImage = false

//    @State private var isEditing = false
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Edit Profile")
//                .overlay{
//                    HStack{
//                        Spacer()
//                        Button(action: {
//                            isEditing.toggle()
//                        }) {
//                            Text(isEditing ? "Done" : "Edit")
//                                .foregroundColor(.mainBlue)
//                        }
//                    }.padding([.bottom,.horizontal])
//                }
            
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
//                                AsyncImage(url: URL(string: Constants.baseURL+(manageprofilevm.imageStr ?? "")  )){image in
//                                    image
//                                        .resizable()
//                                }placeholder: {
//                                    Image("img_younghappysmi")
//                                        .resizable()
//                                }
                                let imageURL : URL? = URL(string: Constants.baseURL+(manageprofilevm.imageStr ?? "").reverseSlaches())
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
//                                .onTapGesture(perform: {
//                                    showImageSheet = true
//                                })
                                    .imagePicker(selectedImage: $manageprofilevm.image)

                        }
                        
                        Text(manageprofilevm.name)
                            .font(Font.bold(size: 18))
                            .foregroundColor(.black900)
                        
                        Text(manageprofilevm.code)
                            .font(Font.bold(size: 18))
                            .foregroundColor(.black900)
                            .padding(.top,2)
                        
//                        if let rate = manageprofilevm.rate{
                            HStack{
                                Text("\(manageprofilevm.rate ?? 0,specifier: "%.1f")")
                                    .foregroundColor(ColorConstants.MainColor)
                                    .font(.semiBold(size: 13))
                                StarsView(rating: manageprofilevm.rate ?? 0)

                            }
//                        }
                        
                        
                        TeacherAccountStatus(profileStatus: manageprofilevm.accountStatus ?? ProfileStatus() )
                        
                        VStack(alignment: .leading, spacing: 0){
                            // -- Data Title --
                            
                            // -- inputs --
                            Group {
                                CustomTextField(iconName:"img_group51",placeholder: "Teacher Name *", text: $manageprofilevm.name,textContentType:.name,isvalid:manageprofilevm.isnamevalid)
                                
                                CustomTextField(iconName:"img_group172",placeholder: "Mobile Number *", text: $manageprofilevm.phone,textContentType:.telephoneNumber,keyboardType:.numberPad,Disabled:true,isdimmed: true)
                                    
                                
                                CustomDropDownField(iconName:"img_toilet1",placeholder: "Gender *", selectedOption: $manageprofilevm.selectedGender,options:lookupsvm.GendersList)
                                
                                CustomTextField(iconName:"img_vector_black_900_20x20",placeholder: "Are You Teacher ? *", text: .constant(""),Disabled: true)
                                    .overlay{
                                        RadioCheck(isSelected: $manageprofilevm.isTeacher)
                                    }
                                
                                CustomDropDownField(iconName:"img_group_512370",placeholder: "Country *", selectedOption: $manageprofilevm.country,options:lookupsvm.CountriesList)
                                
                                CustomDropDownField(iconName:"img_group_512372",placeholder: "Governorate *", selectedOption: $manageprofilevm.governorte,options:lookupsvm.GovernoratesList,isvalid:manageprofilevm.isgovernortevalid)
                                
                                CustomDropDownField(iconName:"img_group_512374",placeholder: "City *", selectedOption: $manageprofilevm.city,options:lookupsvm.CitiesList,isvalid:manageprofilevm.iscityvalid)
                                
                                CustomTextField(iconName:"img_group_512411",placeholder: "Email Address", text: $manageprofilevm.email,textContentType:.emailAddress,keyboardType: .emailAddress,isvalid:manageprofilevm.isemailvalid)
                                
                                
                                let endDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()

                                CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Birthdate *", selectedDateStr:$manageprofilevm.birthDateStr,endDate: endDate,isvalid:manageprofilevm.isbirthDateStrvalid)
                                                                
                                CustomDropDownField(iconName:"img_group_512374",placeholder: "Bank", selectedOption: $manageprofilevm.bank,options:lookupsvm.BanksList)

                                CustomTextField(iconName:"img_group_512411",placeholder: "IBAN", text: $manageprofilevm.iban,keyboardType: .alphabet)
                                    .onChange(of: manageprofilevm.iban) { newValue in
                                        manageprofilevm.iban = newValue.filter { $0.isEnglish }
                                    }

                                CustomTextEditor(iconName:"img_group512375",placeholder: "Teacher BIO *", text: $manageprofilevm.bio,charLimit: 1000)

                            }
                            .padding([.top])
                            
                        }.padding(.top,20)
                        Spacer()
                        
                        CustomButton(Title:"Update Profile",IsDisabled: .constant(false), action: {
                            manageprofilevm.UpdateTeacherProfile()
                        })
                        .padding(.top,40)
                    }
                    .frame(minHeight: gr.size.height)
                    .padding(.horizontal)
//                    .disabled(!isEditing)
                }
            }
            .onAppear(perform: {
//                Task(priority: .background, operation: {
//                manageprofilevm.GetTeacherProfile()
//                })
                
                Task(priority: .background, operation: {
                    manageprofilevm.image = nil
                    manageprofilevm.GetTeacherProfile()
                    lookupsvm.getGendersArr()
                    lookupsvm.getCountriesArr()
                    lookupsvm.getBanksArr()

                    lookupsvm.SelectedCountry = manageprofilevm.country
                    lookupsvm.SelectedGovernorate = manageprofilevm.governorte
//                    lookupsvm.SelectedCity = manageprofilevm.city
                })
                
                })
//            .onChange(of: isEditing){newval in
//                if newval{
//                    Task(priority: .background, operation: {
//                    lookupsvm.getGendersArr()
//                    lookupsvm.getCountriesArr()
//                        
//                        lookupsvm.SelectedCountry = manageprofilevm.country
//                        lookupsvm.SelectedGovernorate = manageprofilevm.governorte
//                        lookupsvm.SelectedCity = manageprofilevm.city
//
//                    })
//                }
//            }
            .onChange(of: manageprofilevm.country, perform: { value in
                //                guard isEditing else {return}
                guard !manageprofilevm.isFillingData else {return}
                
                lookupsvm.SelectedCountry = value
                manageprofilevm.governorte = nil
                
//                manageprofilevm.city = nil
//                lookupsvm.getGovernoratesArr()
//                lookupsvm.CitiesList.removeAll()
            })
            .onChange(of: manageprofilevm.governorte, perform: { value in
                //                guard isEditing else {return}
                guard !manageprofilevm.isFillingData else {return}

                lookupsvm.SelectedGovernorate = value
                manageprofilevm.city = nil
//                lookupsvm.getCitiesArr()
            })
            .onChange(of: manageprofilevm.isDataUploaded, perform: { value in
                if value == true{
                    dismiss()
                }
            })
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .showHud(isShowing: $manageprofilevm.isLoading)
        .showAlert(hasAlert: $manageprofilevm.isError, alertType: manageprofilevm.error,rightAction: {
       
            if manageprofilevm.isDataUploaded{
                dismiss()
            }
        })

        //MARK: -------- imagePicker From Camera and Library ------
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
//                    ImagePicker(sourceType: sourceType , selectedImage: $manageprofilevm.image)
//                }
//            }
         
    }
}

#Preview {
    ManageTeacherProfileView()
//        .environmentObject(LookUpsVM())
        .environmentObject(ManageTeacherProfileVM())
    
}


struct ProfileStatus{
    var statusId:Int?
    var statusName:String?
}

struct TeacherAccountStatus: View {
    var profileStatus : ProfileStatus = .init(statusId: 1, statusName: "Approved")
    //    var isActive : Bool?
    var body: some View {
        HStack {
            Spacer()
            
            Image(profileStatus.statusId == 1 ? "img_line1" : profileStatus.statusId == 2 ?  "img_subtract":"img_infofill")
                .frame(width:18.0,
                       height: 18.0, alignment: .center)
                .background(RoundedCorners(topLeft: 9.0, topRight: 9.0, bottomLeft: 9.0, bottomRight: 9.0)
                    .fill(profileStatus.statusId == 1 ? ColorConstants.LightGreen800 : profileStatus.statusId == 2 ? ColorConstants.WhiteA700 : .mainBlue))
                .padding(.vertical, 4.0)
            
            Text(profileStatus.statusName ?? "")
                .font(Font.regular(size: 14.0))
                .fontWeight(.regular)
                .foregroundColor(profileStatus.statusId == 1 ? ColorConstants.LightGreen800 : profileStatus.statusId == 2 ? ColorConstants.Red400 : .mainBlue)
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
                            .fill(profileStatus.statusId == 1 ? ColorConstants.LightGreen800 : ColorConstants.Red400))
                    Text(profileStatus.statusId == 1 ? "Active".localized():"Not Active".localized())
                        .font(Font.regular(size: 14.0))
                        .fontWeight(.regular)
                        .foregroundColor(profileStatus.statusId == 1 ? ColorConstants.LightGreen800 : ColorConstants.Red400)
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



