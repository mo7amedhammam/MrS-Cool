//
//  BankTransferView.swift
//  MrS-Cool
//
//  Created by mohamed hammam on 17/08/2025.
//

import SwiftUI

//struct BankTransferView: View {
//    @Environment(\.dismiss) var dismiss
//    //    @StateObject var lookupsvm = LookUpsVM()
//    //    @StateObject var signupvm = SignUpViewModel()
//    @EnvironmentObject var viewmodel : BookingCheckoutVM
//    
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
//    
//    @State private var isSheetPresented = false
//    //    @State private var selectedFileType: fileTypesList = .image // Track the selected file type
//    
//    @State private var showImageSheet = false
//    @State private var imagesource: UIImagePickerController.SourceType? = .camera // Track the selected file type
//    @State private var startPickingImage = false
//    @State private var startPickingPdf = false
//    
//    //    @State private var isPreviewPresented = false
//    //    @State var previewurl : String = ""
//    
//    //    @State var confirmDelete : Bool = false
//    
//    //    @State var sussessStep : successSteps = .accountCreated
//    //    @State var isFinish : Bool = false
//    
//    //    @State var showFilter : Bool = false
//    //    @State var filterdocumentType : DropDownOption?
//    //    fileprivate func clearDocumentsFilter() {
//    //        filterdocumentType = nil
//    //        teacherdocumentsvm.filterdocumentType = nil
//    //    }
//    
//    var body: some View {
//        VStack {
//            CustomTitleBarView(title: "Bank_Transfare_Title")
//            GeometryReader { gr in
//                ScrollView(.vertical,showsIndicators: false){
//                    VStack( spacing: 12){ // (Title - Data - Submit Button)
//                        
//                        Image(.bankTransferQuestionMark)
//                            .padding(.top,8)
//                        
//                        VStack{
//                            VStack( spacing: 12){
//                                
//                                Text("Bank_Transfare_HeadTitle".localized())
//                                    .font(.bold(size:18))
//                                    .foregroundColor(ColorConstants.MainColor)
//                                    .multilineTextAlignment(.center)
//                                
//                                Text("Bank_Transfare_SubTitle".localized())
//                                    .font(.regular(size:14))
//                                    .foregroundColor(Color("teacher-tint"))
//                                    .multilineTextAlignment(.center)
//                                
//                                if viewmodel.documentImg != nil || viewmodel.documentPdf != nil {
//                                    VStack(alignment: .center,spacing:15) {
//                                        Image("img_maskgroup192")
//                                        HStack(alignment:.top,spacing: 10){
//                                            Button(action: {
//                                                viewmodel.documentImg = nil
//                                                viewmodel.documentPdf = nil
//                                            }, label: {
//                                                Image("img_group")
//                                                    .resizable()
//                                                    .frame(width: 15, height: 18,alignment: .leading)
//                                                    .aspectRatio(contentMode: .fill)
//                                            })
//                                            
//                                            Text("Your file uploaded successfully".localized())
//                                                .font(Font.regular(size:12))
//                                                .foregroundColor(ColorConstants.Gray900)
//                                                .multilineTextAlignment(.center)
//                                        }
//                                    }
//                                    .padding(.top)
//                                    .frame(minWidth:0,maxWidth:.infinity)
//                                }else{
//                                    if viewmodel.isdocumentFilevalid == false{
//                                        Text("File or image not selected".localized())
//                                            .lineSpacing(4)
//                                            .frame(minWidth: 0,maxWidth: .infinity)
//                                            .font(Font.regular(size: getRelativeHeight(12.0)))
//                                            .foregroundColor(ColorConstants.Red400)
//                                            .multilineTextAlignment(.center)
//                                            .padding(.top)
//                                    }
//                                    CustomButton(imageName:"img_group_512394",Title: "Bank_Transfare_choose_Btn",IsDisabled: .constant(false)){
//                                        hideKeyboard()
//                                        isSheetPresented = true
//                                    }
//                                    .frame(height: 50)
//                                    .padding(.top)
//                                    .padding(.horizontal,80)
//                                    
//                                    Text("Files supported: PDF, JPG, PNG,\nTIFF, GIF, WORD\nMaximum size is : 2MB".localized())
//                                        .lineSpacing(4)
//                                        .frame(minWidth: 0,maxWidth: .infinity)
//                                        .font(Font.regular(size: getRelativeHeight(12.0)))
//                                        .foregroundColor(ColorConstants.Gray901)
//                                        .multilineTextAlignment(.center)
//                                        .padding(.vertical)
//                                }
//                            }.padding(.top,20)
//                            
//                            //                            HStack {
//                            //                                Group{
//                            //                                    CustomButton(Title:"Save",IsDisabled: .constant(false), action: {
//                            //                                        clearDocumentsFilter()
//                            ////                                        teacherdocumentsvm.clearFilter()
//                            //                                        teacherdocumentsvm.CreateTeacherDocument(fileType: selectedFileType)
//                            //                                    })
//                            //                                    CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
//                            //                                        teacherdocumentsvm.clearTeachersDocument()
//                            //                                    })
//                            //                                }
//                            //                                .frame(width:120,height: 40)
//                            //                            }.padding(.vertical)
//                            
//                            CustomTextEditor(iconName:"img_group512375",placeholder: "Bank_Transfare_CommentPlaceholder", text: $viewmodel.Comment,charLimit: 1000)
//                                .padding(.horizontal,10)
//                                .padding(.bottom)
//                        }
//                        .background{ ColorConstants.WhiteA700.cornerRadius(10)}
//                        .padding(.horizontal)
//                        
//                        Text("Bank_Transfare_GeneralNote".localized())
//                            .font(.regular(size:14))
//                            .foregroundColor(Color("teacher-tint"))
//                            .multilineTextAlignment(.center)
//                            .padding(.bottom)
//                        
//                        Text("Bank_Transfare_UrgentNote".localized())
//                            .font(.regular(size:14))
//                            .foregroundColor(Color("teacher-tint"))
//                            .multilineTextAlignment(.center)
//                        
//                        Button(action:{
//                            Helper.shared.openChat(phoneNumber: "UrgetWhatsapp_number".localized)
//                        },label:{
//                            HStack{
//                                Image(.whatsappicon)
//                                Text("UrgetWhatsapp_number".localized)
//                                    .font(.regular(size:14))
//                                    .foregroundColor(ColorConstants.Black900)
//                            }
//                        })
//                        
//                        Spacer()
//                        
//                        CustomButton(Title:"Send_Btn",IsDisabled: .constant(viewmodel.documentImg == nil && viewmodel.documentPdf == nil ), action: {
//                            //                            clearDocumentsFilter()
//                            //                                        teacherdocumentsvm.clearFilter()
//                            viewmodel.UploadTransferImage()
//                        })
//                        .frame(height: 50)
//                        .padding(.horizontal)
//                        
//                    }
//                    .frame(minHeight: gr.size.height)
//                }
//            }
//            //            .onAppear(perform: {
//            ////                lookupsvm.GetDocumentTypes()
//            ////                teacherdocumentsvm.GetTeacherDocument()
//            //            })
//            
//            //MARK: -------- imagePicker From Camera and Library ------
//            .confirmationDialog(Text("Choose_File_Type".localized()), isPresented: $isSheetPresented) {
//                Button("Image".localized()) {
//                    //                    selectedFileType = .image
//                    showImageSheet = true
//                    print("upload image")
//                    // Call a function to show an image picker
//                }
//                Button("PDF".localized()) {
//                    //                    selectedFileType = .pdf
//                    startPickingPdf = true
//                    print("upload pdf")
//                    // Call a function to add a PDF document
//                }
//                Button("Cancel".localized(), role: .cancel) { }
//            } message: {Text("What is the file type you will add".localized())}
//            
//            //MARK: -------- imagePicker From Camera and Library ------
//                .confirmationDialog("Choose_Image_From".localized(), isPresented: $showImageSheet) {
//                    Button("photo_Library".localized()) {
//                        self.imagesource = .photoLibrary
//                        self.showImageSheet = false
//                        self.startPickingImage = true
//                    }
//                    Button("Camera".localized()) {
//                        self.imagesource = .camera
//                        self.showImageSheet = false
//                        self.startPickingImage = true
//                    }
//                    Button("Cancel".localized(), role: .cancel) { }
//                } message: {Text("Choose_Image_From".localized())}
//            
//                .sheet(isPresented: $startPickingImage) {
//                    if let sourceType = imagesource {
//                        // Pick an image from the photo library:
//                        ImagePicker(sourceType: sourceType , selectedImage: $viewmodel.documentImg)
//                    }
//                }
//                .fileImporter(isPresented: $startPickingPdf, allowedContentTypes: [.pdf], onCompletion: {result in
//                    switch result {
//                    case .success(let url):
//                        viewmodel.documentPdf = url
//                        
//                    case .failure(let failure):
//                        print("Importer error: \(failure)")
//                    }
//                })
//                .onChange(of: viewmodel.isTransferUploaded){newval in
//                    if newval == true{
//                        destination = AnyView(PaymentStatusView(paymentsuccess: .pending))
//                        isPush = true
//                    }
//                }
//            //                .fullScreenCover(isPresented: $isPreviewPresented, onDismiss: {
//            //                // Optional: Handle actions on closing the preview sheet
//            //            }, content: {
//            //                FilePreviewerSheet(url:$previewurl)
//            //            })
//            
//            //            .fullScreenCover(isPresented: $isFinish, onDismiss: {
//            //                print("dismissed ")
//            //    //            destination = AnyView(SignInView())
//            //    ////            isPush.toggle()
//            //    //            dismiss()
//            //            }, content: {
//            //                CustomSuccessView(action: {
//            //    //                destination = AnyView(SignInView())
//            //                    dismiss()
//            //                }, successStep: .constant(.accountCreated))
//            //        })
//        }
//        .hideNavigationBar()
//        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
//            hideKeyboard()
//        })
//        
//        .showHud(isShowing: $viewmodel.isLoading)
//        .showAlert(hasAlert: $viewmodel.isError, alertType: viewmodel.error)
//        NavigationLink(destination: destination, isActive: $isPush, label: {})
//        
//    }
//}
//
//@available(iOS 16.0, *)
//#Preview{
//    BankTransferView()
//        .environmentObject(BookingCheckoutVM())
//    //        .environmentObject(SignUpViewModel())
//    //        .environmentObject(TeacherDocumentsVM())
//}


