//
//  TeacherHomeAsAnonymous.swift
//  MrS-Cool
//
//  Created by wecancity on 10/09/2024.
//
import SwiftUI

//enum AnonymousDestinations{
//    case login
//    case signup
//}

struct TeacherHomeAsAnonymous: View {
    @EnvironmentObject var tabbarvm : StudentTabBarVM
    @StateObject var lookupsvm = LookUpsVM()
    @StateObject var studenthomevm = StudentHomeVM()
    
    @State var isSearch = false
    @StateObject var localizeHelper = LocalizeHelper.shared
    var body: some View {
        VStack {
            GeometryReader{gr in
                VStack(spacing:0){
                    ScrollView(showsIndicators:false){
                        
                        if !isSearch{
                            VStack {
                                HStack {
                                    SignUpHeaderTitle(Title: "Search For Your Subjects", subTitle:"")
                                    Spacer()
                                }
                                
                                CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $studenthomevm.educationType,options:lookupsvm.EducationTypesList)
                                
                                CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $studenthomevm.educationLevel,options:lookupsvm.EducationLevelsList)
                                
                                CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $studenthomevm.academicYear,options:lookupsvm.AcademicYearsList,isvalid:studenthomevm.isacademicYearvalid)
                                
//                                CustomDropDownField(iconName:"img_group_512380",placeholder: "ِTerm *", selectedOption: $studenthomevm.term,options:lookupsvm.SemestersList)
                                
                                CustomButton(Title:"Search",bgColor:Color.mainBlue,IsDisabled:.constant((studenthomevm.academicYear == nil || !studenthomevm.isacademicYearvalid)) , action: {
                                    withAnimation{
                                        studenthomevm.getHomeData()
                                        isSearch = true
                                    }
                                })
                                .frame(height: 50)
                                .padding(.top,10)
                            }
                            .padding()
                            .borderRadius(Color.mainBlue, width: 1, cornerRadius: 8, corners: [.allCorners])
                            .padding(.horizontal)
                            .padding(.top,2)
                            
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
                                                studenthomevm.clearsearch()
                                                studenthomevm.getHomeData()
                                            }
                                        }
                                        .padding()
                                    //                                    Text("Showing Results For".localized())
                                    //                                        .font(Font.bold(size: 18))
                                    //                                        .foregroundColor(.mainBlue)
                                    
                                    SignUpHeaderTitle(Title: "Showing Results For", subTitleView: AnyView(
                                        ZStack{
                                            
//                                            let searchselections = "\(studenthomevm.educationType?.Title ?? ""), \(studenthomevm.educationLevel?.Title ?? ""), \(studenthomevm.academicYear?.Title ?? ""), \(studenthomevm.term?.Title ?? "")".removingTrailingComma()

                                            let searchselections = "\(studenthomevm.educationType?.Title ?? ""), \(studenthomevm.educationLevel?.Title ?? ""), \(studenthomevm.academicYear?.Title ?? "")".removingTrailingComma()

                                            Text(searchselections)
                                                .font(Font.regular(size: 10.0))
                                                .foregroundColor(ColorConstants.Red400)
                                        }
                                    ))
                                    
                                    Spacer()
                                }
                                
                                
                                if studenthomevm.newStudentSubjects == [] || studenthomevm.newStudentSubjects.isEmpty{
                                    //                                    ProgressView()
                                    //                                        .frame(width: gr.size.width/2.7, height: 160)
                                    Image(.emptySubjects)
                                        .frame(width: 100,height: 100)
                                        .padding()
                                    //                                .resizable()
                                    //                                .aspectRatio(contentMode: .fit)
                                    Text("No available subjects yet".localized())
                                        .font(Font.regular(size: 15))
                                        .foregroundColor(ColorConstants.Bluegray400)
                                    
                                }else{
                                    //                                    LazyVGrid(columns: [.init(), .init(),.init()]) {
                                    //                                    ScrollViewRTL(type: .hList){
                                    ScrollView(.horizontal,showsIndicators: false){
                                        
                                        HStack(spacing:10){
                                            Spacer().frame(width:1)
                                            
                                            ForEach(studenthomevm.newStudentSubjects,id:\.self){subject in
                                                
                                                StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.newSSelectedStudentSubjects){
                                                    tabbarvm.destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
                                                    tabbarvm.ispush = true
                                                }
                                                
                                                .frame(width: gr.size.width/2.7, height: 160)
                                                
                                            }
                                            Spacer().frame(width:1)
                                            
                                        }
                                        .frame(height: 280)
                                        .padding(.bottom,10)
                                        
                                    }.localizeView()
                                }
                                
                            }
                            .transition(.move(edge: isSearch ? .trailing : .leading))
                            
                        }
                        
                        
                        Text("Most Booked Subjects".localized())
                            .font(Font.bold(size: 18))
                            .foregroundColor(.mainBlue)
                            .padding([.top,.horizontal])
                            .frame(maxWidth:.infinity,alignment: .leading)
                        
                        if studenthomevm.StudentMostBookedsubjects == []{
                            //                            ProgressView()                                .frame(width: gr.size.width/2.7, height: 280)
                            
                            Image(.emptySubjects)
                                .frame(width: 100,height: 100)
                                .padding()
                            //                                .resizable()
                            //                                .aspectRatio(contentMode: .fit)
                            Text("No available most booked subjects yet".localized())
                                .font(Font.regular(size: 15))
                                .foregroundColor(ColorConstants.Bluegray400)
                            
                        }else{
                            //                            ScrollViewRTL(type: .hList){
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
                        
                        Text("Most Booked Teachers".localized())
                            .font(Font.bold(size: 18))
                            .foregroundColor(.mainBlue)
                            .padding([.top,.horizontal])
                            .frame(maxWidth:.infinity,alignment: .leading)
                        
                        if studenthomevm.StudentMostBookedTeachers == []{
                            //                            ProgressView()
                            //                                .frame(width: gr.size.width/2.7, height: 180)
                            Image(.emptyTeachers)
                                .frame(width: 100,height: 100)
                                .padding()
                            //                                .resizable()
                            //                                .aspectRatio(contentMode: .fit)
                            Text("No available  most booked teachers yet".localized())
                                .font(Font.regular(size: 15))
                                .foregroundColor(ColorConstants.Bluegray400)
                        }else{
                            //                            ScrollViewRTL(type: .hList){
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
                        
                        
                        Text("Most Booked Lessons".localized())
                            .font(Font.bold(size: 18))
                            .foregroundColor(.mainBlue)
                            .padding([.top,.horizontal])
                            .frame(maxWidth:.infinity,alignment: .leading)
                        if studenthomevm.StudentMostBookedLessons == []{
                            //                            ProgressView()
                            //                                .frame(width: gr.size.width/2.7, height: 240)
                            Image(.emptyLessons)
                                .frame(width: 100,height: 100)
                                .padding()
                            //                                .resizable()
                            //                                .aspectRatio(contentMode: .fit)
                            Text("No available  most booked lessons yet".localized())
                                .font(Font.regular(size: 15))
                                .foregroundColor(ColorConstants.Bluegray400)
                        }else{
                            //                            ScrollViewRTL(type: .hList){
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing:10){
                                    Spacer().frame(width:1)
                                    ForEach(studenthomevm.StudentMostBookedLessons ,id:\.self){lesson in
                                        StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostBookedLesson){
                                            guard lesson.availableTeacher ?? 0 > 0 else {return}
                                            tabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
                                            tabbarvm.ispush = true
                                            
                                        }
                                        .frame(width: gr.size.width/2.5, height: 240)
                                    }
                                    Spacer().frame(width:1)
                                    
                                }
                                .frame(height: 240)
                                .padding(.bottom,10)
                            }
                        }
                        
                        Text("Top Rated Teachers".localized())
                            .font(Font.bold(size: 18))
                            .foregroundColor(.mainBlue)
                            .padding([.top,.horizontal])
                            .frame(maxWidth:.infinity,alignment: .leading)
                        if studenthomevm.StudentMostRatedTeachers == []{
                            //                            ProgressView()
                            //                                .frame(width: gr.size.width/2.7, height: 180)
                            Image(.emptyTeachers)
                                .frame(width: 100,height: 100)
                                .padding()
                            //                                .resizable()
                            //                                .aspectRatio(contentMode: .fit)
                            Text("No available top rated teachers yet".localized())
                                .font(Font.regular(size: 15))
                                .foregroundColor(ColorConstants.Bluegray400)
                        }else{
                            //                            ScrollViewRTL(type: .hList){
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing:10){
                                    Spacer().frame(width:1)
                                    ForEach(studenthomevm.StudentMostRatedTeachers ,id:\.self){teacher in
                                        StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostRatedTeachers){
                                            tabbarvm.destination = AnyView(    TeacherInfoView(teacherid: teacher.id ?? 0))
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
                        
                        
                        Text("Most Viewed Subjects".localized())
                            .font(Font.bold(size: 18))
                            .foregroundColor(.mainBlue)
                            .padding([.top,.horizontal])
                            .frame(maxWidth:.infinity,alignment: .leading)
                        
                        if studenthomevm.StudentMostViewedSubjects == []{
                            //                            ProgressView()
                            //                                .frame(width: gr.size.width/2.7, height: 280)
                            Image(.emptySubjects)
                                .frame(width: 100,height: 100)
                                .padding()
                            //                                .resizable()
                            //                                .aspectRatio(contentMode: .fit)
                            Text("No available most viewed subjects yet".localized())
                                .font(Font.regular(size: 15))
                                .foregroundColor(ColorConstants.Bluegray400)
                            
                        }else{
                            //                            ScrollViewRTL(type: .hList){
                            ScrollView(.horizontal,showsIndicators: false){
                                
                                HStack(spacing:10){
                                    Spacer().frame(width:1)
                                    
                                    ForEach(studenthomevm.StudentMostViewedSubjects ,id:\.self){subject in
                                        StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostViewedSubject){
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
                        
                        Text("Most Viewed Lessons".localized())
                            .font(Font.bold(size: 18))
                            .foregroundColor(.mainBlue)
                            .padding([.top,.horizontal])
                            .frame(maxWidth:.infinity,alignment: .leading)
                        
                        if studenthomevm.StudentMostViewedLessons == []{
                            //                            ProgressView()
                            //                                .frame(width: gr.size.width/2.7, height: 240)
                            Image(.emptyLessons)
                                .frame(width: 100,height: 100)
                                .padding()
                            //                                .resizable()
                            //                                .aspectRatio(contentMode: .fit)
                            Text("No available most viewed lessons yet".localized())
                                .font(Font.regular(size: 15))
                                .foregroundColor(ColorConstants.Bluegray400)
                            
                        }else{
                            //                            ScrollViewRTL(type: .hList){
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing:10){
                                    Spacer().frame(width:1)
                                    ForEach(studenthomevm.StudentMostViewedLessons ,id:\.self){lesson in
                                        StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostViewedLesson){
                                            guard lesson.availableTeacher ?? 0 > 0 else {return}
                                            tabbarvm.destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
                                            tabbarvm.ispush = true
                                            
                                        }
                                        .frame(width: gr.size.width/2.5, height: 240)
                                    }
                                    Spacer().frame(width:1)
                                }
                                .frame(height: 240)
                                .padding(.bottom,10)
                            }
                        }
                        
                        Text("Most Viewed Teachers".localized())
                            .font(Font.bold(size: 18))
                            .foregroundColor(.mainBlue)
                            .padding([.top,.horizontal])
                            .frame(maxWidth:.infinity,alignment: .leading)
                        if studenthomevm.StudentMostViewedTeachers == []{
                            //                            ProgressView()
                            //                                .frame(width: gr.size.width/2.7, height: 180)
                            Image(.emptyTeachers)
                                .frame(width: 100,height: 100)
                                .padding()
                            //                                .resizable()
                            //                                .aspectRatio(contentMode: .fit)
                            Text("No available most viewed teachers yet".localized())
                                .font(Font.regular(size: 15))
                                .foregroundColor(ColorConstants.Bluegray400)
                            
                        }else{
                            //                            ScrollViewRTL(type: .hList){
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing:10){
                                    Spacer().frame(width:1)
                                    ForEach(studenthomevm.StudentMostViewedTeachers ,id:\.self){teacher in
                                        StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostViewedTeachers){
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
                    }
                    .padding(.top,5)
                    
                    .frame(height:gr.size.height)
                    .onAppear {
                        lookupsvm.GetEducationTypes()
                        lookupsvm.GetSemesters()
                        studenthomevm.getHomeData()
                        //                        studenthomevm.GetStudentSubjects()
                    }
                    .onDisappear{
                        if !isSearch {
                            studenthomevm.clearsearch()
                        }
                        studenthomevm.cleanup()
                    }
                    .onChange(of: localizeHelper.currentLanguage, perform: {_ in
                        lookupsvm.GetEducationTypes()
                        lookupsvm.GetSemesters()
                        studenthomevm.getHomeData()
                    })
                    
                    .onChange(of: studenthomevm.educationType, perform: { value in
                        lookupsvm.SelectedEducationType = value
                    })
                    .onChange(of: studenthomevm.educationLevel, perform: { value in
                        lookupsvm.SelectedEducationLevel = value
                    })
                    .onChange(of: studenthomevm.academicYear, perform: { value in
                        lookupsvm.SelectedAcademicYear = value
                    })
                }
                .frame(height:gr.size.height)
                //            Spacer()
            }
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
        }
    }
    
}

#Preview{
    AnonymousHomeView()
        .environmentObject(StudentTabBarVM())
}
