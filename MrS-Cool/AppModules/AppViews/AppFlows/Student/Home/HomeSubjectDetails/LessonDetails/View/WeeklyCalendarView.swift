//
//  WeeklyCalendarView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/02/2024.
//

import SwiftUI
import FSCalendar

struct WeeklyCalendarRepresentableView: UIViewRepresentable {
    @Binding var selectedDate: Date?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.scope = .week
        calendar.appearance.selectionColor = UIColor(ColorConstants.MainColor)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18)
        calendar.scrollDirection = .horizontal
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.headerDateFormat = ""
        calendar.appearance.weekdayTextColor = UIColor(.mainBlue)
        calendar.appearance.titleDefaultColor = UIColor(.mainBlue)
        calendar.appearance.todaySelectionColor = UIColor.clear
        
        // Disable selection for today's date
        calendar.allowsSelection = true
        calendar.allowsMultipleSelection = false
        calendar.today = nil
        
        // Set the calendar to select the current date
        calendar.select(Date(), scrollToDate: true)

        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData()
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: WeeklyCalendarRepresentableView
        
        init(_ calendar: WeeklyCalendarRepresentableView) {
            self.parent = calendar
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
            self.parent.selectedDate = date
        }
        
        // Use this method to disable selection for dates before today
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            return date >= Calendar.current.startOfDay(for: Date())
        }
        func minimumDate(for calendar: FSCalendar) -> Date {
            return calendar.today ?? Date()
        }
        
    }
}

struct WeeklyCalendarView: View {
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack {
            // Display selected date below the calendar
            if let selectedDate = selectedDate {
                Text("\(selectedDate, formatter: Self.taskDateFormat)")
                    .font(.SoraSemiBold(size: 13))
                    .foregroundColor(.mainBlue)
            }
            WeeklyCalendarRepresentableView(selectedDate: $selectedDate)
                .frame(height:300)
                .padding(.bottom,-200)
                .padding(.top,-40)
        }
    }
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd, MMM yyyy"
        return formatter
    }()
}
