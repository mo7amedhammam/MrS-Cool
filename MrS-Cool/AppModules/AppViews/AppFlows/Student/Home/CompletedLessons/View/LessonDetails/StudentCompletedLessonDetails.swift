////
////  StudentCompletedLessonDetails.swift
////  MrS-Cool
////
////  Created by wecancity on 28/02/2024.
////
//
//import SwiftUI
//
//struct StudentCompletedLessonDetails: View {
//    @EnvironmentObject var completedlessonsvm : StudentCompletedLessonsVM
////    @State var showFilter : Bool = false
//    
////    @State var isPush = false
////    @State var destination = AnyView(EmptyView())
//    @State var previewurl : String = ""
//
//    var body: some View {
//        VStack {
//            CustomTitleBarView(title: "Completed Lessons")
//            
//            GeometryReader { gr in
//                ScrollView(.vertical,showsIndicators: false){
//                    VStack(alignment: .leading){ // (Title - Data - Submit Button)
//                        Group{
//                            SignUpHeaderTitle(Title: "Subject and Lesson Info")
//                            
////                            Button(action: {
////                                destination =  AnyView(ManageLessonMaterialView(currentLesson: TeacherUnitLesson.init(id: completedlessonsvm.completedLessonDetails?.teacherLessonId))
////                                    .environmentObject(LookUpsVM())
////                                    .environmentObject(ManageLessonMaterialVM())
////                                )
////                                isPush = true
////                            }, label: {
////                                HStack{
////                                    Text("Manage Lesson Materials".localized())
////                                        .font(Font.regular(size: 11))
////                                    Image("img_group_white_a700")
////                                        .resizable()
////                                        .frame(width: 10, height: 10, alignment: .center)
////                                }
////                                .padding(.horizontal)
////                            })
////                            .frame(width:180,height:33)
////                            .foregroundColor(.white)
////                            .background(ColorConstants.MainColor)
////                            .cornerRadius(8)
//                            
//                            Group{
//                                Text("Subject".localized())
//                                    .font(Font.bold(size: 16))
//                                
//                                Text(completedlessonsvm.completedLessonDetails?.subjectName ?? "")
//                                    .font(Font.bold(size: 18))
//                                
//                                Text("Subject Brief".localized())
//                                    .font(Font.bold(size: 16))
////                                    .fontWeight(.medium)
//
//                                Text(completedlessonsvm.completedLessonDetails?.subjectBrief ?? "")
//                                    .font(Font.regular(size: 12))
//                                    .fontWeight(.medium)
//                                
//                                Text("Lesson".localized())
//                                    .font(Font.bold(size: 16))
////                                    .fontWeight(.medium)
//
//                                Text(completedlessonsvm.completedLessonDetails?.lessonName ?? "")
//                                    .font(Font.regular(size: 12))
//                                    .fontWeight(.medium)
//                                
//                                Text("Lesson Brief".localized())
//                                    .font(Font.bold(size: 16))
////                                    .fontWeight(.medium)
//
//                                Text(completedlessonsvm.completedLessonDetails?.lessonBrief ?? "")
//                                    .font(Font.regular(size: 12))
//                                    .fontWeight(.medium)
//                                
//                            }
//                            .foregroundColor(.mainBlue)
//                            .lineSpacing(5)
//                        }
//                        .padding(.top)
//                        .padding(.horizontal)
//                        
//                        if let MaterialArr = completedlessonsvm.completedLessonDetails?.teacherLessonMaterials{
//                            SignUpHeaderTitle(Title: "Lessons Materials")
//                                .padding()
//                            
//                            LazyVGrid(columns: [.init(), .init()]) {
//                                ForEach(MaterialArr, id:\.self) {material in
//                                    StudentLessonDetailsCell(model: material, DownloadBtnAction: {
//                                        print("lets download lesson",material.materialUrl ?? 0)
//                                        previewurl = (material.materialUrl ?? "")
//                                        previewurl.openAsURL()
//                                    })
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//                        Spacer()
//                    }
//                    .frame(minHeight: gr.size.height)
//                }
//            }
//            
//        }
//        .hideNavigationBar()
//        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
//            hideKeyboard()
//        })
////        .onDisappear {
//////            completedlessonsvm.cleanup()
////        }
//        .showHud(isShowing: $completedlessonsvm.isLoadingDetails)
//        .showAlert(hasAlert: $completedlessonsvm.isError, alertType: completedlessonsvm.error)
//        
////        NavigationLink(destination: destination, isActive: $isPush, label: {})
//    }
//}
//
//#Preview {
//    StudentCompletedLessonDetails()
//        .environmentObject(StudentCompletedLessonsVM())
//    
//}
//
//
//
////
////  LessonDetailsCell.swift
////  MrS-Cool
////
////  Created by wecancity on 13/12/2023.
////
//
//import SwiftUI
//
//struct StudentLessonDetailsCell: View {
//    var model = StudentCompletedLessonMaterialM()
//    var DownloadBtnAction : (()->())?
//
//    var body: some View {
//        VStack(spacing: 10){
//               
//            Image("downloadmaterial")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 60,height: 60)
//                .clipShape(Circle())
//            
//            Text(model.materialTypeName ?? "")
//                    .font(Font.regular(size:7))
//                    .foregroundColor(.mainBlue)
//                    .fontWeight(.medium)
//
//            Text(model.name ?? "")
//                    .font(Font.semiBold(size: 10))
//                    .fontWeight(.medium)
//                    .foregroundColor(.mainBlue)
//                    .multilineTextAlignment(.leading)
//            
//            Button(action: {
//                    DownloadBtnAction?()
//                }, label: {
//                    Text("Download Files".localized())
//                            .font(Font.regular(size:7))
//                            .foregroundStyle(.whiteA700)
//                })
//                .frame(width:80,height:20)
//                .contentShape(CornersRadious(radius: 12, corners: .allCorners))
//                .background(
//                    Capsule()
//                        .foregroundColor(Color.mainBlue)
//                )
//
//        }
//        .padding(5)
//    //        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
//    //            .stroke(ColorConstants.Bluegray100,
//    //                    lineWidth: 1))
//    //        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
//    //            .fill(ColorConstants.WhiteA700))
//    }
//}
//
//#Preview {
//    StudentLessonDetailsCell()
//}




