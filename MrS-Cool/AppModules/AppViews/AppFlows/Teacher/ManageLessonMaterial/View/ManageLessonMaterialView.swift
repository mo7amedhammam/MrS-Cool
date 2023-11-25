//
//  ManageLessonMaterialView.swift
//  MrS-Cool
//
//  Created by wecancity on 25/11/2023.
//

import SwiftUI

@available(iOS 16.0, *)
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
                                                        SignUpHeaderTitle(Title: "Add New Material")
                                                    
                                                    // -- inputs --
                                                    Group {
                                                        CustomDropDownField(iconName:"img_group_512390",placeholder: "Material Type", selectedOption: $managelessonmaterialvm.documentType,options:lookupsvm.documentTypesList)
                                                        
                                                        CustomTextField(iconName:"img_group_512388",placeholder: "Material Title", text: $managelessonmaterialvm.documentTitle)
                                                        
                                                        CustomTextField(iconName:"img_group_512386",placeholder: "Order", text: $managelessonmaterialvm.documentOrder,keyboardType: .asciiCapableNumberPad)

                                                        CustomTextField(iconName:"img_group57",placeholder: "URL", text: $managelessonmaterialvm.documentUrl,keyboardType: .URL)

                                                    }
                                                    .padding([.top])
                                                    
                                                    if managelessonmaterialvm.documentImg != nil || managelessonmaterialvm.documentPdf != nil{
                                                        VStack(alignment: .center,spacing:15) {
                                                            Image("img_maskgroup192")
                                                            HStack(alignment:.top,spacing: 10){
                                                                Button(action: {
                                                                    managelessonmaterialvm.documentImg = nil
                                                                    managelessonmaterialvm.documentPdf = nil
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
                                                            .font(Font.SoraRegular(size: getRelativeHeight(12.0)))
                                                            .foregroundColor(ColorConstants.Gray901)
                                                            .multilineTextAlignment(.center)
                                                            .padding(.top)
                                                    }
                                                }.padding(.top,20)
                                                
                                                HStack {
                                                    Group{
                                                        CustomButton(Title:"Save",IsDisabled: .constant(false), action: {
                                                            managelessonmaterialvm.CreateTeacherDocument(fileType: selectedFileType)
                                                        })
                                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                                            managelessonmaterialvm.clearTeachersDocument()
                                                        })
                                                    }
                                                    .frame(width:120,height: 40)
                                                }
                                                .padding(.vertical)
                        //                        HStack {
                        //                            Text("* Note: Must be enter one item at least".localized())
                        //                                .font(Font.SoraRegular(size: 14))
                        //                                .multilineTextAlignment(.leading)
                        //                                .foregroundColor(ColorConstants.Black900)
                        //                            Spacer()
                        //                        }

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
                                                        
                                                        
                    //                                    HStack {
                    //                                        CustomButton(imageName:"img_maskgroup62_clipped",Title:"",IsDisabled: .constant(false), action: {
                    //                                            showFilter = true
                    //                                        })
                    //                                        .frame(width:100,height:35)
                    //                                        .padding(.vertical)
                    //                                        Spacer()
                    //                                    }
                                                    }
                                                    .sheet(isPresented: $showFilter) {
                                                        ScrollView {
                                                            VStack {
                                                                HStack {
                        //                                            Image("img_maskgroup62_clipped")
                        //                                                .renderingMode(.template)
                                                                    Text("Filter".localized())
                                                                        .font(Font.SoraBold(size: 18))
                                                                        .foregroundColor(.mainBlue)
                        //                                            Spacer()
                                                                }
                                                                .padding(.vertical)
                                                                
                                                                Group{
                                                                    CustomDropDownField(iconName:"img_group_512390",placeholder: "Material Type", selectedOption: $managelessonmaterialvm.filterdocumentType,options:lookupsvm.documentTypesList)
                                                                    
                                                                    CustomTextField(iconName:"img_group_512388",placeholder: "Material Title", text: $managelessonmaterialvm.filterdocumentTitle)
                                                                    
                                                                    CustomTextField(iconName:"img_group_512386",placeholder: "Order", text: $managelessonmaterialvm.filterdocumentOrder,keyboardType: .asciiCapableNumberPad)
                                                                    
                                                                }
                                                                .padding(.vertical,5)
                                                                

                                                                Spacer()
                                                                HStack {
                                                                    Group{
                                                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                                                            managelessonmaterialvm.GetTeacherDocument()
                                                                            showFilter = false
                                                                        })
                                                                        
                                                                        
                                                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                                                            managelessonmaterialvm.filterdocumentType = nil
                                                                            managelessonmaterialvm.GetTeacherDocument()
                                                                            showFilter = false
                                                                        })
                                                                    } .frame(width:130,height:40)
                                                                        .padding(.vertical)

                                                                }
                                                                
                        //                                    Spacer()
                                                            }
                                                            .padding()
                        //                                    .presentationDetents([.medium])
                                                            .presentationDetents([.fraction(0.5),.medium])
                                                        }
                                                    }
                        //                        }
                                                Spacer()
                                            }

                                            List(managelessonmaterialvm.TeacherDocuments ?? [] ,id:\.self){ document in
                                                TeacherDocumentCell(model: document, deleteBtnAction: {
                        //                            confirmDelete.toggle()
                                                    managelessonmaterialvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                                        managelessonmaterialvm.DeleteTeacherDocument(id: document.id)
                                                    })
                                                    managelessonmaterialvm.isError.toggle()
                                                }){
                                                    print("preview : ",Constants.baseURL + (document.documentPath ?? ""))
                                                        previewurl = Constants.baseURL + (document.documentPath ?? "")
                                                    isPreviewPresented.toggle()
                                                }
                                                .listRowSpacing(0)
                                                .listRowSeparator(.hidden)
                                                .listRowBackground(Color.clear)
                                                .padding(.vertical,-4)
                                            }
                                            .scrollContentBackground(.hidden)
                                            .listStyle(.plain)
                                            .frame(height: gr.size.height/3*2)
                                            .padding(.horizontal,-18)
                                        }
                                        .frame(minHeight: gr.size.height)
                                    }
                                }
                                .onAppear(perform: {
                                    lookupsvm.GetDocumentTypes()
                                    managelessonmaterialvm.GetTeacherDocument()
                                })
