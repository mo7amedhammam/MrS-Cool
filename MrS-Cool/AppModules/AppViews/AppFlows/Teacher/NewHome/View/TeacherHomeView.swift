//
//  TeacherHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 28/09/2024.
//

import SwiftUI

struct TeacherHomeView: View {
    @State private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    @EnvironmentObject var tabbarvm : StudentTabBarVM
    @StateObject var lookupsvm = LookUpsVM()
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @StateObject var SchedualsVm = TeacherHomeVM()
    @StateObject var subjectgroupvm = ManageSubjectGroupVM.shared
    
    @State var showFilter : Bool = false
    //    var currentSubject:TeacherSubjectM?
    
    var hasNavBar : Bool? = true
    @Binding var selectedChild : ChildrenM?
    
    //    @State var isPush = false
    //    @State var destination = AnyView(EmptyView())
    @State var filterstartdate : String?
    @State var filterenddate : String?
    @State var FilterAttend:Bool = false
    @State var FilterCancel:Bool = false
    
    @State private var ScrollToTop = false
    
    @MainActor
    func applyFilter() async {
        SchedualsVm.filterstartdate = filterstartdate
        SchedualsVm.filterenddate = filterenddate
        SchedualsVm.FilterAttend = FilterAttend
        SchedualsVm.FilterCancel = FilterCancel

        SchedualsVm.skipCount = 0
//        SchedualsVm.GetScheduals()
//        Task{
            await fetchScheduals()
//        }
    }
    
    
    
    @MainActor
    func clearFilter() async {
        if filterstartdate != nil || filterenddate != nil || FilterAttend || FilterCancel{
            filterstartdate = nil
            filterenddate = nil
            FilterAttend = false
            FilterCancel = false
            
            SchedualsVm.skipCount = 0
            SchedualsVm.clearFilter()
//            SchedualsVm.GetScheduals()
//            Task{
                await fetchScheduals()
//            }

        }
    }

    @State var date:String = "\(Date().formatDate(format: "dd MMM yyyy hh:mm a"))"

