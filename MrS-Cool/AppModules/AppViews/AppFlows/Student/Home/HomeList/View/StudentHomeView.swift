//
//  StudentHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/01/2024.
//

import SwiftUI

enum HomeSubjectCase{
    case anonymous, loggedinStudent
}
//
//struct StudentHomeView: View {
//    @EnvironmentObject var studenthometabbarvm : StudentTabBarVM
//    @EnvironmentObject var studentsignupvm : StudentEditProfileVM
//    
//    @StateObject var studenthomevm = StudentHomeVM()
//    
//    @State var isSearch = false
//    //    @State var destination = AnyView(EmptyView())
//    
//    //    @State var searchText = ""
//    //    @Environment(\.layoutDirection) var layoutDirection
//    
//    var body: some View {
//        GeometryReader{gr in
//            
//            LazyVStack(spacing:0) {
//                ScrollView(showsIndicators:false){
//                    
//                    VStack(alignment:.leading){
//                        Text("Subjects For".localized())
//                            .font(Font.bold(size: 18))
//                            .foregroundColor(.mainBlue)
//                        
//                        Text(studenthomevm.StudentSubjectsM?.academicLevelName ?? "")
//                            .font(Font.regular(size: 13))
//                            .foregroundColor(ColorConstants.Red400)
//                        
//                    }.padding([.top,.horizontal])
//                        .frame(maxWidth:.infinity,alignment: .leading)
//                    if studenthomevm.StudentSubjects == []{
//                        //                        ProgressView()
//                        //                            .frame(width: gr.size.width/2.7, height: 160)
//                        Image(.emptySubjects)
//                            .frame(width: 100,height: 100)
//                            .padding()
//                        //                                .resizable()
//                        //                                .aspectRatio(contentMode: .fit)
//                        Text("No available subjects yet".localized())
//                            .font(Font.regular(size: 15))
//                            .foregroundColor(ColorConstants.Bluegray400)
//                        
//                    }else{
//                        LazyVGrid(columns: [.init(), .init(),.init()]) {
//                            
//                            ForEach(studenthomevm.StudentSubjects ?? [],id:\.self){subject in
//                                StudentHomeSubjectCell(subject:subject,selectedSubject:$studenthomevm.SelectedStudentSubjects
//                                ){
//                                    studenthometabbarvm.destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
//                                    studenthometabbarvm.ispush = true
//                                }
//                                //                                    .frame(width: gr.size.width/2.7, height: 160)
//                            }
//                        }
//                        //                            .frame(height: 160)
//                        .padding(.horizontal)
//                        .padding(.bottom,10)
//                        //                        }
//                    }
//                    
//                    //                    Text("Most Viewed Lessons".localized())
//                    //                        .font(Font.bold(size: 18))
//                    //                        .foregroundColor(.mainBlue)
//                    //                        .padding([.top,.horizontal])
//                    //                        .frame(maxWidth:.infinity,alignment: .leading)
//                    //
//                    //                    if studenthomevm.StudentMostViewedLessons == []{
//                    //                        Image(.emptyLessons)
//                    //                            .frame(width: 100,height: 100)
//                    //                            .padding()
//                    //
//                    //                        Text("No available most viewed lessons yet".localized())
//                    //                            .font(Font.regular(size: 15))
//                    //                            .foregroundColor(ColorConstants.Bluegray400)
//                    //
//                    //                    }else{
//                    ////                        ScrollViewReader {proxy in
//                    ////                        ScrollViewRTL(type: .hList){
//                    //                        ScrollView(.horizontal,showsIndicators: false){
//                    //
//                    ////                                ScrollViewReader { proxy in
//                    //                                    HStack(spacing:10){
//                    //                                        Spacer().frame(width:1)
//                    //                                        ForEach(studenthomevm.StudentMostViewedLessons ,id:\.self){lesson in
//                    //                                            StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostViewedLesson){
//                    //                                                guard lesson.availableTeacher ?? 0 > 0 else {return}
//                    //                                                studenthometabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
//                    //                                                studenthometabbarvm.ispush = true
//                    //                                            }
//                    //                                            .frame(width: gr.size.width/2.5, height: 240)
//                    //                                        }
//                    //                                        Spacer().frame(width:1)
//                    ////                                    }
//                    //                                }
//                    //                                .frame(height: 240)
//                    //                                .padding(.bottom,10)
//                    ////                            }
//                    //                        }
//                    //                    }
//                    
//                    //
//                    //                    Text("Most Booked Lessons".localized())
//                    //                        .font(Font.bold(size: 18))
//                    //                        .foregroundColor(.mainBlue)
//                    //                        .padding([.top,.horizontal])
//                    //                        .frame(maxWidth:.infinity,alignment: .leading)
//                    //
//                    //                    if studenthomevm.StudentMostBookedLessons == []{
//                    //                        Image(.emptyLessons)
//                    //                            .frame(width: 100,height: 100)
//                    //                            .padding()
//                    //                        Text("No available most booked lessons yet".localized())
//                    //                            .font(Font.regular(size: 15))
//                    //                            .foregroundColor(ColorConstants.Bluegray400)
//                    //
//                    //                    }else{
//                    ////                        ScrollViewRTL(type: .hList){
//                    //                        ScrollView(.horizontal,showsIndicators: false){
//                    //
//                    //                           HStack(spacing:10){
//                    //                                Spacer().frame(width:1)
//                    //                                ForEach(studenthomevm.StudentMostBookedLessons ,id:\.self){lesson in
//                    //                                    StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostBookedLesson){
//                    //                                        guard lesson.availableTeacher ?? 0 > 0 else {return}
//                    //                                        studenthometabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
//                    //                                        studenthometabbarvm.ispush = true
//                    //
//                    //                                    }
//                    //                                    .frame(width: gr.size.width/2.5, height: 240)
//                    //                                }
//                    //                                Spacer().frame(width:1)
//                    //
//                    //                            }
//                    ////                           .localizeView()
//                    //                            .frame(height: 240)
//                    //                            .padding(.bottom,10)
//                    //                        }
//                    //                    }
//                    
//                    //                    Text("Most Viewed Subjects".localized())
//                    //                        .font(Font.bold(size: 18))
//                    //                        .foregroundColor(.mainBlue)
//                    //                        .padding([.top,.horizontal])
//                    //                        .frame(maxWidth:.infinity,alignment: .leading)
//                    //
//                    //                    if studenthomevm.StudentMostViewedSubjects == []{
//                    ////                        ProgressView()
//                    ////                            .frame(width: gr.size.width/2.7, height: 280)
//                    //                        Image(.emptySubjects)
//                    //                            .frame(width: 100,height: 100)
//                    //                            .padding()
//                    ////                                .resizable()
//                    ////                                .aspectRatio(contentMode: .fit)
//                    //                        Text("No available most viewed subjects yet".localized())
//                    //                            .font(Font.regular(size: 15))
//                    //                            .foregroundColor(ColorConstants.Bluegray400)
//                    //
//                    //                    }else{
//                    ////                        ScrollViewRTL(type: .hList){
//                    //                        ScrollView(.horizontal,showsIndicators: false){
//                    //
//                    //                            HStack(spacing:10){
//                    //                                Spacer().frame(width:1)
//                    //
//                    //                                ForEach(studenthomevm.StudentMostViewedSubjects ,id:\.self){subject in
//                    //                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostViewedSubject){
//                    //                                        guard subject.teacherCount ?? 0 > 0 else {return}
//                    //                                        studenthometabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
//                    //                                        studenthometabbarvm.ispush = true
//                    //
//                    //                                    }
//                    //                                    .frame(width: gr.size.width/2.33, height: 280)
//                    //                                }
//                    //                                Spacer().frame(width:1)
//                    //
//                    //                            }
//                    //                            .frame(height: 280)
//                    //                            .padding(.bottom,10)
//                    //                        }
//                    //                    }
//                    
//                    Text("Most Booked Subjects".localized())
//                        .font(Font.bold(size: 18))
//                        .foregroundColor(.mainBlue)
//                        .padding([.top,.horizontal])
//                        .frame(maxWidth:.infinity,alignment: .leading)
//                    
//                    if studenthomevm.StudentMostBookedsubjects == []{
//                        //                        ProgressView()
//                        //                            .frame(width: gr.size.width/2.7, height: 280)
//                        Image(.emptySubjects)
//                            .frame(width: 100,height: 100)
//                            .padding()
//                        //                                .resizable()
//                        //                                .aspectRatio(contentMode: .fit)
//                        Text("No available most booked subjects yet".localized())
//                            .font(Font.regular(size: 15))
//                            .foregroundColor(ColorConstants.Bluegray400)
//                        
//                    }else{
//                        //                        ScrollViewRTL(type: .hList){
//                        ScrollView(.horizontal,showsIndicators: false){
//                            
//                            HStack(spacing:10){
//                                Spacer().frame(width:1)
//                                
//                                ForEach(studenthomevm.StudentMostBookedsubjects ,id:\.self){subject in
//                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostBookedSubject){
//                                        guard subject.teacherCount ?? 0 > 0 else {return}
//                                        studenthometabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
//                                        studenthometabbarvm.ispush = true
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
//                    
//                    //                    Text("Most Viewed Teachers".localized())
//                    //                        .font(Font.bold(size: 18))
//                    //                        .foregroundColor(.mainBlue)
//                    //                        .padding([.top,.horizontal])
//                    //                        .frame(maxWidth:.infinity,alignment: .leading)
//                    //
//                    //                    if studenthomevm.StudentMostViewedTeachers == []{
//                    ////                        ProgressView()
//                    ////                            .frame(width: gr.size.width/2.7, height: 180)
//                    //                        Image(.emptyTeachers)
//                    //                            .frame(width: 100,height: 100)
//                    //                            .padding()
//                    ////                                .resizable()
//                    ////                                .aspectRatio(contentMode: .fit)
//                    //                        Text("No available most viewd teachers yet".localized())
//                    //                            .font(Font.regular(size: 15))
//                    //                            .foregroundColor(ColorConstants.Bluegray400)
//                    //
//                    //                    }else{
//                    ////                        ScrollViewRTL(type: .hList){
//                    //                        ScrollView(.horizontal,showsIndicators: false){
//                    //
//                    //                            HStack(spacing:10){
//                    //                                Spacer().frame(width:1)
//                    //
//                    //                                ForEach(studenthomevm.StudentMostViewedTeachers ,id:\.self){teacher in
//                    //                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostViewedTeachers){
//                    //                                        studenthometabbarvm.destination = AnyView(    TeacherInfoView(teacherid: teacher.id ?? 0))
//                    //                                        studenthometabbarvm.ispush = true
//                    //                                    }
//                    //                                    .frame(width: gr.size.width/3.8, height: 180)
//                    //                                }
//                    //                                Spacer().frame(width:1)
//                    //                            }
//                    //                            .frame(height: 180)
//                    //                            .padding(.bottom,10)
//                    //                        }
//                    //                    }
//                    
//                    Text("Most Booked Teachers".localized())
//                        .font(Font.bold(size: 18))
//                        .foregroundColor(.mainBlue)
//                        .padding([.top,.horizontal])
//                        .frame(maxWidth:.infinity,alignment: .leading)
//                    
//                    if studenthomevm.StudentMostBookedTeachers == []{
//                        //                        ProgressView()
//                        //                            .frame(width: gr.size.width/2.7, height: 180)
//                        Image(.emptyTeachers)
//                            .frame(width: 100,height: 100)
//                            .padding()
//                        //                                .resizable()
//                        //                                .aspectRatio(contentMode: .fit)
//                        Text("No available most booked teachers yet".localized())
//                            .font(Font.regular(size: 15))
//                            .foregroundColor(ColorConstants.Bluegray400)
//                        
//                    }else{
//                        //                        ScrollViewRTL(type: .hList){
//                        ScrollView(.horizontal,showsIndicators: false){
//                            
//                            HStack(spacing:10){
//                                Spacer().frame(width:1)
//                                
//                                ForEach(studenthomevm.StudentMostBookedTeachers ,id:\.self){teacher in
//                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostBookedTeachers){
//                                        studenthometabbarvm.destination = AnyView(TeacherInfoView(teacherid: teacher.id ?? 0))
//                                        studenthometabbarvm.ispush = true
//                                    }
//                                    .frame(width: gr.size.width/3.8, height: 180)
//                                }
//                                Spacer().frame(width:1)
//                            }
//                            .frame(height: 180)
//                            .padding(.bottom,10)
//                        }
//                    }
//                    
//                    //                    Text("Top Rated Teachers".localized())
//                    //                        .font(Font.bold(size: 18))
//                    //                        .foregroundColor(.mainBlue)
//                    //                        .padding([.top,.horizontal])
//                    //                        .frame(maxWidth:.infinity,alignment: .leading)
//                    //
//                    //                    if studenthomevm.StudentMostRatedTeachers == []{
//                    ////                        ProgressView()
//                    ////                            .frame(width: gr.size.width/2.7, height: 180)
//                    //                        Image(.emptyTeachers)
//                    //                            .frame(width: 100,height: 100)
//                    //                            .padding()
//                    ////                                .resizable()
//                    ////                                .aspectRatio(contentMode: .fit)
//                    //                        Text("No available top rated teachers yet".localized())
//                    //                            .font(Font.regular(size: 15))
//                    //                            .foregroundColor(ColorConstants.Bluegray400)
//                    //
//                    //                    }else{
//                    ////                        ScrollViewRTL(type: .hList){
//                    //                        ScrollView(.horizontal,showsIndicators: false){
//                    //
//                    //                            HStack(spacing:10){
//                    //                                Spacer().frame(width:1)
//                    //                                ForEach(studenthomevm.StudentMostRatedTeachers ,id:\.self){teacher in
//                    //                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostRatedTeachers){
//                    //                                        studenthometabbarvm.destination = AnyView(    TeacherInfoView(teacherid: teacher.id ?? 0))
//                    //                                        studenthometabbarvm.ispush = true
//                    //                                    }
//                    //                                    .frame(width: gr.size.width/3.8, height: 180)
//                    //                                }
//                    //                                Spacer().frame(width:1)
//                    //
//                    //                            }
//                    //                            .frame(height: 180)
//                    //                            .padding(.bottom,10)
//                    //                        }
//                    //                    }
//                }
//                .frame(height:gr.size.height)
//                .task{
////                    let DispatchGroup = DispatchGroup()
////                    DispatchGroup.enter()
//                    
////                    if Helper.shared.CheckIfLoggedIn(){
////                        studentsignupvm.GetStudentProfile()
////                    }
//                    studenthomevm.clearselections()
//                    guard (Helper.shared.CheckIfLoggedIn() && studenthomevm.academicYear != nil ) || !Helper.shared.CheckIfLoggedIn() else {return}
////                    DispatchGroup.leave()
//                    
////                    DispatchGroup.enter()
//                    studenthomevm.GetStudentSubjects()
////                    DispatchGroup.leave()
//                    
////                    DispatchGroup.enter()
//                    //                    studenthomevm.getHomeData()
//                    
//                    //                        studenthomevm.GetStudentLessons(mostType: .mostviewed)
//                    //                        studenthomevm.GetStudentLessons(mostType: .mostBooked)
//                    
//                    //                        DispatchGroup.enter()
//                    //                        studenthomevm.GetStudentMostSubjects(mostType: .mostviewed)
//                    studenthomevm.GetStudentMostSubjects(mostType: .mostBooked)
//                    //                        await studenthomevm.GetStudentMostSubjects1(mostType: .mostBooked)
//                    
//                    //                        DispatchGroup.enter()
//                    //                        studenthomevm.GetStudentTeachers(mostType: .mostviewed)
//                    //                        studenthomevm.GetStudentTeachers(mostType: .topRated)
//                    studenthomevm.GetStudentMostBookedTeachers()
//                    
////                    DispatchGroup.leave()
////                    
////                    DispatchGroup.notify(queue: .main, execute: {
////                        print("DispatchGroup ended")
////                    })
//                    
//                }
//                .onChange(of: studentsignupvm.academicYear, perform: { value in
////                    let DispatchGroup = DispatchGroup()
////                    DispatchGroup.enter()
//                    
//                    if Helper.shared.CheckIfLoggedIn(){
//                        if let id = value?.id{
//                            print("id",id)
//                            studenthomevm.academicLevelId = id
//                            studenthomevm.GetStudentSubjects()
////                            studenthomevm.getHomeData()
//                            studenthomevm.GetStudentMostSubjects(mostType: .mostBooked)
//                            //                        await studenthomevm.GetStudentMostSubjects1(mostType: .mostBooked)
//                            studenthomevm.GetStudentMostBookedTeachers()
//                        }
//                    }
////                    DispatchGroup.leave()
////                    DispatchGroup.notify(queue: .main, execute: {
////                        print("DispatchGroup ended")
////                    })
//                    
//                })
//                .onDisappear(perform: {
//                    studenthomevm.cleanup()
//                })
//            }
//            .frame(height:gr.size.height)
//        }
//        .hideNavigationBar()
//        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
//            hideKeyboard()
//        })
//        
//        //        NavigationLink(destination: destination, isActive: $isPush, label: {})
//    }
//    
//    
//}


