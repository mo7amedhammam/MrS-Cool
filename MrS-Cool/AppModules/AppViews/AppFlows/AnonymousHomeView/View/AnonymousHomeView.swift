//
//  AnonymousHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/01/2024.
//

import SwiftUI

enum AnonymousDestinations{
    case login
}

struct AnonymousHomeView: View {
    //    @EnvironmentObject var studenthometabbarvm : StudentTabBarVM
    @StateObject var lookupsvm = LookUpsVM()
    @StateObject var studenthomevm = StudentHomeVM()
    
    @State var isSearch = false
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    @State var selectedDestination : AnonymousDestinations?

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
                            VStack {
                                
                                HStack {
                                    SignUpHeaderTitle(Title: "Search For Your Subjects", subTitle:"")
                                    Spacer()
                                }
                                
                                
                                CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $studenthomevm.educationType,options:lookupsvm.EducationTypesList)
                                
                                CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $studenthomevm.educationLevel,options:lookupsvm.EducationLevelsList)
                                
                                CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $studenthomevm.academicYear,options:lookupsvm.AcademicYearsList)
                                
                                CustomDropDownField(iconName:"img_group_512380",placeholder: "ِTerm *", selectedOption: $studenthomevm.term,options:lookupsvm.SemestersList)
                                
                                CustomButton(Title:"Search",bgColor:Color.mainBlue,IsDisabled:.constant(studenthomevm.term == nil || studenthomevm.academicYear == nil) , action: {
                                    withAnimation{
                                        isSearch = true
                                    }
                                })
                                .frame(height: 50)
                                .padding(.top,10)
                            }
                            .padding()
                            .borderRadius(Color.mainBlue, width: 1, cornerRadius: 8, corners: [.allCorners])
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
                                                studenthomevm.clearsearch()
                                            }
                                        }
                                        .padding()
//                                    Text("Showing Results For".localized())
//                                        .font(Font.SoraBold(size: 18))
//                                        .foregroundColor(.mainBlue)
                                    
                                    SignUpHeaderTitle(Title: "Showing Results For", subTitleView: AnyView(
                                        ZStack{
                                            if studenthomevm.term != nil && studenthomevm.academicYear != nil{
                                                let searchselections = "\(studenthomevm.educationType?.Title ?? ""), \(studenthomevm.educationLevel?.Title ?? ""), \(studenthomevm.academicYear?.Title ?? ""), \(studenthomevm.term?.Title ?? "")"
                                                Text(searchselections)
                                                    .font(Font.SoraRegular(size: 10.0))
                                                    .foregroundColor(ColorConstants.Red400)
                                            }}
                                    ))
                                    
                                    Spacer()
                                }
//                                .padding([.top,.horizontal])
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
                                            destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
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
                                            destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.id ?? 0, bookingcase: .lesson))
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
                                            destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
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
                                            destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: subject.id ?? 0, bookingcase: .subject))
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
                                            destination = AnyView(    TeacherInfoView(teacherid: teacher.id ?? 0))
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
                                            destination = AnyView(    TeacherInfoView(teacherid: teacher.id ?? 0))
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
                        lookupsvm.GetEducationTypes()
                        lookupsvm.GetSemesters()
//                        studenthomevm.clearselections()
                        studenthomevm.getHomeData()
                        studenthomevm.GetStudentSubjects()
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
                            destination =
                           AnyView(SignInView())
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
        .overlay(content: {
            SideMenuView()
        })
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    
    @ViewBuilder
    private func SideMenuView() -> some View {
        SideView(isShowing: $presentSideMenu, content: AnyView(AnonymousSideMenuContent(presentSideMenu: $presentSideMenu, selectedDestination: $selectedDestination))
                 , direction: .leading)
    }
    
}

#Preview{
    AnonymousHomeView()
    //        .environmentObject(StudentTabBarVM())
}


struct AnonymousSideMenuContent: View {
//    @EnvironmentObject var studentsignupvm : StudentEditProfileVM

    @Binding var presentSideMenu: Bool
    @Binding var selectedDestination: AnonymousDestinations?
//    @Binding var isPush: Bool

    var body: some View {
        ScrollView{
            VStack(alignment: .trailing, spacing: 10) {
                HStack(spacing:20){
//                    ZStack(alignment: .topLeading){
//                        let imageURL : URL? = URL(string: Constants.baseURL+(studentsignupvm.imageStr ?? ""))
//                        KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 60,height: 60)
//                            .clipShape(Circle())
//
//                        
//                        Image("Edit_fill")
//                        //                        .resizable().aspectRatio(contentMode: .fit)
//                        //                        .font(.InterMedium(size: 12))
//                            .frame(width: 15,height: 15)
//                            .background(.white)
//                            .clipShape(Circle())
//                            .offset(x:0,y:2)
//                        
//                    }
                    VStack(alignment:.leading) {
                        Text("Anonymous".localized())
                            .font(.SoraBold(size: 18))
                            .foregroundStyle(.whiteA700)
                        
//                        Text("Edit your profile")
//                            .font(.SoraRegular(size: 12))
//                            .foregroundStyle(.whiteA700)
                    }
                    
                    Spacer()
                    }
                .padding()
//                .onTapGesture {
//                    selectedDestination = .login
//                    presentSideMenu =  false
////                    isPush = true
//
//                }
//                SideMenuSectionTitle(title: "Academic")
                
//                SideMenuButton(image: "MenuSt_calendar", title: "Calendar"){
//                    selectedDestination = .calendar // calendar
//                    presentSideMenu =  false
//                    isPush = true
//                }

//                SideMenuButton(image: "MenuSt_lock", title: "Rates & Reviews"){
//                    selectedDestination = .rates // rates
//                    presentSideMenu =  false
//                    isPush = true
//                }
                
                SideMenuSectionTitle(title: "Settings")

//                SideMenuButton(image: "MenuSt_rates", title: "Change Password"){
//                    selectedDestination = .changePassword // cahnage Password
//                    presentSideMenu =  false
//                    isPush = true
//                }

//                SideMenuButton(image: "MenuSt_tickets", title: "Tickets"){
//                    selectedDestination = .tickets // Tickets
//                    presentSideMenu =  false
//                    isPush = true
//                }

                SideMenuButton(image: "MenuSt_signout", title: "Sign In"){
                    selectedDestination = .login // sign out
                    presentSideMenu =  false
//                    isPush = true
                }
                
//                SideMenuButton(image: "MenuSt_signout", title: "Delete Account",titleColor: ColorConstants.Red400){
//                    selectedDestination = .deleteAccount // delete account
//                    presentSideMenu =  false
//                    isPush = true
//                }

                Spacer()
            }
        }
            .frame(width: UIScreen.main.bounds.width - 80)
            .padding(.top, 55)
            .background{
                Color.mainBlue
        }
    }
    
}