    var body: some View {
        VStack {
            if hasNavBar ?? true{
                CustomTitleBarView(title: "Schedual List")
            }
            
            GeometryReader { gr in
//                if Helper.shared.getSelectedUserType() == .Parent && selectedChild == nil{
//                    VStack{
//                        Text("You Have To Select Child First".localized())
//                            .frame(minHeight:gr.size.height)
//                            .frame(width: gr.size.width,alignment: .center)
//                            .font(.title2)
//                            .foregroundColor(ColorConstants.MainColor)
//                    }
//                }else{
                    ScrollView(.vertical,showsIndicators: false){
                        
                        if Helper.shared.getSelectedUserType() == .Teacher{
                            KFImageLoader(url:URL(string:  "https://platform.mrscool.app/assets/images/Anonymous/Teacher.jpg"), placeholder: Image("Teacher-Panner"),shouldRefetch: true)
                                .padding()
                        }
                        VStack{ // (Title - Data - Submit Button)
                            Group{
                                HStack(){
                                    SignUpHeaderTitle(Title: "Manage My Scheduals")
                                    Spacer()
                                    Image("img_maskgroup62_clipped")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(ColorConstants.MainColor)
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .onTapGesture(perform: {
                                            showFilter = true
                                            //                                        validateFilterValues()
                                        })

                                }
//                                .padding(.top)
                                
                            }
                            .padding(.horizontal)

                                Group{
                                    Text("Notice : All lesson schedules are in Egypt Standard Time: The current time in Egypt ".localized())
                                    + Text("\( date )".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy hh:mm a"))
                                }
                                .foregroundColor(ColorConstants.Red400)
                                .font(Font.bold(size: 13))
                                .lineSpacing(5)
                                .padding(.horizontal)
                            
                            if Helper.shared.getSelectedUserType() == .Teacher{
                                ScrollViewReader{proxy in
                                    let scheduals = SchedualsVm.TeacherScheduals?.items ?? []
                                    List(scheduals, id:\.self){ schedual in
                                        
                                        TeacherHomeCellView(model: schedual, cancelBtnAction: {
                                            
                                            if !(schedual.teachersubjectAcademicSemesterYearID ?? 0 > 0){
                                                
                                                SchedualsVm.error = .question( image: "img_group", message: "Are you sure you want to cancel this event ?", buttonTitle: "Confirm", secondButtonTitle: "Cancel", mainBtnAction: {
                                                    if let eventid = schedual.teacherLessonSessionSchedualSlotID{
                                                        SchedualsVm.CancelCalendarCheduals(id:eventid)
                                                    }
                                                })
                                                SchedualsVm.isConfirmError = true
                                            }else {
                                                // add extra session
                                                SchedualsVm.clearExtraSession()
                                                
                                                SchedualsVm.teacherlessonsessionid = schedual.teacherlessonsessionID
                                                SchedualsVm.teacherLessonSessionSchedualSlotID = schedual.teacherLessonSessionSchedualSlotID
                                                
                                                SchedualsVm.extraLesson = DropDownOption(id: schedual.teacherlessonID ?? 0, Title: schedual.sessionName ?? "", LessonItem: LessonForListM(id: schedual.teacherlessonID ?? 0,groupDuration: schedual.groupDuration ?? 0,lessonName: schedual.sessionName ?? ""))
                                                
                                                SchedualsVm.ShowAddExtraSession = true
                                            }
                                            
                                        }, joinBtnAction: {
                                            if let teamMeetingLink = schedual.teamMeetingLink{    joinMeeting(meetingLink: teamMeetingLink)
                                            }
                                            
                                            if let eventid = schedual.teacherLessonSessionSchedualSlotID {
                                                SchedualsVm.StudentAttendanceCalendarSchedual(id: eventid)
                                            }
                                            //                                        else{
                                            //                                            // if teacher
                                            //                                            if Helper.shared.getSelectedUserType() == .Teacher,let eventid = schedual.id{
                                            //                                                SchedualsVm.StudentAttendanceCalendarSchedual(id: eventid)
                                            //                                            }
                                            //                                        }
                                            
                                        })
                                        
                                        //                                .frame(height: 120)
                                        .listRowSpacing(0)
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .onAppear {
                                            guard schedual == scheduals.last else {return}
                                            
                                            if let totalCount = SchedualsVm.TeacherScheduals?.totalCount, scheduals.count < totalCount {
                                                // Load the next page if there are more items to fetch
                                                SchedualsVm.skipCount += SchedualsVm.maxResultCount
//                                                SchedualsVm.GetScheduals()
                                                Task{
                                                    await fetchScheduals()
                                                }
                                            }
                                        }
                                        .id(schedual)
                                        .onChange(of: ScrollToTop) { value in
                                            if value == true {
                                                withAnimation {
                                                    proxy.scrollTo(scheduals.first , anchor: .bottom)
                                                }
                                            }
                                            ScrollToTop = false
                                        }
                                    }
                                    .padding(.horizontal,-4)
                                    .listStyle(.plain)
                                    .frame(minHeight: gr.size.height/2)
                                }
                            }else{
                                // ------ Student -----
                                
                                ScrollViewReader{proxy in
                                    let scheduals = SchedualsVm.StudentScheduals?.items ?? []
                                    List(scheduals, id:\.self){ schedual in
                                        
                                        StudentHomeCellView(model: schedual, cancelBtnAction: {
                                            
                                            //                                        if schedual.teachersubjectAcademicSemesterYearID == nil{
                                            SchedualsVm.error = .question( image: "img_group", message: "Are you sure you want to cancel this event ?", buttonTitle: "Confirm", secondButtonTitle: "Cancel", mainBtnAction: {
                                                if let eventid = schedual.teacherLessonSessionSchedualSlotID{
                                                    SchedualsVm.CancelCalendarCheduals(id:eventid)
                                                }
                                            })
                                            SchedualsVm.isConfirmError = true
                                            
                                        }, joinBtnAction: {
                                            if let teamMeetingLink = schedual.teamMeetingLink{    joinMeeting(meetingLink: teamMeetingLink)
                                            }
                                            
                                            if let eventid = schedual.bookTeacherlessonsessionDetailID{
                                                SchedualsVm.StudentAttendanceCalendarSchedual(id: eventid)
                                            }
                                        })
                                        //                                .frame(height: 120)
                                        .listRowSpacing(0)
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .onAppear {
                                            guard schedual == scheduals.last else {return}
                                            
                                            if let totalCount = SchedualsVm.StudentScheduals?.totalCount, scheduals.count < totalCount {
                                                // Load the next page if there are more items to fetch
                                                SchedualsVm.skipCount += SchedualsVm.maxResultCount
//                                                SchedualsVm.GetScheduals()
                                                Task{
                                                    await fetchScheduals()
                                                }
                                            }
                                        }
                                        .id(schedual)
                                        .onChange(of: ScrollToTop) { value in
                                            if value == true {
                                                withAnimation {
                                                    proxy.scrollTo(scheduals.first , anchor: .bottom)
                                                }
                                            }
                                            ScrollToTop = false
                                        }
                                    }
                                    .padding(.horizontal,-4)
                                    .listStyle(.plain)
                                    .frame(minHeight: gr.size.height/2)
                                }
                            }
                            Spacer()
                        }
                        .frame(minHeight: gr.size.height)
                    }
//                }
            }
        }
        .localizeView()
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .task {
            date = await Helper.shared.GetEgyptDateTime()
            filterstartdate = date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy")

//            filterstartdate = String(Date().formatDate(format: "dd MMM yyyy"))
//            filterenddate = String(Date().formatDate(format: "dd MMM yyyy"))
            
            FilterAttend = false
            FilterCancel = false
//            SchedualsVm.clearFilter()
           await applyFilter()
//            SchedualsVm.GetScheduals()
//            await SchedualsVm.GetEgyptDateTime()
        }
        .onDisappear {
            showFilter = false
            //            completedlessonsvm.cleanup()
        }
        
        .bottomSheet(isPresented: $SchedualsVm.ShowAddExtraSession){
            VStack{
                ColorConstants.Bluegray100
                    .frame(width:50,height:5)
                    .cornerRadius(2.5)
                    .padding(.top,2)
                HStack {
                    Text("Extra Session".localized())
                        .font(Font.bold(size: 18))
                        .foregroundColor(.mainBlue)
                }.padding(8)
                ScrollView{
                    Group {
                        CustomDropDownField(iconName:"img_group_512380",placeholder: "ِLesson", selectedOption: $SchedualsVm.extraLesson,options:[],Disabled: true)
                        
                        let startDate = Date()
                        CustomDatePickerField(iconName:"img_group148",placeholder: "Date", selectedDateStr:$SchedualsVm.extraDate,startDate: startDate,datePickerComponent:.date,isvalid: SchedualsVm.isextraDatevalid)
                        
                        CustomDatePickerField(iconName:"img_maskgroup7cl",placeholder: "Start Time", selectedDateStr:$SchedualsVm.extraTime,timeZone:TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current,datePickerComponent:.hourAndMinute,isvalid: SchedualsVm.isextraTimevalid)
                        
                    }
                    .padding(.top,5)
                    
                    HStack {
                        Group{
                            CustomButton(Title:"Save",IsDisabled: .constant(false), action:{
                                SchedualsVm.CreateExtraSession()
//                                SchedualsVm.ShowAddExtraSession = false
                            })
                            
                            CustomBorderedButton(Title:"Cancel",IsDisabled: .constant(false), action: {
                                SchedualsVm.clearExtraSession()
                                //                            subjectgroupvm.GetTeacherSubjectGroups()
                                SchedualsVm.ShowAddExtraSession = false
                            })
                        }
                        .frame(width:130,height:40)
                        .padding(.vertical)
                    }
                    .padding(.horizontal,3)
                    .padding(.top)
                    
                }
                .frame(height: 320)
            }
            .background(ColorConstants.WhiteA700.cornerRadius(8))
            .padding()
            
        }
        
        .showHud(isShowing: $SchedualsVm.isLoading)
        .showAlert(hasAlert: $SchedualsVm.isError, alertType: SchedualsVm.error)
        .showAlert(hasAlert: $SchedualsVm.isConfirmError, alertType: SchedualsVm.error)
        
        .overlay{
            if showFilter{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showFilter.toggle()
                    }
                    .blur(radius: 4) // Adjust the blur radius as needed
                DynamicHeightSheet(isPresented: $showFilter){
                    VStack {
                        ColorConstants.Bluegray100
                            .frame(width:50,height:5)
                            .cornerRadius(2.5)
                            .padding(.top,2.5)
                        HStack {
                            Text("Filter".localized())
                                .font(Font.bold(size: 18))
                                .foregroundColor(.mainBlue)
                            //                                            Spacer()
                        }
                        ScrollView{
                            VStack{
                                Group {
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$filterstartdate,datePickerComponent:.date)
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "End Date", selectedDateStr:$filterenddate,datePickerComponent:.date)
                                    
                                    HStack(spacing:30){
                                        Toggle("Filter_Cancel".localized(), isOn: $FilterCancel)
                                        Spacer()
                                        Toggle("Filter_Attend".localized(), isOn: $FilterAttend)
                                    }
                                    .font(Font.bold(size: 13))
                                    .padding([.horizontal,.top])
                                    .toggleStyle(SwitchToggleStyle(tint: ColorConstants.MainColor))

                                    
                                }.padding(.top,5)
                                
                                Spacer()
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            Task{ await applyFilter() }
                                            ScrollToTop = true
                                            showFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            Task{ await clearFilter() }
                                            ScrollToTop = true
                                            showFilter = false
                                        })
                                    } .frame(width:130,height:40)
                                        .padding(.vertical)
                                }
                            }
                            .padding(.horizontal,3)
                            .padding(.top)
                        }
                    }
                    .padding()
                    .frame(height:360)
                    .keyboardAdaptive()
                }
            }
        }
 
    }
    
    @MainActor
       private func fetchScheduals() async {
           SchedualsVm.isLoading = true // Start the loading animation
           await SchedualsVm.GetScheduals1()
           SchedualsVm.isLoading = false // Stop the loading animation
       }
}

