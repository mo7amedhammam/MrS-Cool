//
//  TeacherDocumentDataView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

enum fileTypesList{
    case image,pdf
}
enum imageSources{
    case camera,library
}

struct TeacherDocumentDataView: View {
    //       @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var teacherdocumentsvm : TeacherDocumentsVM

    @State var isPush = false
    @State var destination = EmptyView()
    
    @State private var isSheetPresented = false
    @State private var selectedFileType: fileTypesList = .image // Track the selected file type
    
    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .camera // Track the selected file type
    @State private var startPickingImage = false
    @State private var startPickingPdf = false
    
    @State private var isPreviewPresented = false
    @State var previewurl : String = ""

    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    Group{
                        VStack(alignment: .leading, spacing: 0){
                            // -- Data Title --
                            HStack(alignment:.top){
                                SignUpHeaderTitle(Title: "Subjects Information")
                                Spacer()
                                Text("(3 / 3)")
                                    .font(.SoraRegular(size: 14))
                                    .foregroundColor(.black)
                            }
                            
                            // -- inputs --
                            Group {
                                CustomDropDownField(iconName:"img_group_512390",placeholder: "Document Type *", selectedOption: $teacherdocumentsvm.documentType,options:lookupsvm.documentTypesList)
                                
                                CustomTextField(iconName:"img_group_512388",placeholder: "Documents Title *", text: $teacherdocumentsvm.documentTitle)
                                
                                CustomTextField(iconName:"img_group_512386",placeholder: "Order *", text: $teacherdocumentsvm.documentOrder,keyboardType: .asciiCapableNumberPad)
                            }
                            .padding([.top])
                            
                            CustomButton(imageName:"img_group_512394",Title: "Choose Files",IsDisabled: .constant(false)){
                                isSheetPresented = true
                            }
                            .frame(height: 50)
                            .padding(.top)
                            .padding(.horizontal,80)
                            
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
                                        ImagePicker(sourceType: sourceType , selectedImage: $teacherdocumentsvm.documentImg)
                                    }
                                }
                                .fileImporter(isPresented: $startPickingPdf, allowedContentTypes: [.pdf], onCompletion: {file in
                                    do{
                                        let url = try file.get()
                                        print("file url ",url)
                                        teacherdocumentsvm.documentPdf = url
                                    }catch{
                                        print("can't get file",error)
                                    }
                                })
                            
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
                                    teacherdocumentsvm.CreateTeacherDocument(fileType: selectedFileType)
                                })
                                CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                    teacherdocumentsvm.clearTeachersDocument()
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
                    }.padding(.horizontal)
                    
                    List(teacherdocumentsvm.TeacherDocuments ?? [] ,id:\.self){ document in
                        TeacherDocumentCell(model: document, deleteBtnAction: {
                            teacherdocumentsvm.DeleteTeacherDocument(id: document.id)
                        }){
                            print("preview : ",Constants.baseURL + (document.documentPath ?? ""))
                                previewurl = Constants.baseURL + (document.documentPath ?? "")
                            isPreviewPresented.toggle()
                        }
                        .listRowSpacing(0)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .frame(height: gr.size.height/2)
                    
                }
                .frame(minHeight: gr.size.height)
            }
        }
        .onAppear(perform: {
            lookupsvm.GetDocumentTypes()
        })
        .onChange(of: teacherdocumentsvm.isTeacherHasDocuments, perform: { value in
            teacherdocumentsvm.isTeacherHasDocuments = value
        })

//        .showHud(isShowing: $teacherdocumentsvm.isLoading)
//        .showAlert(hasAlert: $teacherdocumentsvm.isError, alertType: .error( message: "\(teacherdocumentsvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
        
        .fullScreenCover(isPresented: $isPreviewPresented, onDismiss: {
            // Optional: Handle actions on closing the preview sheet
        }, content: {
            VStack{
                CustomTitleBarView(title: "")
                FilePreviewerSheet(url: $previewurl)
            }.padding(.top)
        })
    }
    
}

#Preview{
    TeacherDocumentDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
        .environmentObject(TeacherDocumentsVM())

}


