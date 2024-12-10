//
//  CalendarHelper.swift
//  MrS-Cool
//
//  Created by wecancity on 19/12/2023.
//

import SwiftUI
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
                }.gesture(
                                  DragGesture()
                                      .onEnded { value in
                                          if value.translation.width > 100 {
                                              // Swipe right, move to the previous week
                                              self.date = calendar.date(byAdding: .weekOfYear, value: -1, to: self.date) ?? self.date
                                          } else if value.translation.width < -100 {
                                              // Swipe left, move to the next week
                                              self.date = calendar.date(byAdding: .weekOfYear, value: 1, to: self.date) ?? self.date
                                          }
                                      }
                              )
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
        self.calendar.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage)
    }
}

extension Date {
    func startOfWeek(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        ) ?? self
    }
    func isInSameDayAs(_ date: Date) -> Bool {
           return Calendar.current.isDate(self, inSameDayAs: date)
       }
}
