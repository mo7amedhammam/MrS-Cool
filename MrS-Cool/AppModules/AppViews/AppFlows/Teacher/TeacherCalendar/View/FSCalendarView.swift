

import SwiftUI
import FSCalendar

//struct CalendarModuleView: UIViewRepresentable {
//    @Binding var selectedDate: Date?
//    var calendar : FSCalendar
//    var scope: FSCalendarScope
//    let events: [EventM]?
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    fileprivate lazy var dateFormatter2: DateFormatter = {
//        let formatter = DateFormatter.cachedFormatter
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.locale = Locale(identifier: "en_US")
//        return formatter
//    }()
//    
//    func makeUIView(context: Context) -> FSCalendar {
////        var calendar = calendar
//
//        calendar.delegate = context.coordinator
//        calendar.dataSource = context.coordinator
//        calendar.scope = scope
//        //        calendar.appearance.todayColor = UIColor.clear
//        //        calendar.appearance.titleTodayColor = UIColor.black
//        calendar.appearance.selectionColor = UIColor.mainBlue // Adjust the color as needed
//        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18)
//        
//        // Configure appearance for event dots
//        calendar.appearance.eventDefaultColor = UIColor.mainBlue // Adjust the color as needed
//        //           calendar.appearance.eventSelectionColor = UIColor.red // Adjust the color as needed
//        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7) // Adjust the offset as needed
//        calendar.scrollDirection = .vertical
//                    
//        calendar.reloadData() // Safely reload calendar data
//
//        return calendar
//    }
//    
//    func updateUIView(_ uiView: FSCalendar, context: Context) {
//          guard let events = events else { return }
//
//          if context.coordinator.events != events {
//              context.coordinator.events = events
//              context.coordinator.datesWithEvent = events.compactMap { $0.date?.prefix(10).description }
//              context.coordinator.datesWithMultipleEvents = Array(Set(context.coordinator.datesWithEvent.filter { date in
//                  let count = context.coordinator.datesWithEvent.filter { $0 == date }.count
//                  return count > 1
//              }))
//              uiView.reloadData()
//          }
//      }
//    
////    func updateUIView(_ uiView: FSCalendar, context: Context) {
////        context.coordinator.events = events ?? []
////        context.coordinator.datesWithEvent = events?.compactMap { $0.date?.prefix(10).description } ?? []
////        
////        context.coordinator.datesWithMultipleEvents = Array(Set(context.coordinator.datesWithEvent.filter { date in
////            let count = context.coordinator.datesWithEvent.filter { $0 == date }.count
////            return count > 1
////        }))
////        uiView.reloadData()
////    }
//    
//    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
//        var parent: CalendarModuleView
//        var events: [EventM] = []
////        {
////            didSet{
////                datesWithEvent = events.compactMap { $0.date?.prefix(10).description }
////                   datesWithMultipleEvents = Array(Set(datesWithEvent.filter { date in
////                       let count = datesWithEvent.filter { $0 == date }.count
////                       return count > 1
////                   }))
////            }
////        }
//        var datesWithEvent: [String] = []
//        var datesWithMultipleEvents: [String] = []
//        
//        init(_ calender: CalendarModuleView) {
//            self.parent = calender
//        }
//        
//        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//            self.parent.selectedDate = date
//        }
//
//                                              
////        func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
////            let dateFormatter3 = DateFormatter()
////            dateFormatter3.dateFormat = "yyyy-MM-dd"
////            dateFormatter3.locale = Locale(identifier: "en_US")
////            let dateString = dateFormatter3.string(from: date)
////
////            //display events as dots
////            cell.eventIndicator.isHidden = false
////            cell.eventIndicator.color = Color.mainBlue
////
////            if datesWithMultipleEvents.contains(dateString) {
////                cell.eventIndicator.numberOfEvents = 2
////            }
////            if datesWithEvent.contains(dateString) {
////                cell.eventIndicator.numberOfEvents = 1
////            }
////
////        }
//        
//        
//        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//            
//            let dateString = parent.dateFormatter2.string(from: date)
//            print("datesArray: ", datesWithMultipleEvents)// this is in "yyyy-MM-dd" format
//            print("Date String: ", dateString)// displays date in "yyyy-MM-dd" format
//            print("testDates: ", date)
//
//            if datesWithMultipleEvents.contains(dateString) {
//                return 2
//            }
//            if datesWithEvent.contains(dateString) {
//                return 1
//            }
//            return 0
//        }
//
//        
//        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
//            return [UIColor.white]
//        }
//                                              
////            func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
////                  let dateString = parent.dateFormatter2.string(from: date)
////                  
////                  if datesWithMultipleEvents.contains(dateString) {
////                      return [UIColor.blue]
////                  }
////                  
////                  return nil
////              }
//                                              
////            func calendar(_ calendar: FSCalendar, eventIndicatorFor date: Date) -> UIView {
////                  let eventIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 4))
////                  eventIndicator.layer.cornerRadius = 2
////                  eventIndicator.backgroundColor = UIColor.blue
////                  
////                  return eventIndicator
////              }
//        
//        //        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//        //            let key = parent.dateFormatter2.string(from: date)
//        //
//        //            if datesWithMultipleEvents.contains(key) {
//        //                return [UIColor.blue]
//        //            }
//        //
//        //            return nil
//        //        }
//        
//        func calendar(_ calendar: FSCalendar, shouldFillDefaultDates _: Date) -> Bool {
//            let shouldFillEventDot = true
//            //            let fontSize: CGFloat = 10 // Adjust the font size as needed for a bigger dot
//            let eventDefaultColor = UIColor.red // Adjust the color as needed
//            
//            if shouldFillEventDot {
//                let eventDot = CAShapeLayer()
//                //                let dotSize = CGSize(width: fontSize, height: fontSize)
//                let dotSize = CGSize(width: 50, height: 50) // Adjust the width and height as needed for a bigger dot
//                
//                let dotOrigin = CGPoint(x: (calendar.bounds.width - dotSize.width) / 2, y: (calendar.bounds.height - dotSize.height) / 2)
//                let dotRect = CGRect(origin: dotOrigin, size: dotSize)
//                eventDot.path = UIBezierPath(ovalIn: dotRect).cgPath
//                eventDot.fillColor = eventDefaultColor.cgColor
//                calendar.layer.addSublayer(eventDot)
//            }
//            return shouldFillEventDot
//        }
//        
//        
//    }
//}


struct CalView1: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var calendarschedualsvm = TeacherCalendarSvhedualsVM()
    @State var events: [EventM] = []
    //    @State var events1: [EventM]?
    
    @State var date : Date?
    @State var scope: FSCalendarScope = .month
    //    static let taskDateFormat: DateFormatter = {
    //        let formatter = DateFormatter.cachedFormatter
    //        formatter.dateFormat = "dd MMM yyyy"
    //        return formatter
    //    }()
    @Binding var selectedChild:ChildrenM?
//    let calendar = FSCalendar()
    var body: some View {
        VStack {
            if Helper.shared.getSelectedUserType() == .Parent && selectedChild == nil{
                VStack{
                    Text("You Have To Select Child First".localized())
                        .frame(minHeight:.infinity)
                        .frame(width: .infinity,alignment: .center)
                        .font(.title2)
                        .foregroundColor(ColorConstants.MainColor)
                }
            }else{
                VStack{
                    CustomTitleBarView(title: "Calendar") {
                        if scope == .week{
                            DispatchQueue.main.async(execute: {
                                date = nil
                                withAnimation{
                                    scope = .month
                                }
                            })
                        }else{
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    switch scope {
                    case .month:
                        //                        if let evvarr = events1{
                        //                            CalendarModuleView(selectedDate: $date, calendar: calendar, scope: .month, events: evvarr)
                        
                        if let evarr = calendarschedualsvm.CalendarScheduals{
                            ////                            CalendarModuleView1(studentEvents: evarr)
                            CalendarModuleView1(studentEvents:evarr, selectedDate: $date, scope: .month)
                            //
                        }else{
                            Spacer()
                        }
                        
                        
                    case .week:
                        ContentView3(selectedDate: .constant(date ?? Date()), scope: $scope, events: $events, onCancelEvent:{event in
                            if Helper.shared.getSelectedUserType() == .Teacher && event.teacherSubjectAcademicSemesterYearId ?? 0 > 0{
                                // add extra session
                                calendarschedualsvm.clearExtraSession()
                                
                                calendarschedualsvm.teacherlessonsessionid = event.teacherlessonsessionId
                                calendarschedualsvm.teacherLessonSessionSchedualSlotID = event.id
                                
                                calendarschedualsvm.extraLesson = DropDownOption(id: event.teacherlessonId ?? 0, Title: event.sessionName ?? "", LessonItem: LessonForListM(id: event.teacherlessonId ?? 0,groupDuration: event.groupDuration ?? 0,lessonName: event.sessionName ?? ""))
                                
                                calendarschedualsvm.ShowAddExtraSession = true
                            } else{
                                DispatchQueue.main.async {
                                    calendarschedualsvm.CancelCalendarCheduals(id: event.id ?? 0)
                                }
                            }
                        },onJoinEvent: {event in
                            //                            guard let eventid = event.bookTeacherlessonsessionDetailId else {return}
                            print("Joining event:",event)
                            
                            if let eventid = event.bookTeacherlessonsessionDetailId {
                                calendarschedualsvm.StudentAttendanceCalendarSchedual(id: eventid)
                            }else{
                                if Helper.shared.getSelectedUserType() == .Teacher,let eventid = event.id{
                                    calendarschedualsvm.StudentAttendanceCalendarSchedual(id: eventid)
                                }
                            }
                        })
                        .environment(\.layoutDirection,.leftToRight)

                        
                    @unknown default:
                        if let evarr = calendarschedualsvm.CalendarScheduals{
                            CalendarModuleView1(studentEvents:evarr, selectedDate: $date, scope: .month)
                        }
                        
                        //                        CalendarModuleView(selectedDate: $date, calendar: calendar, scope: .month,events: events)
                    }
                }
                
                
                .onChange(of: date, perform: { value in
                    //                    calendarschedualsvm.GetCalendarCheduals()
                    if value != nil{
                        withAnimation{
                            scope = .week
                        }
                    }
                })
                .onChange(of: calendarschedualsvm.CalendarScheduals ?? []){
                    newval in
//                    DispatchQueue.main.async(execute: {
                        events = newval
//                    })
                    //                    events1 = newval
//                    print("Updated Events: \(events)")
                    //                    calendar.reloadData()
                }
                
                //                .onAppear(perform: {
                //                    calendarschedualsvm.GetCalendarCheduals()
                //                })
            }
        }
        .localizeView()
        .hideNavigationBar()
        .showHud(isShowing: $calendarschedualsvm.isLoading)
        .showAlert(hasAlert: $calendarschedualsvm.isError, alertType: calendarschedualsvm.error)

        .bottomSheet(isPresented: $calendarschedualsvm.ShowAddExtraSession){
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
                        CustomDropDownField(iconName:"img_group_512380",placeholder: "ِLesson", selectedOption: $calendarschedualsvm.extraLesson,options:[],Disabled: true)
                        
                        let startDate = Date()
                        CustomDatePickerField(iconName:"img_group148",placeholder: "Date", selectedDateStr:$calendarschedualsvm.extraDate,startDate: startDate,datePickerComponent:.date,isvalid: calendarschedualsvm.isextraDatevalid)
                        
                        CustomDatePickerField(iconName:"img_maskgroup7cl",placeholder: "Start Time", selectedDateStr:$calendarschedualsvm.extraTime,timeZone:.current,datePickerComponent:.hourAndMinute,isvalid: calendarschedualsvm.isextraTimevalid)
                        
                    }
                    .padding(.top,5)
                    
                    HStack {
                        Group{
                            CustomButton(Title:"Save",IsDisabled: .constant(false), action:{
                                calendarschedualsvm.CreateExtraSession()
//                                calendarschedualsvm.ShowAddExtraSession = false
                            })
                            
                            CustomBorderedButton(Title:"Cancel",IsDisabled: .constant(false), action: {
                                calendarschedualsvm.clearExtraSession()
                                //                            subjectgroupvm.GetTeacherSubjectGroups()
                                calendarschedualsvm.ShowAddExtraSession = false
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
    }
}


#Preview{
    CalView1( selectedChild: .constant(nil))
}

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    var calendar: FSCalendar!
    var events: [String: [EventM]] = [:]
    var studentEvents: [EventM] = [] {
        didSet {
            prepareEvents()
        }
    }
    var selectedDateBinding: Binding<Date?>?
    var scope: FSCalendarScope = .month
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:  view.frame.size.height - 60))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scope = scope
        calendar.appearance.selectionColor = UIColor.mainBlue // Adjust the color as needed
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18)
        
        // Configure appearance for event dots
        calendar.appearance.eventDefaultColor = UIColor.mainBlue // Adjust the color as needed
        //        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7) // Adjust the offset as needed
        calendar.scrollDirection = .vertical
        
        view.addSubview(calendar)
        
        prepareEvents()
    }
    
    func prepareEvents() {
        events = [:] // Clear previous events
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        for event in studentEvents {
            if let dateString = event.date, let date = inputDateFormatter.date(from: dateString) {
                let formattedDateString = outputDateFormatter.string(from: date)
                if events[formattedDateString] == nil {
                    events[formattedDateString] = []
                }
                events[formattedDateString]?.append(event)
            }
        }
        
        if let calendar = calendar {
            calendar.reloadData() // Safely reload calendar data
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let eventsOnDate = events[dateString] {
            return min(eventsOnDate.count, 2) // Show up to 2 dots
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd"
        //        let dateString = dateFormatter.string(from: date)
        
        //        if let eventsOnDate = events[dateString] {
        // Do something with the events on the selected date
        selectedDateBinding?.wrappedValue = date
        //        }
    }
}


struct CalendarModuleView1: UIViewControllerRepresentable {
    
    var studentEvents: [EventM]
    @Binding var selectedDate: Date?
    var scope: FSCalendarScope
    
    func makeUIViewController(context: Context) -> CalendarViewController {
        let calendarVC = CalendarViewController()
        calendarVC.studentEvents = studentEvents
        calendarVC.selectedDateBinding = $selectedDate
        calendarVC.scope = scope
        return calendarVC
    }
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
        // If you need to update the view controller when SwiftUI state changes
    }
}
