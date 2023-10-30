//
//  TeacherDocumentDataView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI
import MobileCoreServices // For handling PDF content types

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
    @StateObject var teacherdocumentsvm = TeacherDocumentsVM()
    
    @State var isPush = false
    @State var destination = EmptyView()
    @State private var isSheetPresented = false
    @State private var selectedFileType: fileTypesList = .image // Track the selected file type
    
    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .camera // Track the selected file type
    @State private var startPicking = false

    
//    var imagePickerHelper : ImagePickerHelper?
//    var image:UIImage?
    
//    var pdfPickerHelper : PDFPickerHelper?
//    var pdfURL:URL?
    
    
    
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
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
//                                        showImagePickerMenue()
//                                showImagePicker()
                            }
                            Button("PDF".localized()) {
                                selectedFileType = .pdf
                                print("upload pdf")
                                // Call a function to add a PDF document
//                                        addPdfDocument()
                                showDocumentPicker()
                            }
                            Button("Cancel".localized(), role: .cancel) { }
                        } message: {Text("this is the file type you will add".localized())}
                        
                        
                        //MARK: -------- imagePicker From Camera and Library ------
                        .confirmationDialog("Choose_Image_From".localized(), isPresented: $showImageSheet) {
                            Button("photo_Library".localized()) {
                                self.imagesource = .photoLibrary
                                self.showImageSheet = false
                                self.startPicking = true
                            }
                            Button("Camera".localized()) {
                                self.imagesource = .camera
                                self.showImageSheet = false
                                self.startPicking = true
                            }
                            Button("Cancel".localized(), role: .cancel) { }
                        } message: {Text("Choose_Image_From".localized())}

                            .sheet(isPresented: $startPicking) {
                                    if let sourceType = imagesource {
                                        // Pick an image from the photo library:
                                        ImagePicker(sourceType: sourceType , selectedImage: $teacherdocumentsvm.documentImg)
                                    }
                            }
                        
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
                }
                .frame(minHeight: gr.size.height)
                .padding(.horizontal)
            }
        }
        .onAppear(perform: {
            // Initialize ImagePickerHelper here
//            imagePickerHelper = ImagePickerHelper(viewController: self)
//            pdfPickerHelper = PDFPickerHelper(viewController: self)
            
            lookupsvm.GetDocumentTypes()
        })
        .onChange(of: teacherdocumentsvm.isTeacherHasDocuments, perform: { value in
            teacherdocumentsvm.isTeacherHasDocuments = value
        })
        
    }
    
    
    func showImagePicker() {
        // Call the image picker function here
        // For instance, you can use UIImagePickerController
        print("Image Picker will open")
    }
    
    func showDocumentPicker() {
        // Call the document picker function here
        // For instance, you can use UIDocumentPickerViewController
        let types: [String] = [String(kUTTypePDF)]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.allowsMultipleSelection = false
        // Present the document picker
        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true)
    }
}

#Preview{
    TeacherDocumentDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}



struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) private var presentationMode
      var sourceType: UIImagePickerController.SourceType = .photoLibrary
      @Binding var selectedImage: UIImage?

      func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

          let imagePicker = UIImagePickerController()
          imagePicker.allowsEditing = true
          imagePicker.sourceType = sourceType
          imagePicker.delegate = context.coordinator

          return imagePicker
      }

      func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

      }

      func makeCoordinator() -> Coordinator {
          Coordinator(self)
      }

      final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

          var parent: ImagePicker

          init(_ parent: ImagePicker) {
              self.parent = parent
          }

          func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

  //            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              if let EditedImage = info[.editedImage] as? UIImage {
                  guard let data = EditedImage.jpegData(compressionQuality : 0.5), let CompressedImage = UIImage(data: data) else {
                      // compression error
                      return
                  }
                  parent.selectedImage = CompressedImage
              }else{

              }

              parent.presentationMode.wrappedValue.dismiss()
          }

      }
  }