//
//  BankTransferView.swift
//  MrS-Cool
//
//  Created by mohamed hammam on 17/08/2025.
//

import SwiftUI

struct BankTransferView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewmodel : BookingCheckoutVM

    @State var isPush = false
    @State var destination = AnyView(EmptyView())

    @State private var isSheetPresented = false
    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .camera
    @State private var startPickingImage = false
    @State private var startPickingPdf = false

    var body: some View {
        VStack {
            CustomTitleBarView(title: "Bank_Transfare_Title")
            GeometryReader { gr in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        Image(.bankTransferQuestionMark)
                            .padding(.top, 8)

                        UploadSection(
                            viewmodel: viewmodel,
                            isSheetPresented: $isSheetPresented,
                            showImageSheet: $showImageSheet,
                            imagesource: $imagesource,
                            startPickingImage: $startPickingImage,
                            startPickingPdf: $startPickingPdf
                        )

                        NotesSection()

                        WhatsAppButton()

                        Spacer()

                        CustomButton(
                            Title:"Send_Btn",
                            IsDisabled: .constant(viewmodel.documentImg == nil && viewmodel.documentPdf == nil)
                        ) {
                            viewmodel.UploadTransferImage()
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            .confirmationDialog("Choose_File_Type".localized(),
                                isPresented: $isSheetPresented) {
                Button("Image".localized()) {
                    showImageSheet = true
                }
                Button("PDF".localized()) {
                    startPickingPdf = true
                }
                Button("Cancel".localized(), role: .cancel) { }
            } message: {
                Text("What is the file type you will add".localized())
            }
            .confirmationDialog("Choose_Image_From".localized(),
                                isPresented: $showImageSheet) {
                Button("photo_Library".localized()) {
                    imagesource = .photoLibrary
                    showImageSheet = false
                    startPickingImage = true
                }
                Button("Camera".localized()) {
                    imagesource = .camera
                    showImageSheet = false
                    startPickingImage = true
                }
                Button("Cancel".localized(), role: .cancel) { }
            } message: {
                Text("Choose_Image_From".localized())
            }
            .sheet(isPresented: $startPickingImage) {
                if let sourceType = imagesource {
                    ImagePicker(sourceType: sourceType, selectedImage: $viewmodel.documentImg)
                }
            }
            .fileImporter(isPresented: $startPickingPdf,
                          allowedContentTypes: [.pdf]) { result in
                switch result {
                case .success(let url):
                    viewmodel.documentPdf = url
                case .failure(let failure):
                    print("Importer error: \(failure)")
                }
            }
            .onChange(of: viewmodel.isTransferUploaded) { newval in
                if newval == true {
                    destination = AnyView(PaymentStatusView(paymentsuccess: .pending))
                    isPush = true
                }
            }
            .onDisappear(){
                viewmodel.ClearTransfer()
            }
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .showHud(isShowing: $viewmodel.isLoading)
        .showAlert(hasAlert: $viewmodel.isError, alertType: viewmodel.error)
        NavigationLink(destination: destination, isActive: $isPush) { }
    }
}

// MARK: - Upload Section
struct UploadSection: View {
    @ObservedObject var viewmodel: BookingCheckoutVM
    @Binding var isSheetPresented: Bool
    @Binding var showImageSheet: Bool
    @Binding var imagesource: UIImagePickerController.SourceType?
    @Binding var startPickingImage: Bool
    @Binding var startPickingPdf: Bool

    var body: some View {
        VStack(spacing: 12) {
            Text("Bank_Transfare_HeadTitle".localized())
                .font(.bold(size:18))
                .foregroundColor(ColorConstants.MainColor)
                .multilineTextAlignment(.center)
                .lineSpacing(5)

            Text("Bank_Transfare_SubTitle".localized())
                .font(.regular(size:14))
                .foregroundColor(Color("teacher-tint"))
                .multilineTextAlignment(.center)
                .lineSpacing(5)

            if viewmodel.documentImg != nil || viewmodel.documentPdf != nil {
                UploadedFileView {
                    viewmodel.documentImg = nil
                    viewmodel.documentPdf = nil
                }
            } else {
                if viewmodel.isdocumentFilevalid == false {
                    Text("File or image not selected".localized())
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity)
                        .font(Font.regular(size: 12))
                        .foregroundColor(ColorConstants.Red400)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                }

                CustomButton(imageName:"img_group_512394",
                             Title: "Bank_Transfare_choose_Btn",
                             IsDisabled: .constant(false)) {
                    hideKeyboard()
                    isSheetPresented = true
                }
                .frame(height: 50)
                .padding(.top)
                .padding(.horizontal,80)

                Text("Files supported: PDF, JPG, PNG,\nTIFF, GIF, WORD\nMaximum size is : 2MB".localized())
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity)
                    .font(Font.regular(size: 12))
                    .foregroundColor(ColorConstants.Gray901)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }

            CustomTextEditor(
                iconName:"img_group512375",
                placeholder: "Bank_Transfare_CommentPlaceholder",
                text: $viewmodel.Comment,
                charLimit: 1000
            )
            .padding(.horizontal,10)
        }
        .padding(.vertical)
        .background { ColorConstants.WhiteA700.cornerRadius(10) }
        .padding(.horizontal)
    }
}

