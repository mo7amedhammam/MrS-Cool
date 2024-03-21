//
//  AnonymousHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/01/2024.
//

import SwiftUI

//enum HomeSubjectCase{
//    case anonymous, loggedinStudent
//}

struct AnonymousHomeView: View {
    //    @EnvironmentObject var studenthometabbarvm : StudentTabBarVM
    
    @StateObject var studenthomevm = StudentHomeVM()
    
    @State var isSearch = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    //    @State var searchText = ""
    @State var presentSideMenu = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading){
                    Group{
                        Text("Welcome to Mr Scool".localized())
                    }
                    .font(Font.SoraBold(size: 18))
                    .foregroundColor(.whiteA700)
                    
                }
                
                Spacer()
                Button(action: {
                    presentSideMenu.toggle()
                }, label: {
                    Image("sidemenue")
                        .padding(.vertical,15)
                        .padding(.horizontal,10)
                })
                .background(
                    CornersRadious(radius: 10, corners: [.topLeft,.topRight,.bottomLeft,.bottomRight])
                        .fill(ColorConstants.WhiteA700)
                )
            }
            .padding([.bottom,.horizontal])
            .background(
                CornersRadious(radius: 10, corners: [.bottomLeft,.bottomRight])
                    .fill(.mainBlue)
                    .edgesIgnoringSafeArea(.top)
            )
            
            GeometryReader{gr in
                
                LazyVStack(spacing:0) {
                    ScrollView(showsIndicators:false){
                        
                        if !isSearch{
                            CustomButton(Title:"Search",IsDisabled:.constant(false) , action: {
                                withAnimation{
                                    isSearch = true
                                }
                            })
                            .frame(height: 50)
                            .padding(.top,40)
                            .padding(.horizontal)
                        }
                        
                        if isSearch {
                            VStack{
                                HStack {
                                    Image(Helper.shared.getLanguage() == "en" ? "img_arrowleft":"img_arrowright")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 12.0,
                                               height: 20.0, alignment: .center)
                                        .scaledToFit()
                                        .foregroundColor(ColorConstants.MainColor)
                                        .clipped()
                                        .onTapGesture {
                                            withAnimation{
                                                isSearch = false
                                            }
                                        }
                                        .padding()
                                    Text("Showing Results For".localized())
                                        .font(Font.SoraBold(size: 18))
                                        .foregroundColor(.mainBlue)
                                    Spacer()
                                }.padding([.top,.horizontal])
                                //                        }
                                if studenthomevm.StudentSubjects == []{
                                    ProgressView()
                                        .frame(width: gr.size.width/2.7, height: 160)
                                }else{
                                    LazyVGrid(columns: [.init(), .init(),.init()]) {
                                        
                                        ForEach(studenthomevm.StudentSubjects ?? [],id:\.self){subject in
                                            StudentHomeSubjectCell(subject:subject,selectedSubject:$studenthomevm.SelectedStudentSubjects){
                                                destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
                                                isPush = true
                                            }
                                            //                                    .frame(width: gr.size.width/2.7, height: 160)
                                        }
                                    }
                                    //                            .frame(height: 160)
                                    .padding(.horizontal)
                                    .padding(.bottom,10)
                                    //                        }
                                }
                            }
                            .transition(.move(edge: isSearch ? .trailing : .leading))
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
                                            destination = AnyView(Text("most viewed Lesson details"))
                                            isPush = true
                                            
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
                                            destination = AnyView(Text("most booked lesson details"))
                                            isPush = true
                                            
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
                                            destination = AnyView(Text("most viewed subject details"))
                                            isPush = true
                                            
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
                                            destination = AnyView(Text("most booked subject details"))
                                            isPush = true
                                            
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
                                            destination = AnyView(Text("most viewed teacher details"))
                                            isPush = true
                                            
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
                                            destination = AnyView(Text("top rated teacher details"))
                                            isPush = true
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
        }
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    
    @ViewBuilder
    private func SideMenuView() -> some View {
        SideView(isShowing: $presentSideMenu, content: AnyView(Text("mm"))
                 , direction: .leading)
    }
    
}

#Preview{
    AnonymousHomeView()
    //        .environmentObject(StudentTabBarVM())
}

