//
//  imagePickerViewModifier.swift
//  MrS-Cool
//
//  Created by wecancity on 05/08/2024.
//

import SwiftUI
import UIKit

struct ImagePickerModifier: ViewModifier {
    @Binding var selectedImage: UIImage?
    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .photoLibrary
    @State private var startPickingImage = false
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                showImageSheet = true
            }
            .confirmationDialog("Choose_Image_From".localized(), isPresented: $showImageSheet) {
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
            } message: {Text("Choose_Image_From".localized())}
            .sheet(isPresented: $startPickingImage) {
                if let sourceType = imagesource {
                    ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
                }
            }
    }
}

extension View {
    func imagePicker(selectedImage: Binding<UIImage?>) -> some View {
        self.modifier(ImagePickerModifier(selectedImage: selectedImage))
    }
}
