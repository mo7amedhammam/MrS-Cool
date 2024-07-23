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

struct StudentHomeView: View {
    @EnvironmentObject var studenthometabbarvm : StudentTabBarVM
    @EnvironmentObject var studentsignupvm : StudentEditProfileVM

    @StateObject var studenthomevm = StudentHomeVM()
    
    @State var isSearch = false
    //    @State var destination = AnyView(EmptyView())
    
    //    @State var searchText = ""
    
    var body: some View {
        GeometryReader{gr in
            
            LazyVStack(spacing:0) {
                ScrollView(showsIndicators:false){
                    
                    VStack(alignment:.leading){
                        Text("Subjects For".localized())
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.mainBlue)
                        
                        Text(studenthomevm.StudentSubjectsM?.academicLevelName ?? "")
                            .font(Font.SoraRegular(size: 13))
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
                            .font(Font.SoraRegular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
                        LazyVGrid(columns: [.init(), .init(),.init()]) {
                            
                            ForEach(studenthomevm.StudentSubjects ?? [],id:\.self){subject in
                                StudentHomeSubjectCell(subject:subject,selectedSubject:$studenthomevm.SelectedStudentSubjects
                                ){
                                    studenthometabbarvm.destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
                                    studenthometabbarvm.ispush = true
                                }
                                //                                    .frame(width: gr.size.width/2.7, height: 160)
                            }
                        }
                        //                            .frame(height: 160)
                        .padding(.horizontal)
                        .padding(.bottom,10)
                        //                        }
                    }
                    
                    Text("Most Viewed Lessons".localized())
                        .font(Font.SoraBold(size: 18))
                        .foregroundColor(.mainBlue)
                        .padding([.top,.horizontal])
                        .frame(maxWidth:.infinity,alignment: .leading)
                    
                    if studenthomevm.StudentMostViewedLessons == []{
//                        ProgressView()
//                            .frame(width: gr.size.width/2.7, height: 240)
                        Image(.emptyLessons)
                            .frame(width: 100,height: 100)
                            .padding()
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        Text("No available most viewed lessons yet".localized())
                            .font(Font.SoraRegular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                ForEach(studenthomevm.StudentMostViewedLessons ,id:\.self){lesson in
                                    StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostViewedLesson){
                                        guard lesson.availableTeacher ?? 0 > 0 else {return}
                                        studenthometabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
                                        studenthometabbarvm.ispush = true
                                        
                                    }
                                    .frame(width: gr.size.width/2.5, height: 240)
                                }
                                Spacer().frame(width:1)
                            }
                            .frame(height: 240)
                            .padding(.bottom,10)
                        }
                    }
                    
                    
                    Text("Most Booked Lessons".localized())
                        .font(Font.SoraBold(size: 18))
                        .foregroundColor(.mainBlue)
                        .padding([.top,.horizontal])
                        .frame(maxWidth:.infinity,alignment: .leading)
                    
                    if studenthomevm.StudentMostBookedLessons == []{
//                        ProgressView()
//                            .frame(width: gr.size.width/2.7, height: 240)
                        Image(.emptyLessons)
                            .frame(width: 100,height: 100)
                            .padding()
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        Text("No available most booked lessons yet".localized())
                            .font(Font.SoraRegular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                ForEach(studenthomevm.StudentMostBookedLessons ,id:\.self){lesson in
                                    StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostBookedLesson){
                                        guard lesson.availableTeacher ?? 0 > 0 else {return}
                                        studenthometabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
                                        studenthometabbarvm.ispush = true
                                        
                                    }
                                    .frame(width: gr.size.width/2.5, height: 240)
                                }
                                Spacer().frame(width:1)
                                
                            }
                            .frame(height: 240)
                            .padding(.bottom,10)
                        }
                    }
                    
                    Text("Most Viewed Subjects".localized())
                        .font(Font.SoraBold(size: 18))
                        .foregroundColor(.mainBlue)
                        .padding([.top,.horizontal])
                        .frame(maxWidth:.infinity,alignment: .leading)
                    
