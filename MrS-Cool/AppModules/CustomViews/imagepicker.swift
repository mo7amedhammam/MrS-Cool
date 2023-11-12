
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) private var presentationMode
      var sourceType: UIImagePickerController.SourceType = .photoLibrary
      @Binding var selectedImage: UIImage?

      func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

          let imagePicker = UIImagePickerController()
//          imagePicker.allowsEditing = true
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
              if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//              if let pickedImage = info[.editedImage] as? UIImage {
                  guard let data = pickedImage.jpegData(compressionQuality : 0.5), let CompressedImage = UIImage(data: data) else {
                      // compression error
                      return
                  }
                  parent.selectedImage = CompressedImage
              }else{

              }
              parent.presentationMode.wrappedValue.dismiss()
          }
          
          //          MARK: Image -
//          func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//                if let editedImage = info[.editedImage] as? UIImage {
//                    guard let data = editedImage.jpegData(compressionQuality: 0.5), let compressedImage = UIImage(data: data) else {
//                        // Compression error
//                        return
//                    }
//                    // Convert UIImage to Image
//                    let swiftUIImage = Image(uiImage: compressedImage)
//                    parent.selectedImage = swiftUIImage
//                } else {
//                    // Handle other cases or set selectedImage to nil
//                }
//                parent.presentationMode.wrappedValue.dismiss()
//            }

      }
  }