//                                .onChange(of: managelessonmaterialvm.isTeacherHasDocuments, perform: { value in
////                                    signupvm.isTeacherHasDocuments = value
//                                })
//                                .onChange(of: managelessonmaterialvm.isLoading, perform: { value in
//                                    Shared.shared.state.wrappedValue.isLoading.wrappedValue = value
//                                })

                        //        .showHud(isShowing: $teacherdocumentsvm.isLoading)
                        //        .showAlert(hasAlert: $teacherdocumentsvm.isError, alertType: .error( message: "\(teacherdocumentsvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
                                
                                //MARK: -------- imagePicker From Camera and Library ------
                        //        .confirmationDialog(Text("Choose_File_Type".localized()), isPresented: $isSheetPresented) {
                        //            Button("Image".localized()) {
                        //                selectedFileType = .image
                        //                showImageSheet = true
                        //                print("upload image")
                        //                // Call a function to show an image picker
                        //            }
                        //            Button("PDF".localized()) {
                        //                selectedFileType = .pdf
                        //                startPickingPdf = true
                        //                print("upload pdf")
                        //                // Call a function to add a PDF document
                        //            }
                        //            Button("Cancel".localized(), role: .cancel) { }
                        //        } message: {Text("this is the file type you will add".localized())}
                                
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
                                            ImagePicker(sourceType: sourceType , selectedImage: $managelessonmaterialvm.documentImg)
                                        }
                                    }
                                    .fileImporter(isPresented: $startPickingPdf, allowedContentTypes: [.pdf], onCompletion: {file in
                                        do{
                                            let url = try file.get()
                                            print("file url ",url)
                                            managelessonmaterialvm.documentPdf = url
                                        }catch{
                                            print("can't get file",error)
                                        }
                                    })
                                
                                .fullScreenCover(isPresented: $isPreviewPresented, onDismiss: {
                                    // Optional: Handle actions on closing the preview sheet
                                }, content: {
                                    FilePreviewerSheet(url: $previewurl)
                                        .overlay{
                                            VStack{
                                                CustomTitleBarView(title: "")
                                                Spacer()
                                            }.padding(.top)
                                        }
                                })
                                
//                                .fullScreenCover(isPresented: $isFinish, onDismiss: {
//                                    print("dismissed ")
//                        //            destination = AnyView(SignInView())
//                        ////            isPush.toggle()
//                        //            dismiss()
//                                }, content: {
//                                    CustomSuccessView(action: {
//                        //                destination = AnyView(SignInView())
//                                        dismiss()
//                                    }, successStep: .constant(.accountCreated))
//                            })
                            }
                            