                    if studenthomevm.StudentMostViewedSubjects == []{
//                        ProgressView()
//                            .frame(width: gr.size.width/2.7, height: 280)
                        Image(.emptySubjects)
                            .frame(width: 100,height: 100)
                            .padding()
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        Text("No available most viewed subjects yet".localized())
                            .font(Font.SoraRegular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                
                                ForEach(studenthomevm.StudentMostViewedSubjects ,id:\.self){subject in
                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostViewedSubject){
                                        guard subject.teacherCount ?? 0 > 0 else {return}
                                        studenthometabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
                                        studenthometabbarvm.ispush = true
                                        
                                    }
                                    .frame(width: gr.size.width/2.33, height: 280)
                                }
                                Spacer().frame(width:1)
                                
                            }
                            .frame(height: 280)
                            .padding(.bottom,10)
                        }
                    }
                    
                    Text("Most Booked Subjects".localized())
                        .font(Font.SoraBold(size: 18))
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
                            .font(Font.SoraRegular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                
                                ForEach(studenthomevm.StudentMostBookedsubjects ,id:\.self){subject in
                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostBookedSubject){
                                        guard subject.teacherCount ?? 0 > 0 else {return}
                                        studenthometabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
                                        studenthometabbarvm.ispush = true
                                        
                                    }
                                    .frame(width: gr.size.width/2.33, height: 280)
                                }
                                Spacer().frame(width:1)
                                
                            }
                            .frame(height: 280)
                            .padding(.bottom,10)
                        }
                    }
                    
                    Text("Most Viewed Teachers".localized())
                        .font(Font.SoraBold(size: 18))
                        .foregroundColor(.mainBlue)
                        .padding([.top,.horizontal])
                        .frame(maxWidth:.infinity,alignment: .leading)
                    
                    if studenthomevm.StudentMostViewedTeachers == []{
//                        ProgressView()
//                            .frame(width: gr.size.width/2.7, height: 180)
                        Image(.emptyTeachers)
                            .frame(width: 100,height: 100)
                            .padding()
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        Text("No available most viewd teachers yet".localized())
                            .font(Font.SoraRegular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                
                                ForEach(studenthomevm.StudentMostViewedTeachers ,id:\.self){teacher in
                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostViewedTeachers){
                                        studenthometabbarvm.destination = AnyView(    TeacherInfoView(teacherid: teacher.id ?? 0))
                                        studenthometabbarvm.ispush = true
                                    }
                                    .frame(width: gr.size.width/3.8, height: 180)
                                }
                                Spacer().frame(width:1)
                            }
                            .frame(height: 180)
                            .padding(.bottom,10)
                        }
                    }
                    
                    Text("Most Booked Teachers".localized())
                        .font(Font.SoraBold(size: 18))
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
                            .font(Font.SoraRegular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                
                                ForEach(studenthomevm.StudentMostBookedTeachers ,id:\.self){teacher in
                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostBookedTeachers){
                                        studenthometabbarvm.destination = AnyView(TeacherInfoView(teacherid: teacher.id ?? 0))
                                        studenthometabbarvm.ispush = true
                                    }
                                    .frame(width: gr.size.width/3.8, height: 180)
                                }
                                Spacer().frame(width:1)
                            }
                            .frame(height: 180)
                            .padding(.bottom,10)
                        }
                    }
                    
                    Text("Top Rated Teachers".localized())
                        .font(Font.SoraBold(size: 18))
                        .foregroundColor(.mainBlue)
                        .padding([.top,.horizontal])
                        .frame(maxWidth:.infinity,alignment: .leading)
                    
                    if studenthomevm.StudentMostRatedTeachers == []{
//                        ProgressView()
//                            .frame(width: gr.size.width/2.7, height: 180)
                        Image(.emptyTeachers)
                            .frame(width: 100,height: 100)
                            .padding()
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        Text("No available top rated teachers yet".localized())
                            .font(Font.SoraRegular(size: 15))
                            .foregroundColor(ColorConstants.Bluegray400)

                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                ForEach(studenthomevm.StudentMostRatedTeachers ,id:\.self){teacher in
                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostRatedTeachers){
                                        studenthometabbarvm.destination = AnyView(    TeacherInfoView(teacherid: teacher.id ?? 0))
                                        studenthometabbarvm.ispush = true
                                    }
                                    .frame(width: gr.size.width/3.8, height: 180)
                                }
                                Spacer().frame(width:1)
                                
                            }
                            .frame(height: 180)
                            .padding(.bottom,10)
                        }
                    }
                }
                .frame(height:gr.size.height)
                .onAppear{
                    if Helper.shared.CheckIfLoggedIn(){
                        studentsignupvm.GetStudentProfile()
                    }
                    studenthomevm.clearselections()
                    guard (Helper.shared.CheckIfLoggedIn() && studenthomevm.academicYear != nil ) || !Helper.shared.CheckIfLoggedIn() else {return}
                    studenthomevm.GetStudentSubjects()
                    studenthomevm.getHomeData()
                    
                }
                .onChange(of: studentsignupvm.academicYear, perform: { value in
                    if Helper.shared.CheckIfLoggedIn(){
                        if let id = value?.id{
                            print("id",id)
                            studenthomevm.academicLevelId = id
                            studenthomevm.GetStudentSubjects()
                            studenthomevm.getHomeData()
                        }
                    }
                })
            }
            .frame(height:gr.size.height)
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        //        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    
    
}

#Preview{
    StudentHomeView()
        .environmentObject(StudentTabBarVM())
        .environmentObject(StudentEditProfileVM())
}

