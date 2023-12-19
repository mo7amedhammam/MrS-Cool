

import SwiftUI
import FSCalendar

// MARK: - EventM
struct EventM: Codable {
    var teacherLessonSessionSchedualSlotID: Int?
    var groupName, date, timeFrom, timeTo: String?
    var isCancel: Bool?
    var cancelDate: String?
    
    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate
    }
}

//class UserData: ObservableObject{
//    @Published var name = "Helsdfsflo"
//    @Published var date: Date?
//}
struct CalendarModuleView: UIViewRepresentable {
    @Binding var selectedDate: Date?
    var scope: FSCalendarScope
//    var events: [EventM]
    let events: [EventM]?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

//    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)

//    var datesWithEvent = ["2020-12-23", "2020-12-16", "2020-12-18", "2020-12-14", "2020-12-06"]
//    var datesWithMultipleEvents = ["2020-12-03", "2020-12-13", "2020-12-11", "2020-10-03", "2020-12-06"]
    fileprivate lazy var dateFormatter2: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         return formatter
     }()

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.scope = scope
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.appearance.selectionColor = UIColor.mainBlue // Adjust the color as needed
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16)
        
        // Configure appearance for event dots
           calendar.appearance.eventDefaultColor = UIColor.mainBlue // Adjust the color as needed
//           calendar.appearance.eventSelectionColor = UIColor.red // Adjust the color as needed
           calendar.appearance.eventOffset = CGPoint(x: 0, y: -7) // Adjust the offset as needed
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        context.coordinator.events = events ?? []
        context.coordinator.datesWithEvent = events?.compactMap { $0.date?.prefix(10).description } ?? []
        
        context.coordinator.datesWithMultipleEvents = Array(Set(context.coordinator.datesWithEvent.filter { date in
               let count = context.coordinator.datesWithEvent.filter { $0 == date }.count
               return count > 1
           }))
           uiView.reloadData()
       }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
        var parent: CalendarModuleView
        var events: [EventM] = []
        var datesWithEvent: [String] = []
        var datesWithMultipleEvents: [String] = []
        
        init(_ calender: CalendarModuleView) {
            self.parent = calender
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            self.parent.selectedDate = date
        }

        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let dateString = parent.dateFormatter2.string(from: date)

            if datesWithMultipleEvents.contains(dateString) {
                return 2
            }
            if datesWithEvent.contains(dateString) {
                return 1
            }

            return 0
        }

        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
            return [UIColor.white]
        }
        
//        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//            let key = parent.dateFormatter2.string(from: date)
//
//            if datesWithMultipleEvents.contains(key) {
//                return [UIColor.blue]
//            }
//
//            return nil
//        }
        
        
        func calendar(_ calendar: FSCalendar, shouldFillDefaultDates _: Date) -> Bool {
            let shouldFillEventDot = true
//            let fontSize: CGFloat = 10 // Adjust the font size as needed for a bigger dot
            let eventDefaultColor = UIColor.red // Adjust the color as needed

            if shouldFillEventDot {
                let eventDot = CAShapeLayer()
//                let dotSize = CGSize(width: fontSize, height: fontSize)
                let dotSize = CGSize(width: 50, height: 50) // Adjust the width and height as needed for a bigger dot

                let dotOrigin = CGPoint(x: (calendar.bounds.width - dotSize.width) / 2, y: (calendar.bounds.height - dotSize.height) / 2)
                let dotRect = CGRect(origin: dotOrigin, size: dotSize)
                eventDot.path = UIBezierPath(ovalIn: dotRect).cgPath
                eventDot.fillColor = eventDefaultColor.cgColor
                calendar.layer.addSublayer(eventDot)
            }


            return shouldFillEventDot
        }


    }
    
}


struct CalView1: View {
    
    let events: [EventM] = [EventM(
        teacherLessonSessionSchedualSlotID: 1,
        groupName: "Group A",
        date: "2023-12-17'T'11:10:50.402Z",
        timeFrom: "09:00:00",
        timeTo: "11:00:00",
        isCancel: false,
        cancelDate: nil
    ), EventM(
        teacherLessonSessionSchedualSlotID: 2,
        groupName: "Group B",
        date: "2023-12-18T11:10:50.402Z",
        timeFrom: "14:00:00",
        timeTo: "16:00:00",
        isCancel: true,
        cancelDate: "2023-12-18T10:30:00.402Z"
    ), EventM(
        teacherLessonSessionSchedualSlotID: 3,
        groupName: "Group C",
        date: "2023-12-18T11:10:50.402Z",
        timeFrom: "18:00:00",
        timeTo: "20:00:00",
        isCancel: false,
        cancelDate: nil
    ), EventM(
        teacherLessonSessionSchedualSlotID: 4,
        groupName: "Group D",
        date: "2023-12-20T11:10:50.402Z",
        timeFrom: "10:00:00",
        timeTo: "12:00:00",
        isCancel: false,
        cancelDate: nil
    )]
    @State var date : Date?
    @State private var scope: FSCalendarScope = .month
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Picker("View Mode", selection: $scope) {
                Text("Month").tag(FSCalendarScope.month)
                Text("Week").tag(FSCalendarScope.week)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            HStack {
                Button(action: {
                    showNextDate()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                }
                .padding(.leading, 20)

                Spacer()

                Text(scope == .month ? "Selected Month: \(date?.formatted() ?? "")" :
                    scope == .week ? "Selected Week: \(date?.formatted() ?? "")" : "")
                    .padding()

                Spacer()

                Button(action: {
                    showNextDate()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                }
                .padding(.trailing, 20)
            }

//            if let selectedDate = date {
//                Text("Selected Bay: \(selectedDate)")
//                    .padding()
//            }

            switch scope {
            case .month:
                CalendarModuleView(selectedDate: $date, scope: .month, events: events)
                    .frame(height: 300.0, alignment: .center)
            case .week:
                CalendarModuleView(selectedDate: $date, scope: .week,events: events)
                    .frame(height: 300.0, alignment: .center)
            @unknown default:
                CalendarModuleView(selectedDate: $date, scope: .month,events: events)
            }

            Spacer()
        }
    }

    private func showNextDate() {
        if let currentDate = date {
            let granularity: Calendar.Component = (scope == .month) ? .month : .weekOfMonth
            date = Calendar.current.date(byAdding: granularity, value: 1, to: currentDate)
        }
    }
}


#Preview{
    CalView1()
}