#Preview {
    TeacherHomeView( selectedChild: .constant(nil))
        .environmentObject(StudentTabBarVM())
    //        .environmentObject(CompletedLessonsVM())
    
}

extension TeacherHomeView{
    
    private func joinMeeting( meetingLink: String) {
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            // Handle expiration here if needed
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        })
        
        print("Joining event...")
        //        onJoinEvent?(event)
        print("onJoinEvent closure executed")
        
        if let teamsURL = URL(string: "msteams://") {
            // Try to open Teams app first
            if UIApplication.shared.canOpenURL(teamsURL) {
                UIApplication.shared.open(teamsURL, options: [:]) { success in
                    if success {
                        print("Teams app opened successfully.")
                    } else {
                        // If Teams app failed to open, fall back to the provided meeting link
                        self.openMeetingLink(meetingLink)
                    }
                    UIApplication.shared.endBackgroundTask(backgroundTask)
                    backgroundTask = .invalid
                }
            } else {
                // If Teams app is not available, open the meeting link directly
                self.openMeetingLink(meetingLink)
            }
        } else {
            // If URL creation fails, open the meeting link directly
            self.openMeetingLink(meetingLink)
        }
    }
    
    private func openMeetingLink(_ meetingLink: String) {
        if let url = URL(string: meetingLink) {
            UIApplication.shared.open(url) { success in
                print("URL opened: \(success)")
                if success {
                    // Perform any additional actions if needed
                }
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = .invalid
            }
        } else {
            print("Invalid URL: \(meetingLink)")
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
}
