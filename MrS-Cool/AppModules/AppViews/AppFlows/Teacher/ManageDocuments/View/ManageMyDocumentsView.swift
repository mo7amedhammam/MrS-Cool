//
//  ManageMyDocumentsView.swift
//  MrS-Cool
//
//  Created by wecancity on 07/11/2023.
//

import SwiftUI

struct ManageMyDocumentsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var lookupsvm = LookUpsVM()
    @StateObject var signupvm = SignUpViewModel()
    @StateObject var teacherdocumentsvm = TeacherDocumentsVM()

    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    @State private var isSheetPresented = false
    @State private var selectedFileType: fileTypesList = .image // Track the selected file type
    
    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .camera // Track the selected file type
    @State private var startPickingImage = false
    @State private var startPickingPdf = false
    
    @State private var isPreviewPresented = false
    @State var previewurl : String = ""

    @State var confirmDelete : Bool = false

    @State var sussessStep : successSteps = .accountCreated
    @Binding var isFinish : Bool
    
    @State var showFilter : Bool = false
    @State var filterdocumentType : DropDownOption?
    fileprivate func clearDocumentsFilter() {
        filterdocumentType = nil
        teacherdocumentsvm.filterdocumentType = nil
    }
    
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Manage my documents")
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        Group{
                            VStack(alignment: .leading, spacing: 0){
                                // -- Data Title --
    //                            HStack(alignment:.top){
                                    SignUpHeaderTitle(Title: "Add New Document")
    //                                Spacer()
    //                                Text("(3 / 3)")
    //                                    .font(.SoraRegular(size: 14))
    //                                    .foregroundColor(.black)
    //                            }
                                
                                // -- inputs --
                                Group {
                                    CustomDropDownField(iconName:"img_group_512390",placeholder: "Document Type *", selectedOption: $teacherdocumentsvm.documentType,options:lookupsvm.documentTypesList,isvalid: teacherdocumentsvm.isdocumentTypevalid)
                                    
                                    CustomTextField(iconName:"img_group_512388",placeholder: "Documents Title *", text: $teacherdocumentsvm.documentTitle,isvalid:teacherdocumentsvm.isdocumentTitlevalid)
                                    
//                                    CustomTextField(iconName:"img_group_512386",placeholder: "Order *", text: $teacherdocumentsvm.documentOrder,keyboardType: .asciiCapableNumberPad,isvalid:teacherdocumentsvm.isdocumentOrdervalid)
                                }
                                .padding([.top])
                                
                                if teacherdocumentsvm.documentImg != nil || teacherdocumentsvm.documentPdf != nil{
                                    VStack(alignment: .center,spacing:15) {
                                        Image("img_maskgroup192")
                                        HStack(alignment:.top,spacing: 10){
                                            Button(action: {
                                                teacherdocumentsvm.documentImg = nil
                                                teacherdocumentsvm.documentPdf = nil
                                            }, label: {
                                                Image("img_group")
                                                    .resizable()
                                                    .frame(width: 15, height: 18,alignment: .leading)
                                                    .aspectRatio(contentMode: .fill)
                                            })
                                            
                                            Text("Your file uploaded successfully".localized())
                                                .font(Font.SoraRegular(size:12))
                                                .foregroundColor(ColorConstants.Gray900)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                    .padding(.top)
                                    .frame(minWidth:0,maxWidth:.infinity)
                                }else{
                                    if !(teacherdocumentsvm.isdocumentFilevalid ?? true){
                                        Text("File or image not selected".localized())
                                            .lineSpacing(4)
                                            .frame(minWidth: 0,maxWidth: .infinity)
                                            .font(Font.SoraRegular(size: getRelativeHeight(12.0)))
                                            .foregroundColor(ColorConstants.Red400)
                                            .multilineTextAlignment(.center)
                                            .padding(.top)
                                    }
                                    CustomButton(imageName:"img_group_512394",Title: "Choose Files",IsDisabled: .constant(false)){
                                        hideKeyboard()
                                        isSheetPresented = true
                                    }
                                    .frame(height: 50)
                                    .padding(.top)
                                    .padding(.horizontal,80)
                                    
                                    
                                    Text("Files supported: PDF, JPG, PNG,\nTIFF, GIF, WORD\nMaximum size is : 2MB".localized())
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
                                        clearDocumentsFilter()
//                                        teacherdocumentsvm.clearFilter()
                                        teacherdocumentsvm.CreateTeacherDocument(fileType: selectedFileType)
                                    })
                                    CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                        teacherdocumentsvm.clearTeachersDocument()
                                    })
                                }
                                .frame(width:120,height: 40)
                            }.padding(.vertical)
    //                        HStack {
    //                            Text("* Note: Must be enter one item at least".localized())
    //                                .font(Font.SoraRegular(size: 14))
    //                                .multilineTextAlignment(.leading)
    //                                .foregroundColor(ColorConstants.Black900)
    //                            Spacer()
    //                        }

    //                        if teacherdocumentsvm.TeacherDocuments.count > 0{
                                HStack(){
                                    SignUpHeaderTitle(Title: "Manage My Documents")
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
    //                        }

                            
                            Spacer()
                        }.padding(.horizontal)

                        List(teacherdocumentsvm.TeacherDocuments ?? [] ,id:\.self){ document in
                            TeacherDocumentCell(model: document, deleteBtnAction: {
    //                            confirmDelete.toggle()
                                teacherdocumentsvm.confirmation = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                    
                                    teacherdocumentsvm.DeleteTeacherDocument(id: document.id)

                                })
                                teacherdocumentsvm.isshowingConfirmation = true

                            }){
                                print("preview : ",Constants.baseURL + (document.documentPath ?? ""))
                                    previewurl = Constants.baseURL + (document.documentPath ?? "")
                                previewurl.openAsURL()

//                                isPreviewPresented.toggle()
//                                UIApplication.shared.open(URL(string: previewurl)!)

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
                teacherdocumentsvm.GetTeacherDocument()
            })
            .onChange(of: teacherdocumentsvm.isTeacherHasDocuments, perform: { value in
                signupvm.isTeacherHasDocuments = value
            })
