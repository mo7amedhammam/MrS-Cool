//
//  ManageLessonMaterialView.swift
//  MrS-Cool
//
//  Created by wecancity on 25/11/2023.
//

import SwiftUI

struct ManageLessonMaterialView: View {    //        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var managelessonmaterialvm : ManageLessonMaterialVM
    
    //    @State var isPush = false
    //    @State var destination = EmptyView()
    @State private var isEditing = false
    @State private var isSheetPresented = false
    @State private var selectedFileType: fileTypesList = .image // Track the selected file type
    
    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .camera // Track the selected file type
    @State private var startPickingImage = false
    @State private var startPickingPdf = false
    
    @State private var isPreviewPresented = false
    @State var previewurl : String = ""
    
    @State var showFilter : Bool = false
    var currentLesson:TeacherUnitLesson?
    var body: some View {
        ZStack {
            VStack {
                CustomTitleBarView(title: "Manage My Lesson Material")
                
                GeometryReader { gr in
                    ScrollView(.vertical,showsIndicators: false){
                        VStack{ // (Title - Data - Submit Button)
                            Group{
                                VStack(alignment: .leading, spacing: 0){
                                    // -- Data Title --
                                    HStack(alignment: .top){
                                        SignUpHeaderTitle(Title:  "Lesson Information")
                                        Spacer()
                                    }
                                    //                                .padding(.bottom )
                                    
                                    // -- inputs --
                                    Group {
                                        HStack(alignment:.top){
                                            VStack(alignment:.leading){
                                                Text("Education Type".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.educationTypeName ?? "Egyption")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                                Spacer().frame(height:20)
                                                
                                                Text("Academic Year".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.academicYearName ?? "level 1")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                                Spacer().frame(height:20)
                                                
                                                Text("Lesson".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.lessonName ?? "Lesson 1")
                                                    .font(Font.SoraRegular(size: 14))
                                            }
                                            Spacer()
                                            VStack(alignment:.leading){
                                                Text("Education Level".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.educationLevelName ?? "Primary")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                                Spacer().frame(height:20)
                                                
                                                Text("Subject".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.subjectSemesterYearName ?? "level 1")
                                                    .font(Font.SoraRegular(size: 14))
                                            }
                                        }
                                        
                                    }
                                    .foregroundColor(.mainBlue)
                                    .padding([.top,.horizontal])
                                    
                                }
                                .padding(.top,5)
                                
                                VStack {
                                    GeometryReader { gr in
                                        ScrollView(.vertical,showsIndicators: false){
                                            VStack{ // (Title - Data - Submit Button)
                                                Group{
                                                    VStack(alignment: .leading, spacing: 0){
                                                        // -- Data Title --
                                                        SignUpHeaderTitle(Title:managelessonmaterialvm.isEditing ? "Update My Material" : "Add New Material")
                                                        
                                                        // -- inputs --
                                                        Group {
                                                            CustomDropDownField(iconName:"img_group_512390",placeholder: "Material Type", selectedOption: $managelessonmaterialvm.materialType,options:lookupsvm.materialTypesList)
                                                            
                                                            CustomTextField(iconName:"img_group_512388",placeholder: "Material Title", text: $managelessonmaterialvm.materialName)
                                                            
                                                            CustomTextField(iconName:"img_group_512388",placeholder: "اسم المحتوى", text: $managelessonmaterialvm.materialNameEn).reversLocalizeView()
                                                            
                                                            
                                                            //                                                        CustomTextField(iconName:"img_group_512386",placeholder: "Order", text: $managelessonmaterialvm.documentOrder,keyboardType: .asciiCapableNumberPad)
                                                            
                                                            CustomTextField(iconName:"img_group_512411",placeholder: "URL", text: $managelessonmaterialvm.materialUrl,keyboardType: .URL)
                                                            
                                                        }
                                                        .padding([.top])
                                                        .padding(.horizontal,2)
                                                        
                                                        if managelessonmaterialvm.materialImg != nil || managelessonmaterialvm.materialPdf != nil{
                                                            VStack(alignment: .center,spacing:15) {
                                                                Image("img_maskgroup192")
                                                                HStack(alignment:.top,spacing: 10){
                                                                    Button(action: {
                                                                        managelessonmaterialvm.materialImg = nil
                                                                        managelessonmaterialvm.materialPdf = nil
                                                                    }, label: {
                                                                        Image("img_group")
                                                                            .resizable()
                                                                            .frame(width: 15, height: 18,alignment: .leading)
                                                                            .aspectRatio(contentMode: .fill)
                                                                    })
                                                                    
                                                                    Text("Your file uploaded\nsuccessfully")
                                                                        .font(Font.SoraRegular(size:12))
                                                                        .foregroundColor(ColorConstants.Gray900)
                                                                        .multilineTextAlignment(.center)
                                                                }
                                                            }
                                                            .padding(.top)
                                                            .frame(minWidth:0,maxWidth:.infinity)
                                                        }else{
                                                            CustomButton(imageName:"img_group_512394",Title: "Choose Files",IsDisabled: .constant(false)){
                                                                hideKeyboard()
                                                                isSheetPresented = true
                                                            }
                                                            .frame(height: 50)
                                                            .padding(.top)
                                                            .padding(.horizontal,80)
                                                            
                                                            Text("Files supported: PDF, JPG, PNG,\nTIFF, GIF, WORD\nMaximum size is : 2MB")
                                                                .lineSpacing(4)
                                                                .frame(minWidth: 0,maxWidth: .infinity)
                                                                .font(Font.SoraRegular(size: 12.0))
                                                                .foregroundColor(ColorConstants.Gray901)
                                                                .multilineTextAlignment(.center)
                                                                .padding(.top)
                                                        }
                                                    }.padding(.top,20)
                                                    
                                                    HStack {
                                                        Group{
                                                            CustomButton(Title:managelessonmaterialvm.isEditing ? "Update" : "Save",IsDisabled: .constant(false), action: {
                                                                if managelessonmaterialvm.isEditing{
                                                                    managelessonmaterialvm.UpdateLessonMaterial(fileType: selectedFileType)
                                                                }else{
                                                                    managelessonmaterialvm.CreateLessonMaterial(fileType: selectedFileType)
                                                                }
                                                            })
                                                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                                                if managelessonmaterialvm.isEditing{
                                                                    managelessonmaterialvm.isEditing = false
                                                                    managelessonmaterialvm.editingMaterial = nil
                                                                }else{
                                                                    managelessonmaterialvm.clearTeachersMaterial()
                                                                }
                                                            })
                                                        }
                                                        .frame(width:120,height: 40)
                                                    }
                                                    .padding(.vertical)
                                                    //                        if teacherdocumentsvm.TeacherDocuments.count > 0{
                                                    HStack(){
                                                        SignUpHeaderTitle(Title: "Manage My Material")
                                                        Spacer()
                                                        Image("img_maskgroup62_clipped")
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .foregroundColor(ColorConstants.MainColor)
                                                            .frame(width: 25, height: 25, alignment: .center)
                                                            .onTapGesture(perform: {
                                                                showFilter = true
                                                            })
                                                    }
                                                }
                                                if (managelessonmaterialvm.TeacherLessonMaterial ?? []).count > 0{
                                                    List(managelessonmaterialvm.TeacherLessonMaterial ?? [] ,id:\.self){ material in
                                                        
                                                        ManageLessonMaterialCell(model: material,editBtnAction:{
                                                            managelessonmaterialvm.isEditing = true
                                                            managelessonmaterialvm.editingMaterial = material
                                                            
                                                        }, deleteBtnAction: {
                                                            managelessonmaterialvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                                                managelessonmaterialvm.DeleteLessonMaterial(id: material.id)
                                                            })
                                                            managelessonmaterialvm.isError.toggle()
                                                            
                                                        }, previewBtnAction: {
                                                            previewurl = (material.materialURL ?? "")
                                                            isPreviewPresented.toggle()
                                                        })
                                                        .listRowSpacing(0)
                                                        .listRowSeparator(.hidden)
                                                        .listRowBackground(Color.clear)
                                                        .padding(.vertical,-4)
                                                    }
//                                                    .scrollContentBackground(.hidden)
                                                    .listStyle(.plain)
                                                    .frame(height: gr.size.height/3*3)
                                                    .padding(.horizontal,-18)
                                                }
                                            }
                                            //                                        .frame(minHeight: gr.size.height)
                                        }
                                    }
                                    .onAppear(perform: {
                                        managelessonmaterialvm.TeacherLessonId = currentLesson?.id ?? 0
                                        lookupsvm.GetMaterialTypes()
                                        managelessonmaterialvm.GetLessonMaterial()
                                    })
                                    
                                    
                                    //MARK: -------- imagePicker From Camera and Library ------
                                    .confirmationDialog(Text("Choose_File_Type".localized()), isPresented: $isSheetPresented) {
                                        Button("Image".localized()) {
                                            selectedFileType = .image
                                            showImageSheet = true
                                            print("upload image")
                                            // Call a function to show an image picker
                                        }
                                        Button("PDF".localized()) {
                                            selectedFileType = .pdf
                                            startPickingPdf = true
                                            print("upload pdf")
                                            // Call a function to add a PDF document
                                        }
                                        Button("Cancel".localized(), role: .cancel) { }
                                    } message: {Text("this is the file type you will add".localized())}
                                    
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
                                                ImagePicker(sourceType: sourceType , selectedImage: $managelessonmaterialvm.materialImg)
                                            }
                                        }
                                        .fileImporter(isPresented: $startPickingPdf, allowedContentTypes: [.pdf], onCompletion: {file in
                                            do{
                                                let url = try file.get()
                                                print("file url ",url)
                                                managelessonmaterialvm.materialPdf = url
                                            }catch{
                                                print("can't get file",error)
                                            }
                                        })
                                    
                                        .fullScreenCover(isPresented: $isPreviewPresented, onDismiss: {
                                        // Optional: Handle actions on closing the preview sheet
                                    }, content: {
                                        FilePreviewerSheet(url:$previewurl)
                                    })
                                }
                                
                            }
                            .padding(.horizontal)
                            
                            
                            Spacer()
                        }
                        .frame(minHeight: gr.size.height)
                    }
                }
                
            }
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
            
            .showHud(isShowing: $managelessonmaterialvm.isLoading)
            .showAlert(hasAlert: $managelessonmaterialvm.isError, alertType: managelessonmaterialvm.error)
            
            if showFilter{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showFilter.toggle()
                    }
                    .blur(radius: 4) // Adjust the blur radius as needed
                DynamicHeightSheet(isPresented: $showFilter){
                    
                    VStack {
                        ColorConstants.Bluegray100
                            .frame(width:50,height:5)
                            .cornerRadius(2.5)
                            .padding(.top,2.5)
                        HStack {
                            Text("Filter".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            //                                            Spacer()
                        }
                        
                        ScrollView{
                            VStack{
                                Group{
                                    CustomDropDownField(iconName:"img_group_512390",placeholder: "Material Type", selectedOption: $managelessonmaterialvm.filtermaterialType,options:lookupsvm.materialTypesList)
                                    
                                    CustomTextField(iconName:"img_group_512388",placeholder: "Material Title", text: $managelessonmaterialvm.filtermaterialName)
                                }
                                .padding(.top,5)
//                                Spacer()
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            managelessonmaterialvm.GetLessonMaterial()
                                            showFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            managelessonmaterialvm.filtermaterialType = nil
                                            managelessonmaterialvm.GetLessonMaterial()
                                            showFilter = false
                                        })
                                    } .frame(width:130,height:40)
                                        .padding(.vertical)
                                }
                                //                                    Spacer()
                            }
                            .padding(.horizontal,3)
                            .padding(.top)
                        }

                    }
                    .padding()
                    .frame(height:300)
//                    .keyboardAdaptive()
                }

            }
        }
    }
}

#Preview {
    ManageLessonMaterialView()
        .environmentObject(LookUpsVM())
    //        .environmentObject(SignUpViewModel())
        .environmentObject(ManageLessonMaterialVM())
    
}