struct StudentHomeView: View {
    @EnvironmentObject var studenthometabbarvm: StudentTabBarVM
    @EnvironmentObject var studentsignupvm: StudentEditProfileVM
    @StateObject var studenthomevm = StudentHomeVM()
    
    var body: some View {
        GeometryReader { gr in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    KFImageLoader(url:URL(string:  "https://platform.mrscool.app/assets/images/Anonymous/Student.jpg"),placeholder: Image("Student-Panner"), shouldRefetch: true)

                    headerSection()
                    subjectsSection(gr: gr)
                    mostBookedSubjectsSection(gr: gr)
                    mostBookedTeachersSection(gr: gr)
                }
                .padding(.top)
                .padding(.horizontal)
                .task {
                    await loadData()
//                    fatalError("Crash was triggered again")
                }
                .onChange(of: studentsignupvm.academicYear) { _ in
                    updateDataForNewAcademicYear()
                }
                .onDisappear {
                    studenthomevm.cleanup()
                }
            }
            .background(ColorConstants.Gray50.ignoresSafeArea())
            .hideNavigationBar()
        }
    }
    
    @ViewBuilder
    private func headerSection() -> some View {
        VStack(alignment: .leading) {
            Text("Subjects For".localized())
                .font(Font.bold(size: 18))
                .foregroundColor(.mainBlue)
                .padding([.horizontal])
                .frame(maxWidth:.infinity,alignment: .leading)
            Text(studenthomevm.StudentSubjectsM?.academicLevelName ?? "")
                .font(Font.regular(size: 13))
                .foregroundColor(ColorConstants.Red400)
        }
        .padding(.top)
    }
    
    @ViewBuilder
    private func subjectsSection(gr: GeometryProxy) -> some View {
        if let subjects = studenthomevm.StudentSubjects, !subjects.isEmpty {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(subjects, id: \.self) { subject in
                    StudentHomeSubjectCell(subject: subject, selectedSubject: $studenthomevm.SelectedStudentSubjects) {
                        studenthometabbarvm.destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
                        studenthometabbarvm.ispush = true
                    }
                }
            }
            .padding(.bottom, 10)
        } else {
            emptyStateView(imageName: "emptySubjects", message: "No available subjects yet")
        }
    }
    
    @ViewBuilder
    private func mostBookedSubjectsSection(gr: GeometryProxy) -> some View {
        sectionHeader("Most Booked Subjects")
        if !studenthomevm.StudentMostBookedsubjects.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(studenthomevm.StudentMostBookedsubjects, id: \.self) { subject in
                        StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostBookedSubject) {
                            studenthometabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
                            studenthometabbarvm.ispush = true
                        }
                        .frame(width: gr.size.width / 2.33, height: 280)
                    }
                }
                .frame(height: 280)
                .padding(.bottom, 10)
            }
        } else {
            emptyStateView(imageName: "emptySubjects", message: "No available most booked subjects yet")
        }
    }
    
    @ViewBuilder
    private func mostBookedTeachersSection(gr: GeometryProxy) -> some View {
        sectionHeader("Most Booked Teachers")
        if !studenthomevm.StudentMostBookedTeachers.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(studenthomevm.StudentMostBookedTeachers, id: \.self) { teacher in
                        StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostBookedTeachers) {
                            studenthometabbarvm.destination = AnyView(TeacherInfoView(teacherid: teacher.id ?? 0))
                            studenthometabbarvm.ispush = true
                        }
                        .frame(width: gr.size.width / 3.8, height: 180)
                    }
                }
                .frame(height: 180)
                .padding(.bottom, 10)
            }
        } else {
            emptyStateView(imageName: "emptyTeachers", message: "No available most booked teachers yet")
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title.localized())
            .font(Font.bold(size: 18))
            .foregroundColor(.mainBlue)
            .padding([.top,.horizontal])
            .frame(maxWidth:.infinity,alignment: .leading)
    }
    
    private func emptyStateView(imageName: String, message: LocalizedStringKey) -> some View {
        VStack {
            Image(imageName)
                .frame(width: 100,height: 100)
                .padding()
            //                                .resizable()
            //                                .aspectRatio(contentMode: .fit)
            Text(message)
                .font(Font.regular(size: 15))
                .foregroundColor(ColorConstants.Bluegray400)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func loadData() async {
        studenthomevm.clearselections()
        updateDataForNewAcademicYear()
        
//        guard Helper.shared.CheckIfLoggedIn(), let id = studentsignupvm.academicYear?.id else { return }
//        studenthomevm.academicLevelId = id

//        guard (Helper.shared.CheckIfLoggedIn() && studenthomevm.academicYear != nil) || !Helper.shared.CheckIfLoggedIn() else { return }
//
//        await studenthomevm.GetStudentSubjects()
//        await studenthomevm.GetStudentMostSubjects(mostType: .mostBooked)
//        await studenthomevm.GetStudentMostBookedTeachers()
    }
    
    private func updateDataForNewAcademicYear() {
        guard Helper.shared.CheckIfLoggedIn(), let id = studentsignupvm.academicYear?.id else { return }
        studenthomevm.academicLevelId = id
        Task {
            await studenthomevm.GetStudentSubjects()
            await studenthomevm.GetStudentMostSubjects(mostType: .mostBooked)
            await studenthomevm.GetStudentMostBookedTeachers()
        }
    }
}




#Preview{
    StudentHomeView()
        .environmentObject(StudentTabBarVM())
        .environmentObject(StudentEditProfileVM())
        .environment(\.layoutDirection, .rightToLeft) // For RTL preview
    
}

