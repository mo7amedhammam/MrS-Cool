//
//  TeacherHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 04/12/2023.
//

import SwiftUI

struct teacherscreen: Identifiable{
    var title:String?
    var id:Int?
}

struct TeacherHomeView: View {
    
    @StateObject var lookupsvm = LookUpsVM()
    @StateObject var manageprofilevm = ManageTeacherProfileVM()

    @StateObject var signupvm = SignUpViewModel()
    @StateObject var teacherdocumentsvm = TeacherDocumentsVM()

    @StateObject var manageteachersubjectsvm = ManageTeacherSubjectsVM()

    @StateObject var manageteacherschedualsvm = ManageTeacherSchedualsVM()
    
    @StateObject var groupsforlessonvm = GroupForLessonVM()
    
    @StateObject var subjectgroupvm = ManageSubjectGroupVM()
    
    @StateObject var completedlessonsvm = CompletedLessonsVM()
    
    @StateObject var chatlistvm = ChatListVM()
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    let screens:[teacherscreen] = [
    teacherscreen(title: "Manage Profile",id: 1 ),
    teacherscreen(title: "Manage Documents",id: 2 ),
    teacherscreen(title: "Manage Subjects",id: 3 ),
    teacherscreen(title: "Manage Scheduals",id: 4 ),
    teacherscreen(title: "Manage Group For Lessons",id: 5 ),
    teacherscreen(title: "Manage Subject Groups",id: 6 ),
    teacherscreen(title: "Completed Lessons",id: 7 ),
    teacherscreen(title: "Teacher Calender",id: 8 ),
    teacherscreen(title: "Chat",id: 9 )

    ]
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Teacher Home",hideImage: true)
//            ScrollView{
                List(screens) { screen in
                    Button(action: {
                        guard let screenid = screen.id else {return}
                        if screenid == 1{
                            destination = AnyView(ManageTeacherProfileView().environmentObject(lookupsvm)
                                .environmentObject(manageprofilevm)
//                                .hideNavigationBar()
                            )
                        }else if screenid == 2{
                            destination = AnyView(ManageMyDocumentsView( isFinish: .constant(false))
                                .environmentObject(lookupsvm)
                                .environmentObject(signupvm)
                                .environmentObject(teacherdocumentsvm)
//                                .hideNavigationBar()
                            )
                        }else if screenid == 3{
                            destination = AnyView(ManageTeacherSubjectsView().environmentObject(lookupsvm)
                                .environmentObject(manageteachersubjectsvm)
//                                .hideNavigationBar()
                            )
                        }else if screenid == 4{
                        destination = AnyView(ManageTeacherSchedualsView().environmentObject(lookupsvm)
                            .environmentObject(manageteacherschedualsvm)
//                            .hideNavigationBar()
                        )
                    }else if screenid == 5{
                            destination = AnyView(GroupForLessonView() .environmentObject(lookupsvm)
                                .environmentObject(groupsforlessonvm)
//                                .hideNavigationBar()
                            )
                    }else if screenid == 6{
                            destination = AnyView(ManageSubjectGroupView() .environmentObject(lookupsvm)
                                .environmentObject(subjectgroupvm)
//                                .hideNavigationBar()
                            )
                        }else if screenid == 7{
                            destination = AnyView(CompletedLessonsList() .environmentObject(lookupsvm)
                                .environmentObject(completedlessonsvm)
//                                .hideNavigationBar()
                            )
                    }else if screenid == 8{
//                        destination = AnyView(CalView(calendar: .current)

                        destination = AnyView(CalView1()

//                            .environmentObject(lookupsvm)
//                            .environmentObject(completedlessonsvm)
//                                .hideNavigationBar()
                        )
                    }else if screenid == 9{
                        destination = AnyView(ChatsListView()
//                            .environmentObject(lookupsvm)
                            .environmentObject(chatlistvm)
//                            .environmentObject(StudentTabBarVM())

//                                .hideNavigationBar()
                        )
                    }
                        isPush = true
                    }, label: {
                        HStack {
                            Text(screen.title ?? "")
                                .font(Font.SoraRegular(size: 18))
                                .foregroundColor(ColorConstants.MainColor)
                                .multilineTextAlignment(.leading)
                            .padding(10)
                            Spacer()
                        }
                    })
                    .listRowSpacing(0)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(.vertical,-4)
                    .buttonStyle(.plain)
//                }
            }
//                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            Spacer()
            
            Button(action: {
                Helper.shared.IsLoggedIn(value: false)
                Helper.shared.setSelectedUserType(userType: .Student)
            destination = AnyView(SignInView())
                isPush = true
            }, label: {
                Text("Log Out")
                    .font(Font.SoraRegular(size: 18))
                    .foregroundColor(ColorConstants.Red400)

            })
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview{
    TeacherHomeView()
}