import SwiftUI

struct StudentCompletedLessonDetails: View {
    @EnvironmentObject var viewModel: StudentCompletedLessonsVM
    @State private var previewUrl: String = ""
    var teacherlessonid : Int 
    
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Completed Lessons")
            
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        SubjectInfoSection(details: viewModel.completedLessonDetails)
                        
//                        if let materials = viewModel.completedLessonDetails?.teacherLessonMaterials {
                            MaterialsSection(materials: viewModel.completedLessonDetails?.teacherLessonMaterials) { url in
                                previewUrl = url
                                previewUrl.openAsURL()
                            }
//                        }
                        
                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .hideNavigationBar()
        .background(
            ColorConstants.Gray50
                .ignoresSafeArea()
                .onTapGesture { hideKeyboard() }
        )
//        .onAppear {
//                  Task {
//                      await fetchLessonDetails()
//                  }
//              }
        .task {
            await fetchLessonDetails()
        }
        .showHud(isShowing: $viewModel.isLoadingDetails)
        .showAlert(hasAlert: $viewModel.isError, alertType: viewModel.error)
    }
    @MainActor
       private func fetchLessonDetails() async {
           viewModel.isLoadingDetails = true // Start the loading animation
           await viewModel.GetCompletedLessonDetails1(teacherlessonid: teacherlessonid)
           viewModel.isLoadingDetails = false // Stop the loading animation
       }
}

// MARK: - Preview
#Preview {
    StudentCompletedLessonDetails(teacherlessonid: 0)
        .environmentObject(StudentCompletedLessonsVM())
}


struct SubjectInfoSection: View {
    let details: StudentCompletedLessonDetailsM?
    
    var body: some View {
        VStack(alignment: .leading) {
            Group{
                SignUpHeaderTitle(Title: "Subject and Lesson Info")
                
                InfoRow(title: "Subject", content: details?.subjectName ?? "",contentfont:.bold(size: 18))
                InfoRow(title: "Subject Brief", content: details?.subjectBrief ?? "")
                InfoRow(title: "Lesson", content: details?.lessonName ?? "")
                InfoRow(title: "Lesson Brief", content: details?.lessonBrief ?? "")
            }              
            .padding(.top)

        }
        .padding(.horizontal)
        .padding(.top)
    }
}

private struct InfoRow: View {
    let title: String
    let content: String
    var contentfont:Font?
    
    var body: some View {
        VStack(alignment: .leading) {
            Group{
                Text(title.localized())
                    .font(.bold(size: 16))
                
                Text(content)
                    .font(contentfont ?? .semiBold(size: 13))
                    .fontWeight(contentfont == nil ? .medium : .bold)
            }
            .lineSpacing(8)
            .padding(.top)

        }
        .foregroundColor(.mainBlue)
    }
}


struct MaterialsSection: View {
    let materials: [StudentCompletedLessonMaterialM]?
    let onDownload: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            SignUpHeaderTitle(Title: "Lessons Materials")
                .padding()
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]) {
                ForEach(materials ?? [], id: \.self) { material in
                    MaterialCell(
                        material: material,
                        onDownload: {
                            if let url = material.materialUrl {
                                onDownload(url)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct MaterialCell: View {
    let material: StudentCompletedLessonMaterialM
    let onDownload: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            MaterialIcon()
            
            MaterialInfo(
                typeName: material.materialTypeName ?? "",
                name: material.name ?? ""
            )
            
            DownloadButton(action: onDownload)
        }
        .padding(5)
    }
}

private struct MaterialIcon: View {
    var body: some View {
        Image("downloadmaterial")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .clipShape(Circle())
    }
}

private struct MaterialInfo: View {
    let typeName: String
    let name: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(typeName)
                .font(.regular(size: 7))
                .foregroundColor(.mainBlue)
                .fontWeight(.medium)
            
            Text(name)
                .font(.semiBold(size: 10))
                .fontWeight(.medium)
                .foregroundColor(.mainBlue)
                .multilineTextAlignment(.leading)
        }
    }
}

private struct DownloadButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Download Files".localized())
                .font(.regular(size: 7))
                .foregroundStyle(.whiteA700)
        }
        .frame(width: 80, height: 20)
        .background(
            Capsule()
                .foregroundColor(.mainBlue)
        )
    }
}
