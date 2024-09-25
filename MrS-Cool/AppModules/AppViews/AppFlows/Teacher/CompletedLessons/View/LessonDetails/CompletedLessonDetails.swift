//
//  CompletedLessonDetails.swift
//  MrS-Cool
//
//  Created by wecancity on 13/12/2023.
//

import SwiftUI

struct CompletedLessonDetails: View {
    @EnvironmentObject var completedlessonsvm : CompletedLessonsVM
    @State var showFilter : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Completed Lessons")
            
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack(alignment: .leading){ // (Title - Data - Submit Button)
                        Group{
                            SignUpHeaderTitle(Title: "Subject and Lesson Info")
                            
                            Button(action: {
                                destination =  AnyView(ManageLessonMaterialView(currentLesson: TeacherUnitLesson.init(id: completedlessonsvm.completedLessonDetails?.teacherLessonID))
                                    .environmentObject(LookUpsVM())
                                    .environmentObject(ManageLessonMaterialVM())
                                    
                                )
                                isPush = true
                            }, label: {
                                HStack{
                                    Text("Manage Lesson Materials".localized())
                                        .font(Font.semiBold(size: 11))
                                    Image("img_group_white_a700")
                                        .resizable()
                                        .frame(width: 10, height: 10, alignment: .center)
                                }
                                .padding(.horizontal,5)
                            })
                            .frame(width:180,height:33)
                            .foregroundColor(.white)
                            .background(ColorConstants.MainColor)
                            .cornerRadius(8)
                            
                            Group{
                                Text("Subject".localized())
                                    .font(Font.bold(size: 16))
                                
                                Text(completedlessonsvm.completedLessonDetails?.subjectName ?? "")
                                    .font(Font.bold(size: 18))
                                
                                Text("Subject Brief".localized())
                                    .font(Font.bold(size: 16))
                                
                                Text(completedlessonsvm.completedLessonDetails?.subjectBrief ?? "")
                                    .font(Font.semiBold(size: 13))
                                
                                Text("Lesson".localized())
                                    .font(Font.bold(size: 16))
                                
                                Text(completedlessonsvm.completedLessonDetails?.lessonName ?? "")
                                    .font(Font.semiBold(size: 13))
                                
                                Text("Lesson Brief".localized())
                                    .font(Font.bold(size: 16))

                                Text(completedlessonsvm.completedLessonDetails?.lessonBrief ?? "")
                                    .font(Font.semiBold(size: 13))
                                
                            }
                            .foregroundColor(.mainBlue)
                            
                        }
                        .padding(.top)
                        
                        .padding(.horizontal)
                        
                        SignUpHeaderTitle(Title: "Student / Parent Info")
                            .padding()
                        
                        
                        LazyVGrid(columns: [.init(), .init()]) {
                            ForEach(completedlessonsvm.completedLessonDetails?.teacherCompletedLessonStudentList ?? [], id:\.self) {student in
                                LessonDetailsCell(model: student, studentchatBtnAction: {
                                    destination = AnyView(MessagesListView( selectedLessonId: student.bookSessionDetailID ?? 0 ).environmentObject(ChatListVM()))
                                    isPush = true

                                }, parentchatBtnAction: {
//                                    destination = AnyView(MessagesListView( selectedLessonId: student.parentID ?? 0 ).environmentObject(ChatListVM()))
//                                    isPush = true

                                })
                            }
                        }
                        .padding(.horizontal)
                        
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
        .onAppear(perform: {
            completedlessonsvm.GetCompletedLessonDetails()
        })
        
//        .onDisappear {
//            completedlessonsvm.cleanup()
//        }
        .showHud(isShowing: $completedlessonsvm.isLoading)
        .showAlert(hasAlert: $completedlessonsvm.isError, alertType: completedlessonsvm.error)
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    CompletedLessonDetails()
        .environmentObject(CompletedLessonsVM())
    
}
