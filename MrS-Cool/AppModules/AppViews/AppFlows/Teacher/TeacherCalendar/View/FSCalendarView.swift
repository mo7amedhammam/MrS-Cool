

import SwiftUI
import FSCalendar

// MARK: - EventM
struct EventM: Codable,Identifiable {
    var id: Int?
    var groupName, date, timeFrom, timeTo: String?
    var isCancel: Bool?
    var cancelDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "teacherLessonSessionSchedualSlotId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate
    }
}
struct CalendarModuleView: UIViewRepresentable {
    @Binding var selectedDate: Date?
    var scope: FSCalendarScope
    let events: [EventM]?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

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
        id: 1,
        groupName: "Group A",
        date: "2023-12-17'T'11:10:50.402Z",
        timeFrom: "09:00:00",
        timeTo: "11:00:00",
        isCancel: false,
        cancelDate: nil
    ), EventM(
        id: 2,
        groupName: "Group B",
        date: "2023-12-18T11:10:50.402Z",
        timeFrom: "14:00:00",
        timeTo: "16:00:00",
        isCancel: true,
        cancelDate: "2023-12-18T10:30:00.402Z"
    ), EventM(
        id: 3,
        groupName: "Group C",
        date: "2023-12-18T11:10:50.402Z",
        timeFrom: "18:00:00",
        timeTo: "20:00:00",
        isCancel: false,
        cancelDate: nil
    ), EventM(
        id: 4,
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
            
            // Display a list of events for the selected date or week
//            if let selectedDate = date {
            let filteredEvents = filterEventsForSelectedDate(selectedDate: date ?? Date(), scope: scope, events: events)
                List(filteredEvents) { event in
                    Text(event.groupName ?? "")
                }
//            }
            Spacer()
        }
    }
    
    private func showNextDate() {
        if let currentDate = date {
            let granularity: Calendar.Component = (scope == .month) ? .month : .weekOfMonth
            date = Calendar.current.date(byAdding: granularity, value: 1, to: currentDate)
        }
    }
    func filterEventsForSelectedDate(selectedDate: Date, scope: FSCalendarScope, events: [EventM]) -> [EventM] {
        switch scope {
        case .month:
            let selectedMonth = Calendar.current.component(.month, from: selectedDate)
            return events.filter { event in
                guard let eventDateStr = event.date,
                      let eventDate = dateFormatter2.date(from: String(eventDateStr.prefix(10))) else {
                    return false
                }
                return Calendar.current.component(.month, from: eventDate) == selectedMonth
            }
        case .week:
            let selectedWeek = Calendar.current.component(.weekOfYear, from: selectedDate)
            return events.filter { event in
                guard let eventDateStr = event.date,
                      let eventDate = dateFormatter2.date(from: String(eventDateStr.prefix(10))) else {
                    return false
                }
                return Calendar.current.component(.weekOfYear, from: eventDate) == selectedWeek
            }
        @unknown default:
            return []
        }
    }
      var dateFormatter2: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         return formatter
     }()
}


#Preview{
    CalView1()
}
