//
//  TeacherHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 28/09/2024.
//

import SwiftUI
//import SafariServices
//import SwiftUI

//struct SafariView: UIViewControllerRepresentable {
//    let url: URL
//
//    func makeUIViewController(context: Context) -> SFSafariViewController {
//        return SFSafariViewController(url: url)
//    }
//
//    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
//}
struct TeacherHomeView: View {
    @State private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
//    @State private var timerTask: Task<Void, Never>?

    @EnvironmentObject var tabbarvm : StudentTabBarVM
    @StateObject var lookupsvm = LookUpsVM()
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @StateObject var SchedualsVm = TeacherHomeVM()
    @Environment(\.scenePhase) var scenePhase

    @StateObject var subjectgroupvm = ManageSubjectGroupVM.shared
    
    @State var showFilter : Bool = false
    
    @State private var showMeetingChoice = false
    @State private var joinInApp = false
    @State var DesktopMeetingLink : String? = nil
    @State var MobileMeetingLink : String? = nil
    @State var joiningid:Int? = nil
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
    @State private var selectedTab = 0
    @State private var timer: Timer?
//    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
//    @State private var isTimerActive = false


    private var shouldShowChildSelection: Bool {
        Helper.shared.getSelectedUserType() == .Parent &&  selectedChild == nil
    }
    
    fileprivate func GetStartData() async {
        SchedualsVm.StudentScheduals?.items?.removeAll()
        date = await Helper.shared.GetEgyptDateTime()
        filterstartdate = date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy")
        
        //            filterstartdate = String(Date().formatDate(format: "dd MMM yyyy"))
        //            filterenddate = String(Date().formatDate(format: "dd MMM yyyy"))
        
        FilterAttend = false
        FilterCancel = false
        //            SchedualsVm.clearFilter()
        if Helper.shared.getSelectedUserType() == .Teacher || Helper.shared.getSelectedUserType() == .Student || selectedChild != nil {
            await applyFilter()
            //            SchedualsVm.GetScheduals()
            //            await SchedualsVm.GetEgyptDateTime()
        }
    }
    
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
                
