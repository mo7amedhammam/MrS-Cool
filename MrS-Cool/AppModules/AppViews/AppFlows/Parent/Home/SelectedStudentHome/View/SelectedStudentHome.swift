//
//  SelectedStudentHome.swift
//  MrS-Cool
//
//  Created by wecancity on 01/04/2024.
//

import SwiftUI

struct SelectedStudentHome: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tabbarvm : StudentTabBarVM

//    @StateObject var tabbarvm = StudentTabBarVM()
    
//    @State private var selectedIndex = 2
//    @State private var selectedDestination : Teacherdestinations?
    
    @StateObject var teacherProfilevm = ManageTeacherProfileVM()
    @StateObject var studenthomevm = StudentHomeVM()
    @EnvironmentObject var listchildrenvm : ListChildrenVM
    @StateObject var studentsignupvm = StudentEditProfileVM()

    //    @StateObject var completedlessonsvm = StudentCompletedLessonsVM()
    //    @StateObject var chatListvm = ChatListVM()
    //    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    @State var presentSideMenu = false
    var body: some View {
        //        NavigationView{
        VStack{
            
//            VStack{
            
                HStack{
                    let imageURL : URL? = URL(string: Constants.baseURL + (Helper.shared.selectedchild?.image ?? "image").reverseSlaches())
                         
                    KFImageLoader(url: imageURL, placeholder: Image("studenticon"))
                //                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                    
                    Text(Helper.shared.selectedchild?.name ?? "")
                        .font(Font.bold(size: 18))
                        .foregroundColor(.whiteA700)
                    
                    Spacer()
                    
                    Button(action:{
                        dismiss()
                        listchildrenvm.selectedChild = nil
                        Helper.shared.selectedchild = nil
                    }){
                        Image("exiticon")
                            .padding(.vertical,15)
                            .padding(.horizontal,10)
                    }
                }
//            }
            .padding([.bottom,.horizontal])
            .background(
                CornersRadious(radius: 10, corners: [.bottomLeft,.bottomRight])
                    .fill(ColorConstants.MainColor)
                    .edgesIgnoringSafeArea(.top)
            )
                        
            GeometryReader{gr in

            LazyVStack(spacing:0) {
                
                ScrollView(showsIndicators:false){
                    KFImageLoader(url:URL(string:  "https://platform.mrscool.app/assets/images/Anonymous/Student.jpg"), placeholder: Image("splashicon1"))

                    VStack(alignment:.leading){
                        Text("Subjects For".localized())
                            .font(Font.bold(size: 18))
                            .foregroundColor(.mainBlue)
                        
                        Text(studenthomevm.StudentSubjectsM?.academicLevelName ?? "")
                            .font(Font.regular(size: 13))
                            .foregroundColor(ColorConstants.Red400)
                        
                    }.padding([.top,.horizontal])
                        .frame(maxWidth:.infinity,alignment: .leading)
                    if studenthomevm.StudentSubjects == []{
//                        ProgressView()
//                            .frame(width: gr.size.width/2.7, height: 160)
                        Image(.emptySubjects)
                            .frame(width: 100,height: 100)
                            .padding()
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        Text("No available subjects yet".localized())
                            .font(Font.regular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
                        LazyVGrid(columns: [.init(), .init(),.init()]) {
                            
                            ForEach(studenthomevm.StudentSubjects ?? [],id:\.self){subject in
                                StudentHomeSubjectCell(subject:subject,selectedSubject:$studenthomevm.SelectedStudentSubjects
                                ){
                                    tabbarvm.destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
                                    tabbarvm.ispush = true
                                }
                                //                                    .frame(width: gr.size.width/2.7, height: 160)
                            }
                        }
                        //                            .frame(height: 160)
                        .padding(.horizontal)
                        .padding(.bottom,10)
                        //                        }
                    }
                    
//                    Text("Most Viewed Lessons".localized())
//                        .font(Font.bold(size: 18))
//                        .foregroundColor(.mainBlue)
//                        .padding([.top,.horizontal])
//                        .frame(maxWidth:.infinity,alignment: .leading)
//                    
//                    if studenthomevm.StudentMostViewedLessons == []{
////                        ProgressView()
////                            .frame(width: gr.size.width/2.7, height: 240)
//                        Image(.emptyLessons)
//                            .frame(width: 100,height: 100)
//                            .padding()
////                                .resizable()
////                                .aspectRatio(contentMode: .fit)
//                        Text("No available most viewed lessons yet".localized())
//                            .font(Font.regular(size: 15))
//                            .foregroundColor(ColorConstants.Bluegray400)
//
//                    }else{
////                        ScrollViewRTL(type: .hList){
//                        ScrollView(.horizontal,showsIndicators: false){
//
//                            HStack(spacing:10){
//                                Spacer().frame(width:1)
//                                ForEach(studenthomevm.StudentMostViewedLessons ,id:\.self){lesson in
//                                    StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostViewedLesson){
//                                        guard lesson.availableTeacher ?? 0 > 0 else {return}
//                                        tabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
//                                        tabbarvm.ispush = true
//                                        
//                                    }
//                                    .frame(width: gr.size.width/2.5, height: 240)
//                                }
//                                Spacer().frame(width:1)
//                            }
//                            .frame(height: 240)
//                            .padding(.bottom,10)
//                        }
//                    }
                    
                    
//                    Text("Most Booked Lessons".localized())
//                        .font(Font.bold(size: 18))
//                        .foregroundColor(.mainBlue)
//                        .padding([.top,.horizontal])
//                        .frame(maxWidth:.infinity,alignment: .leading)
//                    
//                    if studenthomevm.StudentMostBookedLessons == []{
////                        ProgressView()
////                            .frame(width: gr.size.width/2.7, height: 240)
//                        Image(.emptyLessons)
//                            .frame(width: 100,height: 100)
//                            .padding()
////                                .resizable()
////                                .aspectRatio(contentMode: .fit)
//                        Text("No available most booked lessons yet".localized())
//                            .font(Font.regular(size: 15))
//                            .foregroundColor(ColorConstants.Bluegray400)
//
//                    }else{
////                        ScrollViewRTL(type: .hList){
//                        ScrollView(.horizontal,showsIndicators: false){
//
//                            HStack(spacing:10){
//                                Spacer().frame(width:1)
//                                ForEach(studenthomevm.StudentMostBookedLessons ,id:\.self){lesson in
//                                    StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostBookedLesson){
//                                        guard lesson.availableTeacher ?? 0 > 0 else {return}
//                                        tabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
//                                        tabbarvm.ispush = true
//                                        
//                                    }
//                                    .frame(width: gr.size.width/2.5, height: 240)
//                                }
//                                Spacer().frame(width:1)
//                                
//                            }
//                            .frame(height: 240)
//                            .padding(.bottom,10)
//                        }
//                    }
                    
//                    Text("Most Viewed Subjects".localized())
//                        .font(Font.bold(size: 18))
//                        .foregroundColor(.mainBlue)
//                        .padding([.top,.horizontal])
//                        .frame(maxWidth:.infinity,alignment: .leading)
//                    
//                    if studenthomevm.StudentMostViewedSubjects == []{
////                        ProgressView()
////                            .frame(width: gr.size.width/2.7, height: 280)
//                        Image(.emptySubjects)
//                            .frame(width: 100,height: 100)
//                            .padding()
////                                .resizable()
////                                .aspectRatio(contentMode: .fit)
//                        Text("No available most viewed subjects yet".localized())
//                            .font(Font.regular(size: 15))
//                            .foregroundColor(ColorConstants.Bluegray400)
//
//                    }else{
////                        ScrollViewRTL(type: .hList){
//                        ScrollView(.horizontal,showsIndicators: false){
//
//                            HStack(spacing:10){
//                                Spacer().frame(width:1)
//                                
//                                ForEach(studenthomevm.StudentMostViewedSubjects ,id:\.self){subject in
//                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostViewedSubject){
//                                        guard subject.teacherCount ?? 0 > 0 else {return}
//                                        tabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
//                                        tabbarvm.ispush = true
//                                        
//                                    }
//                                    .frame(width: gr.size.width/2.33, height: 280)
//                                }
//                                Spacer().frame(width:1)
//                                
//                            }
//                            .frame(height: 280)
//                            .padding(.bottom,10)
//                        }
//                    }
                    
                    Text("Most Booked Subjects".localized())
                        .font(Font.bold(size: 18))
                        .foregroundColor(.mainBlue)
                        .padding([.top,.horizontal])
                        .frame(maxWidth:.infinity,alignment: .leading)
                    
                    if studenthomevm.StudentMostBookedsubjects == []{
//                        ProgressView()
//                            .frame(width: gr.size.width/2.7, height: 280)
                        Image(.emptySubjects)
                            .frame(width: 100,height: 100)
                            .padding()
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        Text("No available most booked subjects yet".localized())
                            .font(Font.regular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
//                        ScrollViewRTL(type: .hList){
                        ScrollView(.horizontal,showsIndicators: false){

                            HStack(spacing:10){
                                Spacer().frame(width:1)
                                
                                ForEach(studenthomevm.StudentMostBookedsubjects ,id:\.self){subject in
                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostBookedSubject){
                                        guard subject.teacherCount ?? 0 > 0 else {return}
                                        tabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
                                        tabbarvm.ispush = true
                                        
                                    }
                                    .frame(width: gr.size.width/2.33, height: 280)
                                }
                                Spacer().frame(width:1)
                                
                            }
                            .frame(height: 280)
                            .padding(.bottom,10)
                        }
                    }
                    
//                    Text("Most Viewed Teachers".localized())
//                        .font(Font.bold(size: 18))
//                        .foregroundColor(.mainBlue)
//                        .padding([.top,.horizontal])
//                        .frame(maxWidth:.infinity,alignment: .leading)
//                    
//                    if studenthomevm.StudentMostViewedTeachers == []{
////                        ProgressView()
////                            .frame(width: gr.size.width/2.7, height: 180)
//                        Image(.emptyTeachers)
//                            .frame(width: 100,height: 100)
//                            .padding()
////                                .resizable()
////                                .aspectRatio(contentMode: .fit)
//                        Text("No available most viewd teachers yet".localized())
//                            .font(Font.regular(size: 15))
//                            .foregroundColor(ColorConstants.Bluegray400)
//
//                    }else{
////                        ScrollViewRTL(type: .hList){
//                        ScrollView(.horizontal,showsIndicators: false){
//
//                            HStack(spacing:10){
//                                Spacer().frame(width:1)
//                                
//                                ForEach(studenthomevm.StudentMostViewedTeachers ,id:\.self){teacher in
//                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostViewedTeachers){
//                                        tabbarvm.destination = AnyView(    TeacherInfoView(teacherid: teacher.id ?? 0))
//                                        tabbarvm.ispush = true
//                                    }
//                                    .frame(width: gr.size.width/3.8, height: 180)
//                                }
//                                Spacer().frame(width:1)
//                            }
//                            .frame(height: 180)
//                            .padding(.bottom,10)
//                        }
//                    }
                    
                    Text("Most Booked Teachers".localized())
                        .font(Font.bold(size: 18))
                        .foregroundColor(.mainBlue)
                        .padding([.top,.horizontal])
                        .frame(maxWidth:.infinity,alignment: .leading)
                    
                    if studenthomevm.StudentMostBookedTeachers == []{
//                        ProgressView()
//                            .frame(width: gr.size.width/2.7, height: 180)
                        Image(.emptyTeachers)
                            .frame(width: 100,height: 100)
                            .padding()
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        Text("No available most booked teachers yet".localized())
                            .font(Font.regular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
//                        ScrollViewRTL(type: .hList){
                        ScrollView(.horizontal,showsIndicators: false){

                            HStack(spacing:10){
                                Spacer().frame(width:1)
                                
                                ForEach(studenthomevm.StudentMostBookedTeachers ,id:\.self){teacher in
                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostBookedTeachers){
                                        tabbarvm.destination = AnyView(TeacherInfoView(teacherid: teacher.id ?? 0))
                                        tabbarvm.ispush = true
                                    }
                                    .frame(width: gr.size.width/3.8, height: 180)
                                }
                                Spacer().frame(width:1)
                            }
                            .frame(height: 180)
                            .padding(.bottom,10)
                        }
                    }
                    
//                    Text("Top Rated Teachers".localized())
//                        .font(Font.bold(size: 18))
//                        .foregroundColor(.mainBlue)
//                        .padding([.top,.horizontal])
//                        .frame(maxWidth:.infinity,alignment: .leading)
//                    
//                    if studenthomevm.StudentMostRatedTeachers == []{
////                        ProgressView()
////                            .frame(width: gr.size.width/2.7, height: 180)
//                        Image(.emptyTeachers)
//                            .frame(width: 100,height: 100)
//                            .padding()
////                                .resizable()
////                                .aspectRatio(contentMode: .fit)
//                        Text("No available top rated teachers yet".localized())
//                            .font(Font.regular(size: 15))
//                            .foregroundColor(ColorConstants.Bluegray400)
//
//                    }else{
////                        ScrollViewRTL(type: .hList){
//                        ScrollView(.horizontal,showsIndicators: false){
//
//                            HStack(spacing:10){
//                                Spacer().frame(width:1)
//                                ForEach(studenthomevm.StudentMostRatedTeachers ,id:\.self){teacher in
//                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostRatedTeachers){
//                                        tabbarvm.destination = AnyView(    TeacherInfoView(teacherid: teacher.id ?? 0))
//                                        tabbarvm.ispush = true
//                                    }
//                                    .frame(width: gr.size.width/3.8, height: 180)
//                                }
//                                Spacer().frame(width:1)
//                                
//                            }
//                            .frame(height: 180)
//                            .padding(.bottom,10)
//                        }
//                    }
                }
                .frame(height:gr.size.height)

                }
            .frame(height:gr.size.height)
    //            Spacer()
            }
            
//            TeacherHomeView(selectedChild:$listchildrenvm.selectedChild)
            
            Spacer()
//            CustomTabBarView(selectedIndex: $selectedIndex,tabBarItems:tabBarItems)
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onChange(of: tabbarvm.selectedIndex, perform: { value in
            if value == 2 && Helper.shared.getSelectedUserType() == .Parent{
                studentsignupvm.GetStudentProfile()
            }

        })
        
        .onAppear {
            if let id = Helper.shared.selectedchild?.academicYearEducationLevelID{
                studenthomevm.academicLevelId = id
            }
            studenthomevm.clearselections()
//            studenthomevm.getHomeData()
            studenthomevm.GetStudentSubjects()
            studenthomevm.GetStudentMostSubjects(mostType: .mostBooked)
            studenthomevm.GetStudentMostBookedTeachers()
        }
        .onChange(of: studentsignupvm.academicYear, perform: { value in
                if let id = value?.id{
                    print("id",id)
                    Helper.shared.selectedchild?.academicYearEducationLevelID = id
                    studenthomevm.academicLevelId = id
                    studenthomevm.getHomeData()
                }
        })

//        .onChange(of: selectedDestination) {newval in
//            if newval == .editProfile{ //edit Profile
//                tabbarvm.destination = AnyView(ManageTeacherProfileView().environmentObject(teacherProfilevm))
//
//            }else if newval == .documents{
//                tabbarvm.destination = AnyView(ManageMyDocumentsView( isFinish: .constant(false))
//                                               //                        .environmentObject(lookupsvm)
//                                               //                        .environmentObject(signupvm)
//                                               //                        .environmentObject(teacherdocumentsvm)
//                                               //                                .hideNavigationBar()
//                )
//
//            }else if newval == .subjects{
//
//                tabbarvm.destination = AnyView(ManageTeacherSubjectsView()
//                                               //                        .environmentObject(lookupsvm)
//                                               //                        .environmentObject(manageteachersubjectsvm)
//                                               //                                .hideNavigationBar()
//                )
//
//
//            }else if newval == .scheduals{
//
//                tabbarvm.destination = AnyView(ManageTeacherSchedualsView()
//                                               //                        .environmentObject(lookupsvm)
//                                               //                        .environmentObject(manageteacherschedualsvm)
//                                               //                            .hideNavigationBar()
//                )
//
//            }else if newval == .subjectgroup{
//
//                tabbarvm.destination = AnyView(GroupForLessonView()
//                                               //                        .environmentObject(lookupsvm)
//                                               //                        .environmentObject(groupsforlessonvm)
//                                               //                                .hideNavigationBar()
//                )
//            }else if newval == .lessonGroups{
//
//                tabbarvm.destination = AnyView(ManageSubjectGroupView()
//                                               //                        .environmentObject(lookupsvm)
//                                               //                        .environmentObject(subjectgroupvm)
//                                               //                                .hideNavigationBar()
//                )
//
//            }else if newval == .calendar { //calendar
//                tabbarvm.destination = AnyView(CalView1())
//                //                }else if newval == .rates { // rates
//                //                    studenttabbarvm.destination = AnyView(Text("Rates"))
//
//            }else if newval == .rates { //calendar
//                tabbarvm.destination = AnyView(TeacherRatesView())
//
//            }else if newval == .changePassword { // change password
//                tabbarvm.destination = AnyView(ChangePasswordView(hideImage: false).environmentObject(ChangePasswordVM()))
//            }else if newval == .tickets { // tickets
//
//            }else if newval == .signOut { // signout
//                tabbarvm.destination =
//                AnyView(SignInView())
//                Helper.shared.IsLoggedIn(value: false)
//            }
//        }
        //        }
        
//                .showAlert(hasAlert: $tabbarvm.isError, alertType: tabbarvm.error)

//        NavigationLink(destination: tabbarvm.destination, isActive: $tabbarvm.ispush, label: {})
    }
}

#Preview{
    SelectedStudentHome()
        .environmentObject(ListChildrenVM())
        .environmentObject(StudentTabBarVM())
}
