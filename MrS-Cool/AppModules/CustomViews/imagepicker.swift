
import UIKit
import SwiftUI

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
