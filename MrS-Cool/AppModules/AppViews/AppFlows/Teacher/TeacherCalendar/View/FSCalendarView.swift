

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
//    var events: [EventM] // Replace YourEventModel with the actual type of your model
    var scope : FSCalendarScope
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
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
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.scope = scope
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.appearance.selectionColor = UIColor(ColorConstants.MainColor)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18) // Adjust the font size as needed
        
//        calendar.allowsSelection = false
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        context.coordinator.events = events
        uiView.reloadData()
//        if uiView.scope != scope {
//            uiView.setScope(scope, animated: true)
//        }

    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        
        var parent: CalendarModuleView
        var events: [EventM] = []
        
        init(_ calender: CalendarModuleView) {
            self.parent = calender
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            self.parent.selectedDate = date
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            // Check if the date has an event in your array
            return events.filter { $0.date.flatMap { ISO8601DateFormatter().date(from: $0) }?.isInSameDayAs(date) ?? false }.count
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
            let matchingEvents = events.filter { event in
                if let eventDate = event.date.flatMap({ ISO8601DateFormatter().date(from: $0) }), eventDate.isInSameDayAs(date) {
                    return true
                }
                return false
            }
            
            // Use different colors based on the cancellation status
            return matchingEvents.map { event in
                return event.isCancel ?? false ? UIColor.red : UIColor.green
            }
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

            if let selectedDate = date {
                Text("Selected Bay: \(selectedDate)")
                    .padding()
            }

            switch scope {
            case .month:
                CalendarModuleView(selectedDate: $date, scope: .month)
                    .frame(height: 300.0, alignment: .center)
            case .week:
                CalendarModuleView(selectedDate: $date, scope: .week)
                    .frame(height: 300.0, alignment: .center)
            @unknown default:
                CalendarModuleView(selectedDate: $date, scope: .month)
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
