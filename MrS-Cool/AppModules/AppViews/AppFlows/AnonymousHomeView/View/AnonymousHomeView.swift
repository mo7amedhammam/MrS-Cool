//
//  AnonymousHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/01/2024.
//

import SwiftUI

enum AnonymousDestinations{
    case login
    case signup
}

struct AnonymousHomeView: View {
    //    @EnvironmentObject var tabbarvm : StudentTabBarVM
    @StateObject var lookupsvm = LookUpsVM()
    @StateObject var studenthomevm = StudentHomeVM()
    
    @State var isSearch = false
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    @State var selectedDestination : AnonymousDestinations?
    
    //    @State var searchText = ""
    @State var presentSideMenu = false
    //    @StateObject var localizeHelper = LocalizeHelper.shared
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading){
                    Group{
                        Text("Welcome to Mr Scool".localized())
                    }
                    .font(Font.bold(size: 18))
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
                        KFImageLoader(url:URL(string:  "https://platform.mrscool.app/assets/images/Anonymous/Smart.jpg"),placeholder: Image("Smart-Panner"), shouldRefetch: true)
                        
                        if !isSearch{
                            VStack {
                                HStack {
                                    SignUpHeaderTitle(Title: "Search For Your Subjects", subTitle:"")
                                    Spacer()
                                }
                                
                                CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $studenthomevm.educationType,options:lookupsvm.EducationTypesList)
                                
                                CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $studenthomevm.educationLevel,options:lookupsvm.EducationLevelsList)
                                
                                CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $studenthomevm.academicYear,options:lookupsvm.AcademicYearsList,isvalid:studenthomevm.isacademicYearvalid)
                                
                                CustomDropDownField(iconName:"img_group_512380",placeholder: "ِTerm *", selectedOption: $studenthomevm.term,options:lookupsvm.SemestersList)
                                
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
                                            
                                            let searchselections = "\(studenthomevm.educationType?.Title ?? ""), \(studenthomevm.educationLevel?.Title ?? ""), \(studenthomevm.academicYear?.Title ?? ""), \(studenthomevm.term?.Title ?? "")".removingTrailingComma()
                                            
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
                                                //                                            StudentHomeSubjectCell(subject:subject,selectedSubject:$studenthomevm.SelectedStudentSubjects){
                                                //                                                destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
                                                //                                                isPush = true
                                                //                                            }
                                                
                                                //                                        .frame(width: gr.size.width/2.7, height: 160)
                                                //                                        }
                                                
                                                StudentMostViewedSubjectCell(isSearchCell: isSearch,subject: subject, selectedsubject: $studenthomevm.newSSelectedStudentSubjects){
                                                    destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
                                                    isPush = true
                                                }
                                                
                                                .frame(width: gr.size.width/2.7, height: 160)
                                                
                                            }
                                            Spacer().frame(width:1)
                                            
                                        }
                                        .frame(height: 280)
                                        .padding(.bottom,10)
                                    }
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
                                            destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
                                            isPush = true
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
                            Text("No available most booked teachers yet".localized())
                                .font(Font.regular(size: 15))
                                .foregroundColor(ColorConstants.Bluegray400)
                        }else{
                            //                            ScrollViewRTL(type: .hList){
                            ScrollView(.horizontal,showsIndicators: false){
                                
                                HStack(spacing:10){
                                    Spacer().frame(width:1)
                                    
                                    ForEach(studenthomevm.StudentMostBookedTeachers ,id:\.self){teacher in
                                        StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostBookedTeachers){
                                            destination = AnyView(TeacherInfoView(teacherid: teacher.id ?? 0))
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
                        
                        //                        Text("Most Booked Lessons".localized())
                        //                            .font(Font.bold(size: 18))
                        //                            .foregroundColor(.mainBlue)
                        //                            .padding([.top,.horizontal])
                        //                            .frame(maxWidth:.infinity,alignment: .leading)
                        //                        if studenthomevm.StudentMostBookedLessons == []{
                        ////                            ProgressView()
                        ////                                .frame(width: gr.size.width/2.7, height: 240)
                        //                            Image(.emptyLessons)
                        //                                .frame(width: 100,height: 100)
                        //                                .padding()
                        ////                                .resizable()
                        ////                                .aspectRatio(contentMode: .fit)
                        //                            Text("No available most booked lessons yet".localized())
                        //                                .font(Font.regular(size: 15))
                        //                                .foregroundColor(ColorConstants.Bluegray400)
                        //                        }else{
                        ////                            ScrollViewRTL(type: .hList){
                        //                            ScrollView(.horizontal,showsIndicators: false){
                        //
                        //                                HStack(spacing:10){
                        //                                    Spacer().frame(width:1)
                        //                                    ForEach(studenthomevm.StudentMostBookedLessons ,id:\.self){lesson in
                        //                                        StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostBookedLesson){
                        //                                            guard lesson.availableTeacher ?? 0 > 0 else {return}
                        //                                            destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
                        //                                            isPush = true
                        //
                        //                                        }
                        //                                        .frame(width: gr.size.width/2.5, height: 240)
                        //                                    }
                        //                                    Spacer().frame(width:1)
                        //
                        //                                }
                        //                                .frame(height: 240)
                        //                                .padding(.bottom,10)
                        //                            }
                        //                        }
                        
                        //                        Text("Top Rated Teachers".localized())
                        //                            .font(Font.bold(size: 18))
                        //                            .foregroundColor(.mainBlue)
                        //                            .padding([.top,.horizontal])
                        //                            .frame(maxWidth:.infinity,alignment: .leading)
                        //                        if studenthomevm.StudentMostRatedTeachers == []{
                        ////                            ProgressView()
                        ////                                .frame(width: gr.size.width/2.7, height: 180)
                        //                            Image(.emptyTeachers)
                        //                                .frame(width: 100,height: 100)
                        //                                .padding()
                        ////                                .resizable()
                        ////                                .aspectRatio(contentMode: .fit)
                        //                            Text("No available top rated teachers yet".localized())
                        //                                .font(Font.regular(size: 15))
                        //                                .foregroundColor(ColorConstants.Bluegray400)
                        //                        }else{
                        ////                            ScrollViewRTL(type: .hList){
                        //                            ScrollView(.horizontal,showsIndicators: false){
                        //
                        //                                HStack(spacing:10){
                        //                                    Spacer().frame(width:1)
                        //                                    ForEach(studenthomevm.StudentMostRatedTeachers ,id:\.self){teacher in
                        //                                        StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostRatedTeachers){
                        //                                            destination = AnyView(TeacherInfoView(teacherid: teacher.id ?? 0))
                        //                                            isPush = true
                        //                                        }
                        //                                        .frame(width: gr.size.width/3.8, height: 180)
                        //                                    }
                        //                                    Spacer().frame(width:1)
                        //
                        //                                }
                        //                                .frame(height: 180)
                        //                                .padding(.bottom,10)
                        //                            }
                        //                        }
                        
                        //                        Text("Most Viewed Subjects".localized())
                        //                            .font(Font.bold(size: 18))
                        //                            .foregroundColor(.mainBlue)
                        //                            .padding([.top,.horizontal])
                        //                            .frame(maxWidth:.infinity,alignment: .leading)
                        //
                        //                        if studenthomevm.StudentMostViewedSubjects == []{
                        ////                            ProgressView()
                        ////                                .frame(width: gr.size.width/2.7, height: 280)
                        //                            Image(.emptySubjects)
                        //                                .frame(width: 100,height: 100)
                        //                                .padding()
                        ////                                .resizable()
                        ////                                .aspectRatio(contentMode: .fit)
                        //                            Text("No available most viewed subjects yet".localized())
                        //                                .font(Font.regular(size: 15))
                        //                                .foregroundColor(ColorConstants.Bluegray400)
                        //
                        //                        }else{
                        ////                            ScrollViewRTL(type: .hList){
                        //                            ScrollView(.horizontal,showsIndicators: false){
                        //                                HStack(spacing:10){
                        //                                    Spacer().frame(width:1)
                        //
                        //                                    ForEach(studenthomevm.StudentMostViewedSubjects ,id:\.self){subject in
                        //                                        StudentMostViewedSubjectCell(subject: subject, selectedsubject: $studenthomevm.SelectedStudentMostViewedSubject){
                        //                                            guard subject.teacherCount ?? 0 > 0 else {return}
                        //                                            destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
                        //                                            isPush = true
                        //
                        //                                        }
                        //                                        .frame(width: gr.size.width/2.33, height: 280)
                        //                                    }
                        //                                    Spacer().frame(width:1)
                        //
                        //                                }
                        //                                .frame(height: 280)
                        //                                .padding(.bottom,10)
                        //                            }
                        //                        }
                        
                        //                        Text("Most Viewed Lessons".localized())
                        //                            .font(Font.bold(size: 18))
                        //                            .foregroundColor(.mainBlue)
                        //                            .padding([.top,.horizontal])
                        //                            .frame(maxWidth:.infinity,alignment: .leading)
                        //
                        //                        if studenthomevm.StudentMostViewedLessons == []{
                        ////                            ProgressView()
                        ////                                .frame(width: gr.size.width/2.7, height: 240)
                        //                            Image(.emptyLessons)
                        //                                .frame(width: 100,height: 100)
                        //                                .padding()
                        ////                                .resizable()
                        ////                                .aspectRatio(contentMode: .fit)
                        //                            Text("No available most viewed lessons yet".localized())
                        //                                .font(Font.regular(size: 15))
                        //                                .foregroundColor(ColorConstants.Bluegray400)
                        //
                        //                        }else{
                        ////                            ScrollViewRTL(type: .hList){
                        //                            ScrollView(.horizontal,showsIndicators: false){
                        //                                HStack(spacing:10){
                        //                                    Spacer().frame(width:1)
                        //                                    ForEach(studenthomevm.StudentMostViewedLessons ,id:\.self){lesson in
                        //                                        StudentHomeLessonCell(lesson:lesson,selectedlesson:$studenthomevm.SelectedStudentMostViewedLesson){
                        //                                            guard lesson.availableTeacher ?? 0 > 0 else {return}
                        //                                            destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
                        //                                            isPush = true
                        //
                        //                                        }
                        //                                        .frame(width: gr.size.width/2.5, height: 240)
                        //                                    }
                        //                                    Spacer().frame(width:1)
                        //                                }
                        //                                .frame(height: 240)
                        //                                .padding(.bottom,10)
                        //                            }
                        //                        }
                        
                        //                        Text("Most Viewed Teachers".localized())
                        //                            .font(Font.bold(size: 18))
                        //                            .foregroundColor(.mainBlue)
                        //                            .padding([.top,.horizontal])
                        //                            .frame(maxWidth:.infinity,alignment: .leading)
                        //                        if studenthomevm.StudentMostViewedTeachers == []{
                        ////                            ProgressView()
                        ////                                .frame(width: gr.size.width/2.7, height: 180)
                        //                            Image(.emptyTeachers)
                        //                                .frame(width: 100,height: 100)
                        //                                .padding()
                        ////                                .resizable()
                        ////                                .aspectRatio(contentMode: .fit)
                        //                            Text("No available most viewed teachers yet".localized())
                        //                                .font(Font.regular(size: 15))
                        //                                .foregroundColor(ColorConstants.Bluegray400)
                        //
                        //                        }else{
                        ////                            ScrollViewRTL(type: .hList){
                        //                            ScrollView(.horizontal,showsIndicators: false){
                        //                                HStack(spacing:10){
                        //                                    Spacer().frame(width:1)
                        //
                        //                                    ForEach(studenthomevm.StudentMostViewedTeachers ,id:\.self){teacher in
                        //                                        StudentTopRatedTeachersCell(teacher: teacher, selectedteacher: $studenthomevm.SelectedStudentMostViewedTeachers){
                        //                                            destination = AnyView(TeacherInfoView(teacherid: teacher.id ?? 0))
                        //                                            isPush = true
                        //
                        //                                        }
                        //                                        .frame(width: gr.size.width/3.8, height: 180)
                        //                                    }
                        //                                    Spacer().frame(width:1)
                        //                                }
                        //                                .frame(height: 180)
                        //                                .padding(.bottom,10)
                        //                            }
                        //                        }
                        //
                    }
                    .padding(.top,5)
                    .frame(height:gr.size.height)
                    .task{
                        lookupsvm.GetEducationTypes()
                        lookupsvm.GetSemesters()
                        //                        studenthomevm.getHomeData()
                        
                        //                        let DispatchGroup = DispatchGroup()
                        //                        DispatchGroup.enter()
                        
                        //                        studenthomevm.GetStudentSubjects()
                        
                        //                        DispatchGroup.enter()
                        // Perform the background task here
                        //                        studenthomevm.GetStudentLessons(mostType: .mostviewed)
                        //                        studenthomevm.GetStudentLessons(mostType: .mostBooked)
                        
                        //                        DispatchGroup.enter()
                        //                        studenthomevm.GetStudentMostSubjects(mostType: .mostviewed)
                        studenthomevm.GetStudentMostSubjects(mostType: .mostBooked)
                        //                        await studenthomevm.GetStudentMostSubjects1(mostType: .mostBooked)
                        
                        //                        DispatchGroup.enter()
                        //                        studenthomevm.GetStudentTeachers(mostType: .mostviewed)
                        //                        studenthomevm.GetStudentTeachers(mostType: .topRated)
                        studenthomevm.GetStudentMostBookedTeachers()
                        
                        
                        //                        DispatchGroup.leave()
                        
                        //                        studenthomevm.GetStudentSubjects()
                    }
                    .onDisappear{
                        if !isSearch {
                            studenthomevm.clearsearch()
                        }
                    }
                    
                    .onChange(of: studenthomevm.educationType, perform: { value in
                        lookupsvm.SelectedEducationType = value
                    })
                    .onChange(of: studenthomevm.educationLevel, perform: { value in
                        lookupsvm.SelectedEducationLevel = value
                    })
                    .onChange(of: studenthomevm.academicYear, perform: { value in
                        lookupsvm.SelectedAcademicYear = value
                    })
                    .onChange(of: selectedDestination) {newval in
                        if newval == .login { // sign in
                            
                            destination =                           AnyView(SignInView(hideimage:false))
                            Helper.shared.logout()
                            isPush = true
                            
                        }else if newval == .signup{
                            destination =                           AnyView(SignInView(hideimage:false,skipToSignUp:true))
                            Helper.shared.logout()
                            isPush = true
                        }
                        
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
        .localizeView()
        .overlay(content: {
            SideMenuView()
        })
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    
    @ViewBuilder
    private func SideMenuView() -> some View {
        SideView(isShowing: $presentSideMenu, content: AnyView(AnonymousSideMenuContent(presentSideMenu: $presentSideMenu, selectedDestination: $selectedDestination)), direction: .leading)
            .onDisappear(perform: {
                selectedDestination = nil
            })
    }
    
}

#Preview{
    AnonymousHomeView()
    //        .environmentObject(StudentTabBarVM())
}


struct AnonymousSideMenuContent: View {
    @Binding var presentSideMenu: Bool
    @Binding var selectedDestination: AnonymousDestinations?
    
    var body: some View {
        VStack {
            ScrollView{
                VStack(alignment: .trailing, spacing: 10) {
                    HStack(spacing:20){
                        VStack(alignment:.leading) {
                            Text("Anonymous".localized())
                                .font(.bold(size: 18))
                                .foregroundStyle(.whiteA700)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    SideMenuSectionTitle(title: "Settings")
                    
                    SideMenuButton(image: "MenuSt_signout", title: "Sign In"){
                        selectedDestination = .login // sign out
                        presentSideMenu =  false
                    }
                    SideMenuButton(image: "MenuSt_signout", title: "Sign Up"){
                        selectedDestination = .signup // sign up
                        presentSideMenu =  false
                    }
                    
                    ChangeLanguage()
                    
                }
            }
            
            VStack(alignment:.center){
                //                Spacer()
                HStack {
                    Text("Version:".localized())
                    Text("\(Helper.shared.getAppVersion())")
                }
                //            Text("Build Number: \(Helper.shared.getBuildNumber())")
            }
            .font(.semiBold(size: 12))
            .foregroundStyle(.whiteA700)
            .padding(.bottom)
        }
        .frame(width: UIScreen.main.bounds.width - 80)
        .padding(.top, 55)
        .background{
            Color.mainBlue.opacity(0.95)
        }
        .onDisappear(perform: {
            selectedDestination = nil
        })
    }
}

#Preview{
    SideView(isShowing: .constant(true), content: AnyView(AnonymousSideMenuContent(presentSideMenu: .constant(true), selectedDestination: .constant(nil))), direction: .leading)
}

struct ChangeLanguage: View {
    @StateObject var localizeHelper = LocalizeHelper.shared
    
    var body: some View {
        Button(action: {
            LocalizeHelper.shared.setLanguage(language: localizeHelper.currentLanguage == "en" ? .arabic:.english_us)
            
            Helper.shared.changeRoot(toView: destinationview)
        }, label: {
            HStack{
                Image(localizeHelper.currentLanguage == "en" ? .egyflag : .usaflag)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 25,height: 20)
                Text("English".localized())
                    .font(.bold(size: 13))
                    .foregroundStyle(ColorConstants.WhiteA700)
                Spacer()
            }
            .padding()
        })
    }
    
    @ViewBuilder
    var destinationview: some View{
        switch Helper.shared.getUser()?.roleID ?? 0{
        case 1: // teacher
            TeacherTabBarView()
        case 2: // student
            StudentTabBarView()
        case 3: // parent
            ParentTabBarView()
        case 0: // anon
            AnonymousHomeView()
        default:
            AnonymousHomeView() // Handle any unexpected cases
        }
    }
}
