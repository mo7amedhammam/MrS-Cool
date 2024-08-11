//
//  StudentCompletedLessonDetails.swift
//  MrS-Cool
//
//  Created by wecancity on 28/02/2024.
//

import SwiftUI

struct StudentCompletedLessonDetails: View {
    @EnvironmentObject var completedlessonsvm : StudentCompletedLessonsVM
//    @State var showFilter : Bool = false
    
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    @State var previewurl : String = ""

    var body: some View {
        VStack {
            CustomTitleBarView(title: "Completed Lessons")
            
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack(alignment: .leading){ // (Title - Data - Submit Button)
                        Group{
                            SignUpHeaderTitle(Title: "Subject and Lesson Info")
                            
//                            Button(action: {
//                                destination =  AnyView(ManageLessonMaterialView(currentLesson: TeacherUnitLesson.init(id: completedlessonsvm.completedLessonDetails?.teacherLessonId))
//                                    .environmentObject(LookUpsVM())
//                                    .environmentObject(ManageLessonMaterialVM())
//                                )
//                                isPush = true
//                            }, label: {
//                                HStack{
//                                    Text("Manage Lesson Materials".localized())
//                                        .font(Font.SoraRegular(size: 11))
//                                    Image("img_group_white_a700")
//                                        .resizable()
//                                        .frame(width: 10, height: 10, alignment: .center)
//                                }
//                                .padding(.horizontal)
//                            })
//                            .frame(width:180,height:33)
//                            .foregroundColor(.white)
//                            .background(ColorConstants.MainColor)
//                            .cornerRadius(8)
                            
                            Group{
                                Text("Subject".localized())
                                    .font(Font.SoraBold(size: 16))
                                
                                Text(completedlessonsvm.completedLessonDetails?.subjectName ?? "")
                                    .font(Font.SoraBold(size: 18))
                                
                                Text("Subject Brief".localized())
                                    .font(Font.SoraBold(size: 16))
                                
                                Text(completedlessonsvm.completedLessonDetails?.subjectBrief ?? "")
                                    .font(Font.SoraRegular(size: 12))
                                
                                Text("Lesson".localized())
                                    .font(Font.SoraSemiBold(size: 16))
                                
                                Text(completedlessonsvm.completedLessonDetails?.lessonName ?? "")
                                    .font(Font.SoraRegular(size: 12))
                                
                                Text("Lesson Brief".localized())
                                    .font(Font.SoraSemiBold(size: 16))
                                
                                Text(completedlessonsvm.completedLessonDetails?.lessonBrief ?? "")
                                    .font(Font.SoraRegular(size: 12))
                                
                            }
                            .foregroundColor(.mainBlue)
                            
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        
                        if let MaterialArr = completedlessonsvm.completedLessonDetails?.teacherLessonMaterials{
                            SignUpHeaderTitle(Title: "Lessons Materials")
                                .padding()
                            
                            LazyVGrid(columns: [.init(), .init()]) {
                                ForEach(MaterialArr, id:\.self) {material in
                                    StudentLessonDetailsCell(model: material, DownloadBtnAction: {
                                        print("lets download lesson",material.materialUrl ?? 0)
                                        previewurl = (material.materialUrl ?? "")
                                        previewurl.openAsURL()
                                    })
                                }
                            }
                            .padding(.horizontal)
                        }
                        Spacer()
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        .onDisappear {
//            completedlessonsvm.cleanup()
        }
        .showHud(isShowing: $completedlessonsvm.isLoading)
        .showAlert(hasAlert: $completedlessonsvm.isError, alertType: completedlessonsvm.error)
        
//        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    StudentCompletedLessonDetails()
        .environmentObject(StudentCompletedLessonsVM())
    
}



//
//  LessonDetailsCell.swift
//  MrS-Cool
//
//  Created by wecancity on 13/12/2023.
//

import SwiftUI

struct StudentLessonDetailsCell: View {
    var model = StudentCompletedLessonMaterialM()
    var DownloadBtnAction : (()->())?

    var body: some View {
        VStack(spacing: 10){
               
            Image("downloadmaterial")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60,height: 60)
                .clipShape(Circle())
            
            Text(model.materialTypeName ?? "")
                    .font(Font.SoraRegular(size:7))
                    .foregroundColor(.mainBlue)

            Text(model.name ?? "")
                    .font(Font.SoraSemiBold(size: 10))
                    .foregroundColor(.mainBlue)
                    .multilineTextAlignment(.leading)
            
            Button(action: {
                    DownloadBtnAction?()
                }, label: {
                    Text("Download Files".localized())
                            .font(Font.SoraRegular(size:7))
                            .foregroundStyle(.whiteA700)
                })
                .frame(width:80,height:20)
                .contentShape(CornersRadious(radius: 12, corners: .allCorners))
                .background(
                    Capsule()
                        .foregroundColor(Color.mainBlue)
                )

        }
        .padding(5)
    //        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
    //            .stroke(ColorConstants.Bluegray100,
    //                    lineWidth: 1))
    //        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
    //            .fill(ColorConstants.WhiteA700))
    }
}

#Preview {
    StudentLessonDetailsCell()
}