                if DesktopMeetingLink != nil && joinInApp == true {
                    TeamsMeetingWebView(
                        meetingURL: $DesktopMeetingLink,
                        meetingTitle: ""
                    )
                }else{
                    
                    ScrollView(.vertical,showsIndicators: false){
                        
                        if Helper.shared.getSelectedUserType() == .Teacher{
                            KFImageLoader(url:URL(string:  "https://platform.mrscool.app/assets/images/Anonymous/Teacher.jpg"), placeholder: Image("Teacher-Panner"),shouldRefetch: true)
                                .padding()
                            
                            CapsulePicker(selectedIndex: $selectedTab, titles: ["Schedual List".localized, "Alternate Sessions".localized])
                                .padding(.horizontal)
                        }
                        
                        VStack{ // (Title - Data - Submit Button)
                            
                            if Helper.shared.getSelectedUserType() == .Teacher{
                                if selectedTab == 0{
                                    header
                                    ScrollViewReader{proxy in
                                        let scheduals = SchedualsVm.TeacherScheduals?.items ?? []
                                        List(scheduals, id:\.self){ schedual in
                                            
                                            TeacherHomeCellView(model: schedual,
                                                                editBtnAction: {
                                                if schedual.isAlternate == true{
                                                    SchedualsVm.sessoionMode = .rescheduleAlternateSession
                                                }else{
                                                    // call add extrasession -> iscancel = true
                                                    SchedualsVm.sessoionMode = .createextraSession
                                                }
                                                
                                                SchedualsVm.clearExtraSession()
                                                
                                                SchedualsVm.teacherlessonsessionid = schedual.teacherlessonsessionID
                                                SchedualsVm.teacherLessonSessionSchedualSlotID = schedual.teacherLessonSessionSchedualSlotID
                                                SchedualsVm.extraLesson = DropDownOption(id: schedual.teacherlessonID ?? 0, Title: schedual.sessionName ?? "", LessonItem: LessonForListM(id: schedual.teacherlessonID ?? 0,groupDuration: schedual.groupDuration ?? 0,lessonName: schedual.sessionName ?? ""))
                                                SchedualsVm.ShowAddExtraSession = true
                                                
                                            }, cancelBtnAction: {
                                                //call new api here
                                                //                                            if !(schedual.teachersubjectAcademicSemesterYearID ?? 0 > 0){
                                                SchedualsVm.error = .question( image: "img_group", message: "Are you sure you want to cancel this event ?", buttonTitle: "Confirm", secondButtonTitle: "Cancel", mainBtnAction: {
                                                    if let eventid = schedual.teacherLessonSessionSchedualSlotID{
                                                        SchedualsVm.CancelCalendarCheduals(id:eventid)
                                                    }
                                                })
                                                SchedualsVm.isConfirmError = true
                                                
                                                //                                            }else {
                                                //                                                // add extra session
                                                //                                                SchedualsVm.clearExtraSession()
                                                //
                                                //                                                SchedualsVm.teacherlessonsessionid = schedual.teacherlessonsessionID
                                                //                                                SchedualsVm.teacherLessonSessionSchedualSlotID = schedual.teacherLessonSessionSchedualSlotID
                                                //
                                                //                                                SchedualsVm.extraLesson = DropDownOption(id: schedual.teacherlessonID ?? 0, Title: schedual.sessionName ?? "", LessonItem: LessonForListM(id: schedual.teacherlessonID ?? 0,groupDuration: schedual.groupDuration ?? 0,lessonName: schedual.sessionName ?? ""))
                                                //
                                                //                                                SchedualsVm.ShowAddExtraSession = true
                                                //                                            }
                                                
                                            }, joinBtnAction: {
                                                if let eventid = schedual.teacherLessonSessionSchedualSlotID {
                                                  joiningid = eventid
//                                                    SchedualsVm.StudentAttendanceCalendarSchedual(id: eventid)
                                                }
                                                
                                                if let teamMeetingLink = schedual.teamMeetingLink ,let teamLink = schedual.teamLink{
                                                    
//                                                    joinMeeting(meetingLink: teamMeetingLink)
//                                                    meetingLink = nil
                                                    joinInApp = false
                                                    showMeetingChoice = true
                                                    DesktopMeetingLink = teamMeetingLink
                                                    MobileMeetingLink = teamLink
//                                                    meetingLink = "https://teams.microsoft.com/l/meetup-join/launch?agent=web&version=25051800200&coords=eyJjb252ZXJzYXRpb25JZCI6IjE5JTNhbWVldGluZ19PRGd4TldWbVlXTXRZVFV5TXkwME1USTJMVGhpTjJVdFpUQm1ZMk5rWlRrek5tSXklNDB0aHJlYWQudjIiLCJ0ZW5hbnRJZCI6ImQ4NGU1MWQ2LWU4MzctNGU5MS1hMWVlLTQzOTEwMTFkMzAzOSIsIm9yZ2FuaXplcklkIjoiMmIzYzcwYzAtZmY0OC00Y2MwLTliZDQtMWQ0ZWVjMTE0MTAzIiwibWVzc2FnZUlkIjoiMCJ9&deeplinkId=56309017-b181-4400-8347-4995effdda57&correlationId=392816c7-d770-43c6-80b7-9536435e2d0d"
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
                                    
                                }else if selectedTab == 1{
                                    // ------- alternate sessions -------
                                    HStack(){
                                        SignUpHeaderTitle(Title: "Alternate Sessions".localized)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.top,4)
                                    .padding(.bottom,2)
                                    
                                    Group{
                                        Text("Notice : All lesson schedules are in Egypt Standard Time: The current time in Egypt".localized())
                                        + Text("\( date )".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy hh:mm a"))
                                    }
                                    .foregroundColor(ColorConstants.Red400)
                                    .font(Font.bold(size: 13))
                                    .lineSpacing(5)
                                    .padding(.horizontal)
                                    
                                    //                                if Helper.shared.getSelectedUserType() == .Teacher{
                                    ScrollViewReader{proxy in
                                        let sessions = SchedualsVm.AlternateSessions ?? []
                                        List(sessions, id:\.self){ session in
                                            AlternateSessionCell(model: session, addBtnAction: {
                                                // add extra session
                                                SchedualsVm.sessoionMode = .newAlternateSession
                                                SchedualsVm.clearExtraSession()
                                                SchedualsVm.teacherlessonsessionid = session.teacherLessonSessionID
                                                SchedualsVm.teacherLessonSessionSchedualSlotID = session.teacherLessonSessionSlotID
                                                
                                                SchedualsVm.extraLesson = DropDownOption(id: session.teacherLessonID ?? 0, Title: session.lessonName ?? "", LessonItem: LessonForListM(id: session.teacherLessonID ?? 0,groupDuration: session.duration ?? 0 ,lessonName: session.lessonName ?? ""))
                                                
                                                SchedualsVm.ShowAddExtraSession = true
                                            })
                                            //                                .frame(height: 120)
                                            .listRowSpacing(0)
                                            .listRowSeparator(.hidden)
                                            .listRowBackground(Color.clear)
                                            .onAppear{
                                                Task{
                                                    await SchedualsVm.GetAlternateSessions()
                                                }
                                            }
                                            .id(session)
                                            .onChange(of: ScrollToTop){ value in
                                                if value == true {
                                                    withAnimation {
                                                        proxy.scrollTo(sessions.first , anchor: .bottom)
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
                            }else{
                                // ------ Student -----
                                
                                ScrollViewReader{proxy in
                                    
                                    if shouldShowChildSelection {
                                        ChildSelectionView()
                                    } else {
                                        header
                                        
                                        let scheduals = SchedualsVm.StudentScheduals?.items ?? []
                                        List(scheduals, id:\.self){ schedual in
                                            
                                            StudentHomeCellView(model: schedual,detailsBtnAction: {
                                                guard let BookDetailId = schedual.bookTeacherlessonsessionDetailID else {return}
                                                
                                                SchedualsVm.ShowStudentCalendarDetails = true
                                                Task{
                                                    await SchedualsVm.StudentGetCalendarDetails(BookDetailId: BookDetailId)
                                                }
                                            }, cancelBtnAction: {
                                                
                                                //                                        if schedual.teachersubjectAcademicSemesterYearID == nil{
                                                SchedualsVm.error = .question( image: "img_group", message: "Are you sure you want to cancel this event ?", buttonTitle: "Confirm", secondButtonTitle: "Cancel", mainBtnAction: {
                                                    if let eventid = schedual.teacherLessonSessionSchedualSlotID{
                                                        SchedualsVm.CancelCalendarCheduals(id:eventid)
                                                    }
                                                })
                                                SchedualsVm.isConfirmError = true
                                                
                                            }, joinBtnAction: {
//                                                if let teamMeetingLink = schedual.teamMeetingLink{    joinMeeting(meetingLink: teamMeetingLink)
//                                                }
                                                
                                                if let teamMeetingLink = schedual.teamMeetingLink,let teamLink = schedual.teamLink {
                                                    
//                                                    joinMeeting(meetingLink: teamMeetingLink)
//                                                    meetingLink = nil
                                                    joinInApp = false
                                                    showMeetingChoice = true
                                                    DesktopMeetingLink = teamMeetingLink
                                                    MobileMeetingLink = teamLink

//                                                    meetingLink = "https://teams.microsoft.com/l/meetup-join/launch?agent=web&version=25051800200&coords=eyJjb252ZXJzYXRpb25JZCI6IjE5JTNhbWVldGluZ19PRGd4TldWbVlXTXRZVFV5TXkwME1USTJMVGhpTjJVdFpUQm1ZMk5rWlRrek5tSXklNDB0aHJlYWQudjIiLCJ0ZW5hbnRJZCI6ImQ4NGU1MWQ2LWU4MzctNGU5MS1hMWVlLTQzOTEwMTFkMzAzOSIsIm9yZ2FuaXplcklkIjoiMmIzYzcwYzAtZmY0OC00Y2MwLTliZDQtMWQ0ZWVjMTE0MTAzIiwibWVzc2FnZUlkIjoiMCJ9&deeplinkId=56309017-b181-4400-8347-4995effdda57&correlationId=392816c7-d770-43c6-80b7-9536435e2d0d"
                                                    

                                                }
                                                if let eventid = schedual.bookTeacherlessonsessionDetailID{
                                                    joiningid = eventid
//                                                    SchedualsVm.StudentAttendanceCalendarSchedual(id: eventid)
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
                            }
                            Spacer()
                        }
                        .frame(minHeight: gr.size.height)
                        .actionSheet(isPresented: $showMeetingChoice) {
                                        ActionSheet(
                                            title: Text(""),
                                            message: Text(""),
                                            buttons: [
                                                .default(Text("Open_In_Teams".localized)) {
                                                    if let url = MobileMeetingLink {
                                                        joinMeeting(meetingLink: url)
                                                        if let eventid = joiningid {
                                                            SchedualsVm.StudentAttendanceCalendarSchedual(id: eventid)
                                                        }
                                                    }
                                                },
                                                .default(Text("Open_In_MrS-Cool".localized)) {
                                                    joinInApp = true

                                                    if let eventid = joiningid {
                                                        SchedualsVm.StudentAttendanceCalendarSchedual(id: eventid)
                                                    }
                                                },
                                                .cancel(Text("Cancel".localized))
                                            ]
                                        )
                                    }
                    }
                    //                }
                }
            }
            
        }
        .localizeView()
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
//        .onReceive(timer) { _ in
//                    guard isTimerActive else { return }
//                    fireTimerAction()
//                }
//        .task {
////            isTimerActive = true
//            await GetStartData()
////            startTimer()
//
//            SchedualsVm.isViewVisible = true
//            SchedualsVm.startTimer()
//        }
        
        .onAppear {
            print("TeacherHomeView appeared")

            SchedualsVm.isViewVisible = true
            Task {
//                await updateDateTime()
                await GetStartData()

//                if selectedTab == 0 {
                    startTimer()
//                }
            }
        }

        .onDisappear {
            print("TeacherHomeView disappeared")

            showFilter = false
            SchedualsVm.ShowAddExtraSession = false
            SchedualsVm.ShowStudentCalendarDetails = false
            SchedualsVm.isViewVisible = false
            stopTimer()
            SchedualsVm.cleanup()
//            stopTimer()
        }
//        .onChange(of: scenePhase) { newPhase in
//                 switch newPhase {
//                 case .active:
//                     SchedualsVm.isViewVisible = true
//                     if selectedTab == 0 {
//                         SchedualsVm.startTimer()
//                     }
//                 case .inactive, .background:
//                     SchedualsVm.isViewVisible = false
//                     SchedualsVm.stopTimer()
//                 @unknown default:
//                     break
//                 }
//             }
        .onChange(of:selectedTab){newval in
            Task{
            if newval == 0{
                await GetStartData()

            }else if newval == 1{
                await SchedualsVm.GetAlternateSessions()
                date = await Helper.shared.GetEgyptDateTime()
            }
            }
        }
        
//        .onChange(of: tabbarvm.selectedIndex) { newTab in
//               if newTab == 2 { // Adjust this to match your actual tab enum
//                   print("Selected Teacher tab")
//                   SchedualsVm.isViewVisible = true
//                   startTimer()
//               } else {
//                   print("Selected other tab")
//                   SchedualsVm.isViewVisible = false
//                   stopTimer()
//               }
//           }
        
        .bottomSheet(isPresented: $SchedualsVm.ShowAddExtraSession){
            VStack{
                ColorConstants.Bluegray100
                    .frame(width:50,height:5)
                    .cornerRadius(2.5)
                    .padding(.top,2)
                HStack {
                    
                    Text(selectedTab == 0 ? "Extra Session".localized() : "Alternate Session".localized())
                        .font(Font.bold(size: 18))
                        .foregroundColor(.mainBlue)
                }.padding(8)
                ScrollView{
                    Group {
                        CustomDropDownField(iconName:"img_group_512380",placeholder: "Lesson", selectedOption: $SchedualsVm.extraLesson,options:[],Disabled: true)
                        
                        let startDate = Date()
                        CustomDatePickerField(iconName:"img_group148",placeholder: "Date", selectedDateStr:$SchedualsVm.extraDate,startDate: startDate,datePickerComponent:.date,isvalid: SchedualsVm.isextraDatevalid)
                        
                        CustomDatePickerField(iconName:"img_maskgroup7cl",placeholder: "Start Time", selectedDateStr:$SchedualsVm.extraTime,timeZone:appTimeZone ?? TimeZone.current,datePickerComponent:.hourAndMinute,isvalid: SchedualsVm.isextraTimevalid)
                    }
                    .padding(.top,5)
                    
                    HStack {
                        Group{
                            CustomButton(Title:"Save",IsDisabled: .constant(false), action:{
                                if selectedTab == 0{
                                    if SchedualsVm.sessoionMode == .createextraSession{
                                        SchedualsVm.CreateExtraSession()
                                        
                                    }else if SchedualsVm.sessoionMode == .rescheduleAlternateSession{
                                        Task{
                                            await  SchedualsVm.CreateAlternateSession()
                                        }
                                    }
                                    //                                SchedualsVm.ShowAddExtraSession = false
                                }else if selectedTab == 1{
                                    Task{
                                        await  SchedualsVm.CreateAlternateSession()
                                    }
                                }
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
        .bottomSheet(isPresented: $SchedualsVm.ShowStudentCalendarDetails){
            VStack{
                ColorConstants.Bluegray100
                    .frame(width:50,height:5)
                    .cornerRadius(2.5)
                    .padding(.top,2)
                HStack {
                    
                    Spacer().frame(width:40,height: 40)
                    Spacer()
                    
                    Text("Sessions".localized())
                        .font(Font.bold(size: 18))
                        .foregroundColor(.mainBlue)
                    Spacer()
                        Button(action: {
                            SchedualsVm.ShowStudentCalendarDetails =  false
                        }) {
                            Image(systemName: "xmark")
                                .padding(7)
                                .font(.system(size: 22))
                                .foregroundStyle(ColorConstants.WhiteA700)
                        }
                        .background{
                            Color.black.opacity(0.2)
                                .clipShape(.circle)
                        }
                        
                        .frame(width:30,height: 30)
                     
                }
//                .padding(8)
                
                //                ScrollView{
                
                let lessons = SchedualsVm.StudentSchedualDetails ?? []
                List(lessons, id:\.self){ lesson in
                    
                    StudentHomeCellView(model: lesson,isDetailCell: true)
                    //                                                        .frame(height: 120)
                    //                        .listRowSpacing(0)
                    //                        .listRowSeparator(.hidden)
                    //                        .listRowBackground(Color.clear)
                }
                .padding(.horizontal,-15)
                .listStyle(.plain)
                
                
                //                }
                .frame(height: UIScreen.main.bounds.height * 0.7)
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
//    private func startTimer() {
//        let now = Date()
//        let calendar = Calendar.current
//        if let nextMinute = calendar.nextDate(after: now, matching: DateComponents(second: 0), matchingPolicy: .nextTime) {
//            let intervalToNextMinute = nextMinute.timeIntervalSince(now)
//            
//            print("Timer will align with system minute in \(intervalToNextMinute) seconds")
//                        DispatchQueue.main.asyncAfter(deadline: .now() + nextMinute.timeIntervalSince(now)) {
//                            fireTimerAction()
//                            
////                            self.timer = Timer.scheduledTimer(
////                                withTimeInterval: 60,
////                                repeats: true,
////                                block: { [ self] _ in
////                                    fireTimerAction()
////                                }
////                            )
//
//
//                        }
//            
// 
//        }
//    
//    }
//    private func fireTimerAction() {
//        print("Synced timer fired at exact start of minute")
//        Task {
//            date = await Helper.shared.GetEgyptDateTime()
//            await SchedualsVm.GetScheduals1(isrefreshing: true)
//        }
//    }
                                              
    @MainActor
    private func fetchScheduals() async {
        SchedualsVm.isLoading = true
        defer { SchedualsVm.isLoading = false }
        do {
            
            try Task.checkCancellation()
           await SchedualsVm.GetScheduals1()
        } catch {
//            SchedualsVm.isLoading = false
            if error is CancellationError { return }
            // Handle other errors
        }
    }
    
//    private func startTimer() {
//        // Invalidate any existing timer
//        timer?.invalidate()
//        
//        let now = Date()
//        let calendar = Calendar.current
//
//        // Get next whole minute
//        if let nextMinute = calendar.nextDate(after: now, matching: DateComponents(second: 0), matchingPolicy: .nextTime) {
//            let intervalToNextMinute = nextMinute.timeIntervalSince(now)
//
//            print("Timer will align with system minute in \(intervalToNextMinute) seconds")
//
//            // Schedule one-time timer to sync with start of next minute
//            Timer.scheduledTimer(withTimeInterval: intervalToNextMinute, repeats: false) { [ self] _ in
//                fireTimerAction() // First fire
//
//                // Start repeating timer every 60s from now
//                timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {[ self] _ in
//                    fireTimerAction()
//                }
//            }
//        }
//    }

//    private func stopTimer() {
//        timer?.invalidate()
//        print("timer stopped")
//        timer = nil
//        
////        timer.upstream.connect().cancel()
//    }

//--------------------
    
    func startTimer() {
        guard SchedualsVm.isViewVisible else { return }
        stopTimer() // Always stop existing timer first
        
        print("Starting timer...")
        
        // Get next whole minute
        let now = Date()
        let calendar = Calendar.current
        
        // Calculate next minute with second = 0
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        guard let nextMinute = calendar.date(from: components)?.addingTimeInterval(60) else {
            // Fallback - start immediately with 60s interval
            fireTimerAction()
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [ self] _ in
                self.fireTimerAction()
            }
            return
        }
        
        let intervalToNextMinute = nextMinute.timeIntervalSince(now)
        
        print("Timer will align with system minute in \(intervalToNextMinute) seconds")
        
        // Schedule initial timer
        Timer.scheduledTimer(withTimeInterval: intervalToNextMinute, repeats: false) { [ self] _ in
            self.fireTimerAction()
            
            // Start repeating timer
            self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [ self] _ in
                self.fireTimerAction()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        print("Timer fully stopped")
    }
    
    private func fireTimerAction() {
        guard SchedualsVm.isViewVisible else {
            stopTimer()
            return
        }
        
        print("Timer fired at \(Date())")
        Task {
            await updateDateTime()
            await refreshScheduals()
        }
    }
    
    @MainActor
    func updateDateTime() async {
                    date = await Helper.shared.GetEgyptDateTime()
        //            await SchedualsVm.GetScheduals1(isrefreshing: true)

//        currentDateTime = await Helper.shared.GetEgyptDateTime()
    }
    
    @MainActor
    private func refreshScheduals() async {
                    await SchedualsVm.GetScheduals1(isrefreshing: true)

//        await GetScheduals1(isrefreshing: true)
    }

}

#Preview {
    TeacherHomeView(
        selectedChild: .constant(nil)
    )
    .environmentObject(StudentTabBarVM())
    //        .environmentObject(CompletedLessonsVM())
    
}

extension TeacherHomeView{
    var header : some View {
        return  Group{
            HStack(){
                SignUpHeaderTitle(Title: "Manage My Scheduals".localized)
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
            //        }
            //        .padding(.horizontal)
            
            Group{
                Text("Notice : All lesson schedules are in Egypt Standard Time: The current time in Egypt".localized())
                + Text("\( date )".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy hh:mm a"))
            }
            .foregroundColor(ColorConstants.Red400)
            .font(Font.bold(size: 13))
            .lineSpacing(5)
        }
        .padding(.horizontal)

    }
    
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


struct CapsulePicker: View {
    @Binding var selectedIndex: Int
    @State private var hoverIndex = 0
    @State private var dragOffset: CGFloat = 0
    @State private var optionWidth: CGFloat = 0
    @State private var totalSize: CGSize = .zero
    @State private var isDragging: Bool = false
    var titles: [String]
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(ColorConstants.MainColor)
                .padding(isDragging ? 2 : 0)
                .frame(width: optionWidth, height: totalSize.height)
                .offset(x: dragOffset)
                .gesture(
                    LongPressGesture(minimumDuration: 0.01)
                        .sequenced(before: DragGesture())
                        .onChanged { value in
                            switch value {
                            case .first(true):
                                isDragging = true
                            case .second(true, let drag):
                                let translationWidth = (drag?.translation.width ?? 0) + CGFloat(selectedIndex) * optionWidth
                                hoverIndex = Int(round(min(max(0, translationWidth), optionWidth * CGFloat(titles.count - 1)) / optionWidth))
                            default:
                                isDragging = false
                            }
                        }
                        .onEnded { value in
                            if case .second(true, let drag?) = value {
                                let predictedEndOffset = drag.translation.width + CGFloat(selectedIndex) * optionWidth
                                selectedIndex = Int(round(min(max(0, predictedEndOffset), optionWidth * CGFloat(titles.count - 1)) / optionWidth))
                                hoverIndex = selectedIndex
                            }
                            isDragging = false
                        }
                        .simultaneously(with: TapGesture().onEnded { _ in isDragging = false })
                )
            
                .animation(.spring(), value: dragOffset)
                .animation(.spring(), value: isDragging)
            
            Capsule().fill(Color.accentColor).opacity(0.2)
                .padding(-4)
            
            HStack(spacing: 0) {
                ForEach(titles.indices, id: \.self) { index in
                    Text(titles[index].localized())
                        .frame(width: optionWidth, height: totalSize.height, alignment: .center)
                        .foregroundColor(hoverIndex == index ? .white : .black)
                        .animation(.easeInOut, value: hoverIndex)
                        .font(Font.bold(size: 14))
                    
                        .contentShape(Capsule())
                        .onTapGesture {
                            selectedIndex = index
                            hoverIndex = index
                        }.allowsHitTesting(selectedIndex != index)
                }
            }
            .onChange(of: hoverIndex) {i in
                dragOffset =  CGFloat(i) * optionWidth
            }
            .onChange(of: selectedIndex) {i in
                hoverIndex = i
            }
            .frame(width: totalSize.width, alignment: .leading)
        }
        .background(GeometryReader { proxy in Color.clear.onAppear { totalSize = proxy.size } })
        .onChange(of: totalSize) { _ in optionWidth = totalSize.width/CGFloat(titles.count) }
        .onAppear { hoverIndex = selectedIndex }
        .frame(height: 50)
        .padding([.leading, .trailing], 10)
    }
}
//---------
import WebKit

// MARK: - WebView Wrapper
struct DesktopWebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var title: String
    
    private let webView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        // Configure for Teams meeting
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        
        // Request desktop user agent for better Teams experience
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        DispatchQueue.main.async {
            canGoBack = webView.canGoBack
            canGoForward = webView.canGoForward
            title = webView.title ?? ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: DesktopWebView
        
        init(_ parent: DesktopWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            parent.title = webView.title ?? ""
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Allow all navigation within the webview
            decisionHandler(.allow)
        }
    }
    
    // MARK: - WebView Actions
    func goBack() {
        webView.goBack()
    }
    
    func goForward() {
        webView.goForward()
    }
    
    func reload() {
        webView.reload()
    }
}

// MARK: - Teams Meeting WebView Screen
struct TeamsMeetingWebView: View {
    @Binding var meetingURL: String?
    let meetingTitle: String
    
    @State private var isLoading = true
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var pageTitle = ""
    @State private var showingError = false
    @State private var webView: DesktopWebView?
    
//    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Loading indicator
                if isLoading {
                    ProgressView()
                        .frame(height: 4)
                        .tint(.blue)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 4)
                }
                
                // WebView
                if let urlStr = meetingURL, let url = URL(string: urlStr) {
                    DesktopWebView(
                        url: url,
                        isLoading: $isLoading,
                        canGoBack: $canGoBack,
                        canGoForward: $canGoForward,
                        title: $pageTitle
                    )
                    .onAppear {
                        self.webView = DesktopWebView(
                            url: url,
                            isLoading: $isLoading,
                            canGoBack: $canGoBack,
                            canGoForward: $canGoForward,
                            title: $pageTitle
                        )
                    }
                } else {
                    // Error state
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        
                        Text("رابط الاجتماع غير صالح")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("تحقق من رابط الاجتماع وحاول مرة أخرى")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Close".localized) {
//                            dismiss()
                            meetingURL = nil
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
//            .navigationTitle(meetingTitle.isEmpty ? "Meeting_".localized : meetingTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    // Navigation controls
                    HStack(spacing: 16) {
                        
                        Button(action: {
                            webView?.reload()
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close".localized) {
//                        dismiss()
                        meetingURL = nil
                    }
                }
            }
        }
        .localizeView()
//        .environment(\.layoutDirection, .rightToLeft)
    }
}
