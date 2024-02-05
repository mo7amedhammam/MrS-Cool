//
//  StudentHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/01/2024.
//

import SwiftUI

struct StudentHomeView: View {
    @EnvironmentObject var studenthometabbarvm : StudentTabBarVM
    
    @StateObject var studenthomevm = StudentHomeVM()
    
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    
//    @State var searchText = ""
    
    var body: some View {
        GeometryReader{gr in

        LazyVStack(spacing:0) {
                ScrollView(showsIndicators:false){
                    HStack {
                        Text("Subjects".localized())
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.mainBlue)
                        Spacer()
                    }.padding([.top,.horizontal])
                    if studenthomevm.StudentSubjects == []{
                        ProgressView()
                            .frame(width: gr.size.width/2.7, height: 160)
                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                ForEach(studenthomevm.StudentSubjects ?? [],id:\.self){subject in
                                    StudentHomeSubjectCell(subject:subject,selectedSubject:$studenthomevm.SelectedStudentSubjects){
                                        studenthometabbarvm.destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
                                        studenthometabbarvm.ispush = true
                                    }
                                    .frame(width: gr.size.width/2.7, height: 160)
                                }
                                Spacer().frame(width:1)
                            }
                            .frame(height: 160)
                            .padding(.bottom,10)
                        }
                    }
                    HStack {
                        Text("Most Viewed Lessons".localized())
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.mainBlue)
                        Spacer()
                    }.padding([.top,.horizontal])
                    if studenthomevm.StudentMostViewedLessons == []{
                        ProgressView()
                            .frame(width: gr.size.width/2.7, height: 240)
                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                ForEach(studenthomevm.StudentMostViewedLessons ,id:\.self){lesson in
                                    StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostViewedLesson){
                                        studenthometabbarvm.destination = AnyView(Text("most viewed Lesson details"))
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
                    HStack {
                        Text("Most Booked Lessons".localized())
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.mainBlue)
                        Spacer()
                    }.padding([.top,.horizontal])
                    if studenthomevm.StudentMostBookedLessons == []{
                        ProgressView()
                            .frame(width: gr.size.width/2.7, height: 240)
                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                ForEach(studenthomevm.StudentMostBookedLessons ,id:\.self){lesson in
                                    StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostBookedLesson){
                                        studenthometabbarvm.destination = AnyView(Text("most booked lesson details"))
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
                    HStack {
                        Text("Most Viewed Subjects".localized())
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.mainBlue)
                        Spacer()
                    }.padding([.top,.horizontal])
                    
                    if studenthomevm.StudentMostViewedSubjects == []{
                        ProgressView()
                            .frame(width: gr.size.width/2.7, height: 280)
                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                
                                ForEach(studenthomevm.StudentMostViewedSubjects ,id:\.self){subject in
                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostViewedSubject){
                                        studenthometabbarvm.destination = AnyView(Text("most viewed subject details"))
                                        studenthometabbarvm.ispush = true
                                        
                                    }
                                    .frame(width: gr.size.width/2.5, height: 280)
                                }
                                Spacer().frame(width:1)
                                
                            }
                            .frame(height: 280)
                            .padding(.bottom,10)
                        }
                    }
                    HStack {
                        Text("Most Booked Subjects".localized())
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.mainBlue)
                        Spacer()
                    }.padding([.top,.horizontal])
                    
                    if studenthomevm.StudentMostBookedsubjects == []{
                        ProgressView()
                            .frame(width: gr.size.width/2.7, height: 280)
                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                
                                ForEach(studenthomevm.StudentMostBookedsubjects ,id:\.self){subject in
                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostViewedSubject){
                                        studenthometabbarvm.destination = AnyView(Text("most booked subject details"))
                                        studenthometabbarvm.ispush = true
                                        
                                    }
                                    .frame(width: gr.size.width/2.5, height: 280)
                                }
                                Spacer().frame(width:1)
                                
                            }
                            .frame(height: 280)
                            .padding(.bottom,10)
                        }
                    }
                    
                    HStack {
                        Text("Most Viewed Teachers".localized())
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.mainBlue)
                        Spacer()
                    }.padding([.top,.horizontal])
                    if studenthomevm.StudentMostViewedTeachers == []{
                        ProgressView()
                            .frame(width: gr.size.width/2.7, height: 180)
                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                
                                ForEach(studenthomevm.StudentMostViewedTeachers ,id:\.self){teacher in
                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostViewedTeachers){
                                        studenthometabbarvm.destination = AnyView(Text("most viewed teacher details"))
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
                    
                    HStack {
                        Text("Top Rated Teachers".localized())
                            .font(Font.SoraBold(size: 18))
                            .foregroundColor(.mainBlue)
                        Spacer()
                    }.padding([.top,.horizontal])
                    if studenthomevm.StudentMostRatedTeachers == []{
                        ProgressView()
                            .frame(width: gr.size.width/2.7, height: 180)
                    }else{
                        ScrollView(.horizontal,showsIndicators:false){
                            LazyHStack(spacing:10){
                                Spacer().frame(width:1)
                                ForEach(studenthomevm.StudentMostRatedTeachers ,id:\.self){teacher in
                                    StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostRatedTeachers){
                                        studenthometabbarvm.destination = AnyView(Text("top rated teacher details"))
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

                .onAppear {
                    studenthomevm.clearselections()
                }
            }
        .frame(height:gr.size.height)
//            Spacer()
            
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
}