//            .onChange(of: teacherdocumentsvm.isLoading, perform: { value in
//                Shared.shared.state.wrappedValue.isLoading.wrappedValue = value
//            })

    //        .showHud(isShowing: $teacherdocumentsvm.isLoading)
//            .showAlert(hasAlert: $teacherdocumentsvm.isError, alertType: .error( message: "\(teacherdocumentsvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
            
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
                .fileImporter(isPresented: $startPickingPdf, allowedContentTypes: [.pdf], onCompletion: {result in
                    switch result {
                    case .success(let url):
                        teacherdocumentsvm.documentPdf = url

                    case .failure(let failure):
                        print("Importer error: \(failure)")
                    }
                })
            
//                .fullScreenCover(isPresented: $isPreviewPresented, onDismiss: {
//                // Optional: Handle actions on closing the preview sheet
//            }, content: {
//                FilePreviewerSheet(url:$previewurl)
//            })
            
            .fullScreenCover(isPresented: $isFinish, onDismiss: {
                print("dismissed ")
    //            destination = AnyView(SignInView())
    ////            isPush.toggle()
    //            dismiss()
            }, content: {
                CustomSuccessView(action: {
    //                destination = AnyView(SignInView())
                    dismiss()
                }, successStep: .constant(.accountCreated))
        })
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
      .showHud(isShowing: $teacherdocumentsvm.isLoading)
      .showAlert(hasAlert: $teacherdocumentsvm.isError, alertType: teacherdocumentsvm.error)
      .showAlert(hasAlert: $teacherdocumentsvm.isshowingConfirmation, alertType: teacherdocumentsvm.confirmation)

      .overlay{
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
                      }
                      
                      ScrollView{
                          VStack{
                              Group {
                                  CustomDropDownField(iconName:"img_group_512390",placeholder: "Document Type *", selectedOption: $filterdocumentType,options:lookupsvm.documentTypesList)
                              }.padding(.top,5)
                              
                                  Spacer()
                                  HStack {
                                      Group{
                                          CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                              teacherdocumentsvm.filterdocumentType = filterdocumentType
                                              teacherdocumentsvm.GetTeacherDocument()
                                              showFilter = false
                                          })
                                          
                                          CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                              clearDocumentsFilter()
                                              teacherdocumentsvm.GetTeacherDocument()
                                              showFilter = false
                                          })
                                      } .frame(width:130,height:40)
                                          .padding(.vertical)
                                  }
                          }
                          .padding(.horizontal,3)
                          .padding(.top)
                      }
                  }
                  .padding()
                  .frame(height:240)
//                    .keyboardAdaptive()
              }

          }
      }
    }
}

//@available(iOS 16.0, *)
#Preview{
    ManageMyDocumentsView(isFinish: .constant(false))
//        .environmentObject(LookUpsVM())
//        .environmentObject(SignUpViewModel())
//        .environmentObject(TeacherDocumentsVM())
}