//                            .sheet(isPresented: $showFilter) {
//                                ScrollView {
//                                    VStack {
//                                        HStack {
//                                            //                                            Image("img_maskgroup62_clipped")
//                                            //                                                .renderingMode(.template)
//                                            Text("Filter".localized())
//                                                .font(Font.SoraBold(size: 18))
//                                                .foregroundColor(.mainBlue)
//                                            //                                            Spacer()
//                                        }
//                                        .padding(.vertical)
//                                        
//                                        Group {
//                                            CustomTextField(iconName:"img_group_512380",placeholder: "Subject Lesson", text: $managelessonmaterialvm.lessonName )
//                                        }
//                                        
//                                        Spacer()
//                                        HStack {
//                                            Group{
//                                                CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
//                                                    managelessonmaterialvm .GetTeacherSubjectLessons()
//                                                    showFilter = false
//                                                })
//                                                
//                                                CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
//                                                    managelessonmaterialvm.clearFilter()
//                                                    managelessonmaterialvm .GetTeacherSubjectLessons()
//                                                    showFilter = false
//                                                })
//                                            } .frame(width:130,height:40)
//                                                .padding(.vertical)
//                                        }
//                                        //                                    Spacer()
//                                    }
//                                    .padding()
//                                    .presentationDetents([.fraction(0.3),.medium])
//                                    //                                    .presentationDetents([.fraction(0.25)])
//                                }
//                            }
                        }
                        .padding(.horizontal)
                        
                        //                        ScrollView{
//                        List{
//                            ForEach(manageteachersubjectlessonsvm.TeacherSubjectLessons ?? [], id:\.self) { unit in
//                                Section(header:
//                                            HStack {
//                                    Text(unit.unitName ?? "")
//                                        .font(Font.SoraBold(size: 18))
//                                        .foregroundColor(.mainBlue)
//                                        .padding(.top)
//                                    Spacer()
//                                }
//                                        //                                        .frame(height:40)
//                                ) {
//                                    ForEach(unit.teacherUnitLessons ?? [], id:\.id) { lesson in
//                                        ManageSubjectLessonCell(model: lesson, editBtnAction: {
//
//                                            manageteachersubjectlessonsvm.selectSubjectForEdit(subjectSemeterYearId:currentLesson?.id,item: lesson)
//                                            manageteachersubjectlessonsvm.showEdit = true
//                                        }, addBriefBtnAction: {
//                                          
//                                            manageteachersubjectlessonsvm.selectSubjectForEdit(subjectSemeterYearId:currentLesson?.id,item: lesson)
//                                            manageteachersubjectlessonsvm.GetSubjectLessonBrief()
//                                            manageteachersubjectlessonsvm.showBrief = true
//                                        })
//                                        .listRowSpacing(0)
//                                        .listRowSeparator(.hidden)
//                                        .listRowBackground(Color.clear)
//                                    }
//                                }
//                            }
//                            //                            }
//                        }
//                        .padding(.horizontal,-4)
//                        .listStyle(.plain)
//                        .scrollContentBackground(.hidden)
//                        .frame(minHeight: gr.size.height/2)
                        
                        Spacer()
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            .onAppear(perform: {
//                managelessonmaterialvm.subjectSemesterYearId = currentLesson?.id ?? 0
//                managelessonmaterialvm.GetTeacherSubjectLessons()
            })
 
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        .onDisappear {
//            managelessonmaterialvm.cleanup()
        }
        //        .showHud(isShowing: $teachersubjectsvm.isLoading)
        //        .showAlert(hasAlert: $teachersubjectsvm.isError, alertType: .error( message: "\(teachersubjectsvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
        //        .onChange(of: teachersubjectsvm.isLoading, perform: { value in
        //            signupvm.isLoading = value
        //        })
        
