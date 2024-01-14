//
//  StudentHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/01/2024.
//

import SwiftUI

struct StudentHomeView: View {
    @StateObject var studenthomevm = StudentHomeVM()

    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    @State var searchText = ""
    
    var body: some View {
        VStack {
                GeometryReader{gr in
                    ScrollView(showsIndicators:false){
                        HStack {
                            Text("Subjects".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            Spacer()
                        }.padding(.top)
                        ScrollView(.horizontal,showsIndicators:false){
                            HStack(spacing:10){
                                ForEach(studenthomevm.StudentSubjects ?? [],id:\.self){subject in
                                    StudentHomeSubjectCell(subject:subject,selectedSubject:$studenthomevm.SelectedStudentSubjects){
                                        
                                    }
                                        .frame(width: gr.size.width/2.7, height: 160)
                                }
                            }.padding(.bottom,10)
                        }

                        HStack {
                            Text("Most Viewed Lessons".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            Spacer()
                        }.padding(.top)
                        ScrollView(.horizontal,showsIndicators:false){
                            HStack(spacing:10){
                                ForEach(studenthomevm.StudentMostViewedLessons ,id:\.self){lesson in
                                    StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostViewedLesson){
                                    }
                                        .frame(width: gr.size.width/2.5, height: 240)
                                }
                            }.padding(.bottom,10)
                        }
                        
                        HStack {
                            Text("Most Booked Lessons".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            Spacer()
                        }.padding(.top)
                        ScrollView(.horizontal,showsIndicators:false){
                            HStack(spacing:10){
                                ForEach(studenthomevm.StudentMostBookedLessons ,id:\.self){lesson in
                                    StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostBookedLesson){
                                    }
                                    .frame(width: gr.size.width/2.5, height: 240)
                                }
                            }.padding(.bottom,10)
                        }
                        
                        HStack {
                            Text("Most Viewed Subjects".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            Spacer()
                        }.padding(.top)
                        ScrollView(.horizontal,showsIndicators:false){
                            HStack(spacing:10){
                                ForEach(studenthomevm.StudentMostViewedSubjects ,id:\.self){subject in
                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostViewedSubject){
                                    }
                                        .frame(width: gr.size.width/2.5, height: 280)
                                }
                            }.padding(.bottom,10)
                        }
                        
                        HStack {
                            Text("Most Booked Subjects".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            Spacer()
                        }.padding(.top)
                        ScrollView(.horizontal,showsIndicators:false){
                            HStack(spacing:10){
                                ForEach(studenthomevm.StudentMostBookedsubjects ,id:\.self){subject in
                                    StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostViewedSubject){
                                    }
                                        .frame(width: gr.size.width/2.5, height: 280)
                                }
                            }.padding(.bottom,10)
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    
                    .task {
                        fetchDataInBackground()
                    }
//                    .onAppear {
//                        fetchDataInBackground()
//                    }
                }
                Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    func fetchDataInBackground() {
        DispatchQueue.global(qos: .background).async {
            // Perform the background task here
            studenthomevm.GetStudentLessons(mostType: .mostviewed)
            studenthomevm.GetStudentLessons(mostType: .mostBooked)

            studenthomevm.GetStudentMostSubjects(mostType: .mostviewed)
            studenthomevm.GetStudentMostSubjects(mostType: .mostBooked)
            
            studenthomevm.GetStudentTeachers(mostType: .mostviewed)
            studenthomevm.GetStudentTeachers(mostType: .topRated)            
        }
    }
}

#Preview{
    StudentHomeView()
}

