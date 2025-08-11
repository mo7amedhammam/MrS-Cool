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
        
//        func calendar(_ calendar: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
//            self.parent.selectedDate = date
//        }
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
            // Step 1: Get midnight in your app’s time zone
            var cal = Calendar(identifier: .gregorian)
//            cal.timeZone = appTimeZone  your business time zone variable
            let startOfDayLocal = cal.startOfDay(for: date)

            // Step 2: Convert local midnight to UTC
            let secondsFromGMT = appTimeZone.secondsFromGMT(for: startOfDayLocal)
            let utcDate = startOfDayLocal.addingTimeInterval(TimeInterval(+secondsFromGMT))
            
            // Step 3: Assign the UTC date to binding
            self.parent.selectedDate = utcDate
        }
        
        // Use this method to disable selection for dates before today
//        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//            return date >= Calendar.current.startOfDay(for: Date())
//        }
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
//                Text("\(selectedDate, formatter: Self.taskDateFormat)")
                Text("\(selectedDate)".ChangeDateFormat(FormatFrom: "yyyy-MM-dd HH:mm:ss Z", FormatTo: "EEEE, MMMM d, yyyy"))
                    .font(.semiBold(size: 13))
                    .foregroundColor(.mainBlue)
            }
            WeeklyCalendarRepresentableView(selectedDate: $selectedDate)
                .frame(height:300)
                .padding(.bottom,-200)
                .padding(.top,-40)
        }
        .onAppear(perform: {
            print("appear selectedDate :\(selectedDate)") // 2024-11-06 22:00:00 +0000
            print("\(selectedDate)".ChangeDateFormat(FormatFrom: "yyyy-MM-dd HH:mm:ss Z", FormatTo: "EEEE, MMMM d, yyyy",inputTimeZone: appTimeZone,outputTimeZone: appTimeZone))
            
        })
        .onChange(of: selectedDate, perform: { value in
            print("change date :\(value)") // 2024-11-06 22:00:00 +0000
            print("\(value)".ChangeDateFormat(FormatFrom: "yyyy-MM-dd HH:mm:ss Z", FormatTo: "EEEE, MMMM d, yyyy",inputTimeZone: appTimeZone,outputTimeZone: appTimeZone))
            
        })
    }
    
//    static let taskDateFormat: DateFormatter = {
//        let formatter = DateFormatter.cachedFormatter
//        formatter.dateFormat = "EEEE dd, MMM yyyy"
//        return formatter
//    }()
}