// MARK: - Notes Section
struct NotesSection: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Bank_Transfare_GeneralNote".localized())
                .font(.regular(size:14))
                .foregroundColor(Color("teacher-tint"))
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .lineSpacing(5)
            
            Text("Bank_Transfare_UrgentNote".localized())
                .font(.regular(size:14))
                .foregroundColor(Color("teacher-tint"))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
        }
    }
}

// MARK: - WhatsApp Button
struct WhatsAppButton: View {
    var body: some View {
        Button(action: {
            Helper.shared.openChat(phoneNumber: "UrgetWhatsapp_number".localized)
        }, label: {
            HStack {
                Image(.whatsappicon)
                Text("UrgetWhatsapp_number".localized)
                    .font(.regular(size:14))
                    .foregroundColor(ColorConstants.Black900)
            }
        })
    }
}

// MARK: - Uploaded File View
struct UploadedFileView: View {
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image("img_maskgroup192")
            HStack(alignment:.top, spacing: 10) {
                Button(action: onDelete) {
                    Image("img_group")
                        .resizable()
                        .frame(width: 15, height: 18, alignment: .leading)
                        .aspectRatio(contentMode: .fill)
                }
                Text("Your file uploaded successfully".localized())
                    .font(Font.regular(size:12))
                    .foregroundColor(ColorConstants.Gray900)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top)
        .frame(maxWidth:.infinity)
    }
}

#Preview {
//    BankTransferView()
//        .environmentObject(BookingCheckoutVM())
    
}
