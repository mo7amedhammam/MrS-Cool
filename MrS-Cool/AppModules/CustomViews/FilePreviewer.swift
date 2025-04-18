//
//  FilePreviewer.swift
//  MrS-Cool
//
//  Created by wecancity on 31/10/2023.
//

import SwiftUI
import PDFKit

struct FilePreviewerSheet: View {
    @Environment(\.presentationMode) var presentationMode
   @Binding var url: String
    
    var body: some View {
        ZStack{
            let url = url.reverseSlaches()
            
                if url.hasSuffix(".pdf") {
                    
                    // Display PDF view
                    if let url = URL(string: url){
                        PDFViewer(url: url)
                    }
                } else if url.hasSuffix(".jpg") || url.hasSuffix(".jpeg") || url.hasSuffix(".png") {
                    // Display image view
                    if let imageURL = URL(string: url) {
                        ImageView(url: imageURL)
                        
                    } else {
                        Text("Invalid Image URL".localized)
                    }
                    
                } else {
                    Text("Unsupported file type".localized)
                    
//                    Button(action: {
//                        if let url = URL(string: url) {
//                            UIApplication.shared.open(url)
//                        }
//                    }) {
//                        Text("Open in Safari")
//                    }

                }
        }
        .frame(maxWidth: UIScreen.main.bounds.width,maxHeight: UIScreen.main.bounds.height)
        .background{ ColorConstants.WhiteA700}
        .onAppear(perform: {
            print("final url:",url.reverseSlaches())
        })
        .overlay(closeButton, alignment: .topTrailing)

    }
    
    var closeButton: some View {
           VStack {
               HStack {
                   Button(action: {
                       presentationMode.wrappedValue.dismiss()
                   }) {
                       Image(systemName: "xmark")
                           .padding(7)
                           .font(.system(size: 22))
                           .foregroundStyle(ColorConstants.WhiteA700)
                   }
                   .background{
                       Color.black.opacity(0.2)
                           .clipShape(.circle)
                   }
                   
                   Spacer()
               }
               .padding(.top, 5)
               Spacer()
           }
       }
}
#Preview{
    Group{
        FilePreviewerSheet(url: .constant("https://mrscoolapi.azurewebsites.net/Images//Teacher//f90a317d-5e3d-4674-b450-de34335d4715.jpeg"))
//        FilePreviewerSheet(url: .constant("https://mrscoolapi.azurewebsites.net/Images//TeacherDocument//36ca43e4-eede-4d67-a5e4-8c926d6ec35d.pdf"))
        
    }

}



struct PDFViewer: View {
    var url: URL
    
    @State private var pdfDocument: PDFDocument?
    
    var body: some View {
        if let pdfDocument = pdfDocument {
            PDFKitView(document: pdfDocument)
        } else {
            ProgressView()
                .onAppear {
                    DispatchQueue.global().async {
                        if let document = PDFDocument(url: url) {
                            DispatchQueue.main.async {
                                pdfDocument = document
                            }
                        }
                    }
                }
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct ImageView: View {
    var url: URL?
    @GestureState private var scale: CGFloat = 1.0
    @GestureState private var dragOffset: CGSize = .zero
    @State private var currentScale: CGFloat = 1.0
    @State private var position: CGSize = .zero
    @State private var initialPosition: CGSize = .zero
    
    var body: some View {
        
//        if let imageURL = url {
                    KFImageLoader(url: url, placeholder: Image("img_younghappysmi"))
            .aspectRatio(contentMode: .fit)
                .scaleEffect(scale * currentScale)
                .offset(position)
                .gesture(
                MagnificationGesture()
                    .updating($scale) { value, scale, _ in
                        scale = value
                    }
                    .onEnded { value in
                        currentScale *= value
                        if currentScale < 1.0 {
                            currentScale = 1.0
                        }
                    }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if currentScale > 1.0 {
                            let newPosition = CGSize(
                                width: initialPosition.width + value.translation.width,
                                height: initialPosition.height + value.translation.height
                            )
                            position = constrainedPosition(for: newPosition)
                        }
                    }
                    .onEnded { value in
                        if currentScale > 1.0 {
                            initialPosition = position
                        }
                    }
            )

            
//            AsyncImage(url: imageURL) { phase in
//                switch phase {
//                case .empty:
//                    // Placeholder view while loading
//                    ProgressView()
//                case .success(let image):
//                    // Display the loaded image
//                    image
//                        .resizable()
//                        .background(.ultraThinMaterial)
//                        .aspectRatio(contentMode: .fill)
//                        .scaleEffect(scale * currentScale)
//                        .offset(position)
//                        .gesture(
//                            MagnificationGesture()
//                                .updating($scale) { value, scale, _ in
//                                    scale = value
//                                }
//                                .onEnded { value in
//                                    currentScale *= value
//                                    if currentScale < 1.0 {
//                                        currentScale = 1.0
//                                    }
//                                }
//                        )
//                        .gesture(
//                            DragGesture()
//                                .onChanged { value in
//                                    if currentScale > 1.0 {
//                                        let newPosition = CGSize(
//                                            width: initialPosition.width + value.translation.width,
//                                            height: initialPosition.height + value.translation.height
//                                        )
//                                        position = constrainedPosition(for: newPosition)
//                                    }
//                                }
//                                .onEnded { value in
//                                    if currentScale > 1.0 {
//                                        initialPosition = position
//                                    }
//                                }
//                        )
//                case .failure(let error):
//                    Text("Failed to load image"+error.localizedDescription)
//
//                @unknown default:
//                    // Handle other cases (optional)
//                    Text("Failed to load image")
//                }
//            }
//        } else {
//            Text("Invalid Image URL")
//        }
    }
    
    
    private func constrainedPosition(for newPosition: CGSize) -> CGSize {
        // Adjust these values to match the image's actual size
        let imageSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        let scaledImageSize = CGSize(width: imageSize.width * currentScale, height: imageSize.height * currentScale)
        let xInset = max((scaledImageSize.width - imageSize.width) / 2, 0)
        let yInset = max((scaledImageSize.height - imageSize.height) / 2, 0)
        
        let minX = -xInset
        let minY = -yInset
        let maxX = (imageSize.width * currentScale) - xInset
        let maxY = (imageSize.height * currentScale) - yInset
        
        let x = max(minX, min(newPosition.width, maxX))
        let y = max(minY, min(newPosition.height, maxY))
        return CGSize(width: x, height: y)
    }
}
