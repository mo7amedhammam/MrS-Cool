import SwiftUI

// Model representing events
struct EventModel: Identifiable {
    let id = UUID()
    let date: Date
    let time: Date
    let title: String
}
struct CalView: View {
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter: DateFormatter

    @State private var selectedDate = Date()
    @State private var viewMode: CalendarViewMode = .month // Default view mode
    // Example highlighted dates with events
     private let highlightedDates: [EventModel] = [
         EventModel(date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, time: Date(), title: "Event 1"),
         EventModel(date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!, time: Date(), title: "Event 2"),
         EventModel(date: Calendar.current.date(byAdding: .day, value: 10, to: Date())!, time: Date(), title: "Event 3")
         // Add more events as needed
     ]
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

//            Text("Selected date: \(fullFormatter.string(from: selectedDate))")
//                .bold()
//                .foregroundColor(.red)

            HStack {
                Button(action: {
                    changeCalendarDate(by: -1, granularity:viewMode == .month ? .month:viewMode == .week ? .weekOfMonth:.day)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                }
                .padding(.leading, 20)

                Spacer()

                Text(viewMode == .month ? monthFormatter.string(from: selectedDate) : viewMode == .week ? weekDayFormatter.string(from: selectedDate).ChangeDateFormat(FormatFrom: "EEE", FormatTo: "dd MMM yyyy"):fullFormatter.string(from: selectedDate).ChangeDateFormat(FormatFrom: "MMMM dd, yyyy", FormatTo: "dd MMM yyyy"))
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
                    trailing: { date in
                        Text(dayFormatter.string(from: date))
                            .foregroundColor(.secondary)
                    },
                    header: { date in
                        Text(weekDayFormatter.string(from: date))
                    },
                    title: { date in }
                )
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
                
                // Display the list of events for the week
                               List {
                                   ForEach(highlightedDates.filter { calendar.isDate($0.date, equalTo: selectedDate, toGranularity: .weekOfMonth) }) { event in
                                       Text("\(event.title) at \(event.time, style: .time)")
                                   }
                               }
//                           }
            } else if viewMode == .day {
                VStack {
                    // Implement day view
                    
                    // Display the list of events for the day
                                     List {
                                         ForEach(highlightedDates.filter { calendar.isDate($0.date, equalTo: selectedDate, toGranularity: .day) }) { event in
                                             Text("\(event.title) at \(event.time, style: .time)")
                                         }
                                     }
                }
                .padding()
            }

            // ...


            // ...


            
            Spacer()
        }
        .padding()
    }

    private func changeCalendarDate(by amount: Int, granularity: Calendar.Component) {
        selectedDate = calendar.date(byAdding: granularity, value: amount,to: selectedDate)!
    }
    private func isDateInArray(date: Date) -> Bool {
        // Implement logic to check if date is in your array of dates and times
        // For example, you can have an array named highlightedDates
        highlightedDates.contains { $0.date.isInSameDayAs(date) }
//        return false
    }

}

// MARK: - WeekView

struct WeekView<Content: View, Header: View>: View {
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Content
    private let header: (Date) -> Header
    private let daysInWeek = 7

    init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Content,
        @ViewBuilder header: @escaping (Date) -> Header
    ) {
        self.calendar = calendar
        self._date = date
        self.content = content
        self.header = header
    }

    var body: some View {
        let weekStartDate = date.startOfWeek(using: calendar)
        let days = (0..<7).map { weekStartDate.advanced(by: TimeInterval($0 * 24 * 60 * 60)) }
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                      ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                      ForEach(days, id: \.self) { date in
                              content(date)
                }
        }
    }
}

private extension Date {
    func startOfWeek(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        ) ?? self
    }
    func isInSameDayAs(_ date: Date) -> Bool {
           return Calendar.current.isDate(self, inSameDayAs: date)
       }
}
// MARK: - Component

public struct CalendarView<Day: View, Header: View, Title: View, Trailing: View>: View {
    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    @Binding private var viewMode: CalendarViewMode // Add viewMode binding
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title

    // Constants
    private let daysInWeek = 7


    public init(
        calendar: Calendar,
        date: Binding<Date>,
        viewMode: Binding<CalendarViewMode>, // Add viewMode binding
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
        self.calendar = calendar
        self._date = date
        self._viewMode = viewMode // Initialize viewMode
        self.content = content
        self.trailing = trailing
        self.header = header
        self.title = title
    }

    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()

        return LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                  Section(header: title(month)) {
                      ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                      ForEach(days, id: \.self) { date in
                          if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                              content(date)
                          } else {
                              trailing(date)
                          }
                }
            }
        }
    }
}

public enum CalendarViewMode: String, CaseIterable {
    case month
    case week
    case day
}

// MARK: - Conformances

extension CalendarView: Equatable {
    public static func == (lhs: CalendarView<Day, Header, Title, Trailing>, rhs: CalendarView<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

// MARK: - Helpers

private extension CalendarView {
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }

        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]

        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }

            guard date < dateInterval.end else {
                stop = true
                return
            }

            dates.append(date)
        }

        return dates
    }

    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}

// MARK: - Previews

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalView(calendar: Calendar(identifier: .gregorian))
        }
    }
}
#endif