//        .overlay{
////            if managelessonmaterialvm.showEdit{
////                ScrollView {
////                    VStack{
////                        Spacer()
////                        VStack(spacing:15){
////                            HStack(spacing:10) {
////                                Image("img_vector_black_900_14x14")
////                                //                                                .renderingMode(.template)
////                                
////                                Text("Update Lesson".localized())
////                                    .font(Font.SoraBold(size: 18))
////                                    .foregroundColor(.mainBlue)
////                                Spacer()
////                            }
////                            Group {
////                                CustomTextField(iconName:"img_group_black_900",placeholder: "Group Price", text: $managelessonmaterialvm.groupCost,keyboardType:.asciiCapableNumberPad)
////                                
////                                CustomTextField(iconName:"img_group_black_900",placeholder: "Individual Time", text: $managelessonmaterialvm.groupTime,keyboardType:.asciiCapableNumberPad)
////                                
////                                //                        CustomTextField(iconName:"img_group58",placeholder: "Minimum Number Of Group Students", text: $manageteachersubjectlessonsvm.minGroup ,keyboardType:.asciiCapableNumberPad)
////                                
////                                //                        CustomTextField(iconName:"img_group58",placeholder: "Maximum Number Of Group Students", text: $manageteachersubjectlessonsvm.maxGroup,keyboardType:.asciiCapableNumberPad)
////                                
////                                CustomTextField(iconName:"img_group_black_900",placeholder: "Individual Price", text: $managelessonmaterialvm.individualCost,keyboardType:.asciiCapableNumberPad)
////                                CustomTextField(iconName:"img_group_black_900",placeholder: "Individual Time", text: $managelessonmaterialvm.individualTime,keyboardType:.asciiCapableNumberPad)
////                            }
////                            HStack {
////                                Group{
////                                    CustomButton(Title:"Update",IsDisabled: .constant(false), action: {
////                                        managelessonmaterialvm .UpdateTeacherSubjectLesson()
////                                        managelessonmaterialvm.showEdit = false
////                                    })
////                                    
////                                    CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
//////                                        manageteachersubjectlessonsvm.clearFilter()
//////                                        manageteachersubjectlessonsvm .GetTeacherSubjectLessons()
////                                        managelessonmaterialvm.showEdit = false
////                                    })
////                                } .frame(width:130,height:40)
////                                    .padding(.vertical)
////                            }
////                        }
////                        .padding()
////                        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0,bottomRight: 10.0)
////                            .fill(ColorConstants.WhiteA700).disabled(true)
////                        )
////                        .padding(.horizontal)
////                        Spacer()
////                    }
////                    .frame(height:UIScreen.main.bounds.height+30)
////                }.frame(height:UIScreen.main.bounds.height+30)
////                    .background( Color(.mainBlue).opacity(0.2))
////            }
//            
////            if managelessonmaterialvm.showBrief{
////                ScrollView {
////                    VStack{
////                        Spacer()
////                        VStack(spacing:15){
////                            HStack(spacing:10) {
////                                Image("img_group512375")
////                                //                                                .renderingMode(.template)
////                                Text("Update Lesson Brief".localized())
////                                    .font(Font.SoraBold(size: 18))
////                                    .foregroundColor(.mainBlue)
////                                Spacer()
////                            }
////                            Group {
////                                CustomTextEditor(iconName: "img_group512375",placeholder: "Lesson Brief",insidePlaceholder: "Tell us about your Lesson", text: $managelessonmaterialvm.subjectBriefEn,charLimit: 1000)
////
////                                CustomTextEditor(iconName: "img_group512375",placeholder: "عن الدرس",insidePlaceholder: "اخبرنا عن الدرس", text: $managelessonmaterialvm.subjectBrief,charLimit: 1000).localizeView()
////                            }
////                            HStack {
////                                Group{
////                                    CustomButton(Title:"Save",IsDisabled: .constant(false), action: {
////                                        managelessonmaterialvm.UpdateSubjectLessonBrief()
////                                        managelessonmaterialvm.showBrief = false
////                                    })
////                                    
////                                    CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
////                                        managelessonmaterialvm.showBrief = false
////                                    })
////                                } .frame(width:130,height:40)
////                                    .padding(.vertical)
////                            }
////                        }
////                        .padding()
////                        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0,bottomRight: 10.0)
////                            .fill(ColorConstants.WhiteA700).disabled(true)
////                        )
////                        .padding(.horizontal)
////                        Spacer()
////                    }
////                    .frame(height:UIScreen.main.bounds.height+30)
////                }.frame(height:UIScreen.main.bounds.height+30)
////                    .background( Color(.mainBlue).opacity(0.2))
////            }
//        }
    }
}

@available(iOS 16.0, *)
#Preview {
    ManageLessonMaterialView()
        .environmentObject(LookUpsVM())
    //        .environmentObject(SignUpViewModel())
        .environmentObject(ManageLessonMaterialVM())
    
}
