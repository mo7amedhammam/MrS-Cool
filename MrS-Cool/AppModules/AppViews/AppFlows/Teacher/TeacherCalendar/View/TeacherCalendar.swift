import SwiftUI
import EventKit

struct CalView: View {

    @StateObject var calendarschedualsvm = TeacherCalendarSvhedualsVM()
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter: DateFormatter
    
    @State private var selectedDate = Date()
    @State private var viewMode: CalendarViewMode = .month // Default view mode

//    @State var events: [EventM] = []
  @State var events: [EventM] =  [EventM(
        id: 1,
        groupName: "Group A",
        date: "2023-12-17T11:10:50.402Z",
        timeFrom: "09:00:00",
        timeTo: "11:00:00",
        isCancel: false,
        cancelDate: nil
    ), EventM(
        id: 2,
        groupName: "Group B",
        date: "2023-12-11T11:10:50.402Z",
        timeFrom: "14:00:00",
        timeTo: "16:00:00",
        isCancel: true,
        cancelDate: "2023-12-18T10:30:00.402Z"
    ), EventM(
        id: 3,
        groupName: "Group C",
        date: "2023-12-21T11:10:50.402Z",
        timeFrom: "18:00:00",
        timeTo: "20:00:00",
        isCancel: false,
        cancelDate: nil
    ), EventM(
        id: 4,
        groupName: "Group D",
        date: "2023-12-13T11:10:50.402Z",
        timeFrom: "10:00:00",
        timeTo: "12:00:00",
        isCancel: false,
        cancelDate: nil
    )]
    init(calendar: Calendar) {
        self.calendar = calendar
        self.monthFormatter = DateFormatter()
        self.monthFormatter.dateFormat = "MMMM yyyy"
        self.dayFormatter = DateFormatter()
        self.dayFormatter.dateFormat = "dd"
        self.weekDayFormatter = DateFormatter()
        self.weekDayFormatter.dateFormat = "EEE"
        self.fullFormatter = DateFormatter()
        self.fullFormatter.dateFormat = "MMMM dd yyyy"
    }

    var body: some View {
        VStack {
            Picker("View Mode", selection: $viewMode) {
                Text("Month").tag(CalendarViewMode.month)
                Text("Week").tag(CalendarViewMode.week)
                Text("Day").tag(CalendarViewMode.day)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            HStack {
                Button(action: {
                    changeCalendarDate(by: -1, granularity:viewMode == .month ? .month:viewMode == .week ? .weekOfMonth:.day)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                }
                .padding(.leading, 20)

                Spacer()

                Text(viewMode == .month ? monthFormatter.string(from: selectedDate) : viewMode == .week ? monthFormatter.string(from: selectedDate) : fullFormatter.string(from: selectedDate).ChangeDateFormat(FormatFrom: "MMMM dd, yyyy", FormatTo: "dd MMM yyyy"))
                    .font(.title)
                    .bold()

                Spacer()

                Button(action: {
                    changeCalendarDate(by: 1, granularity:viewMode == .month ? .month:viewMode == .week ? .weekOfMonth:.day)
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                }
                .padding(.trailing, 20)
            }
 
            // ...
            if viewMode == .month {
                CalendarView(
                    calendar: calendar,
                    date: $selectedDate,
                    viewMode: $viewMode,
                    content: { date in
                        Button(action: { selectedDate = date
                            viewMode = .week
                        }) {
                            Text(dayFormatter.string(from: date))
                                .padding(8)
                                .foregroundColor(.mainBlue)
                                .background(
                                    Circle()
                                        .fill(isDateInArray(date: date) ? .mainBlue : Color.clear) // Circular background
                                )
                                .overlay(
                                    Text(dayFormatter.string(from: date))
                                        .foregroundColor(isDateInArray(date: date) ? .white : .mainBlue)
                                )
                        }
                    },
                    trailing: { date in
                        Text(dayFormatter.string(from: date))
                            .foregroundColor(.secondary)
                    },
                    header: { date in
                        Text(weekDayFormatter.string(from: date))
                    },
                    title: { date in }
                )
                
                List {
                    let filteredEvents = events.filter { event in
                        if let eventDateStr = event.date, let eventDate =  eventDateStr.toDate(){
                            return calendar.isDate(eventDate, equalTo: selectedDate, toGranularity: .month)
                        }
                        return false
                    }

                    if !filteredEvents.isEmpty {
                        ForEach(filteredEvents) { event in
                            Text("\(event.groupName ?? "") at \(event.timeFrom ?? "") - \(event.timeTo ?? "")")
                        }
                    } else {
                        Text("No events for this Month.")
                    }
                }
            } else if viewMode == .week {
                WeekView(
                    calendar: calendar,
                    date: $selectedDate,
                    content: { date in
                        Button(action: { selectedDate = date }) {
                            Text(dayFormatter.string(from: date))
                                .padding(8)
                                .foregroundColor(.mainBlue)
                                .background(
                                    Circle()
                                        .fill(isDateInArray(date: date) ? .mainBlue : Color.clear) // Circular background
                                )
                                .overlay(
                                    Text(dayFormatter.string(from: date))
                                        .foregroundColor(isDateInArray(date: date) ? .white : .mainBlue)
                                )
                        }
                    },
                    header: { weekStartDate in
                        Text(weekDayFormatter.string(from: weekStartDate))
                    }
                )
                
                List {
                    let filteredEvents = events.filter { event in
                        if let eventDateStr = event.date, let eventDate =  eventDateStr.toDate(){
                            return calendar.isDate(eventDate, equalTo: selectedDate, toGranularity: .weekOfMonth)
                        }
                        return false
                    }

                    if !filteredEvents.isEmpty {
                        ForEach(filteredEvents) { event in
                            Text("\(event.groupName ?? "") at \(event.timeFrom ?? "") - \(event.timeTo ?? "")")
                        }
                    } else {
                        Text("No events for this week.")
                    }
                }
            } else if viewMode == .day {
                VStack {
                    // Implement day view
                    List {
                        let filteredEvents = events.filter { event in
                            if let eventDateStr = event.date, let eventDate =  eventDateStr.toDate(){
                                return calendar.isDate(eventDate, equalTo: selectedDate, toGranularity: .day)
                            }
                            return false
                        }

                        if !filteredEvents.isEmpty {
                            ForEach(filteredEvents) { event in
                                Text("\(event.groupName ?? "") at \(event.timeFrom ?? "") - \(event.timeTo ?? "")")
                            }
                        } else {
                            Text("No events for this Day.")
                        }
                    }
                }
                .padding()
            }

            Spacer()
        }
        .padding()
        .onAppear(perform: {
            requestCalendarAccess()
        })
        .onChange(of: calendarschedualsvm.CalendarScheduals){newval in
            self.events = newval
        }
        .onDisappear(perform: {
            calendarschedualsvm.cleanup()
        })
    }
    
    // Helper method to convert EventM to EKEvent
    
    private func changeCalendarDate(by amount: Int, granularity: Calendar.Component) {
        selectedDate = calendar.date(byAdding: granularity, value: amount,to: selectedDate)!
    }
    
      func isDateInArray(date: Date) -> Bool {
          // Convert events' date strings to Date objects with the new format
            let eventsDates = events.compactMap { event -> Date? in
                if let dateString = event.date {
                    return dateString.toDate()
                }
                return nil
            }
            // Check if the selected date is in the same day as any of the events
            return eventsDates.contains { $0.isInSameDayAs(date) }
    }
}

// MARK: - Previews
#Preview{
            CalView(calendar: Calendar(identifier: .gregorian))
}

