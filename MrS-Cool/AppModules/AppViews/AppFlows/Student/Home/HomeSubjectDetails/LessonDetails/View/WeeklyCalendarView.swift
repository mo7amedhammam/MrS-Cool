//
//  WeeklyCalendarView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/02/2024.
//

import SwiftUI
import FSCalendar
//
//struct WeeklyCalendarRepresentableView: UIViewRepresentable {
//    @Binding var selectedDate: Date?
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    func makeUIView(context: Context) -> FSCalendar {
//        let calendar = FSCalendar()
//        calendar.delegate = context.coordinator
//        calendar.dataSource = context.coordinator
//        calendar.scope = .week
//        calendar.appearance.selectionColor = UIColor(ColorConstants.MainColor)
//        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18)
//        calendar.scrollDirection = .horizontal
//        
//        calendar.translatesAutoresizingMaskIntoConstraints = false
//        calendar.appearance.headerDateFormat = ""
//        calendar.appearance.weekdayTextColor = UIColor(.mainBlue)
//        calendar.appearance.titleDefaultColor = UIColor(.mainBlue)
//        calendar.appearance.todaySelectionColor = UIColor.clear
//        
//        // Disable selection for today's date
//        calendar.allowsSelection = true
//        calendar.allowsMultipleSelection = false
//        calendar.today = nil
//        
//        // Set the calendar to select the current date
//        calendar.select(Date(), scrollToDate: true)
//
//        return calendar
//    }
//    
//    func updateUIView(_ uiView: FSCalendar, context: Context) {
//        uiView.reloadData()
//    }
//    
//    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
//        var parent: WeeklyCalendarRepresentableView
//        
//        init(_ calendar: WeeklyCalendarRepresentableView) {
//            self.parent = calendar
//        }
//        
////        func calendar(_ calendar: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
////            self.parent.selectedDate = date
////        }
//        func calendar(_ calendar: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
//            // Step 1: Get midnight in your app’s time zone
//            var cal = Calendar(identifier: .gregorian)
////            cal.timeZone = appTimeZone  your business time zone variable
//            let startOfDayLocal = cal.startOfDay(for: date)
//
//            // Step 2: Convert local midnight to UTC
//            let secondsFromGMT = appTimeZone.secondsFromGMT(for: startOfDayLocal)
//            let utcDate = startOfDayLocal.addingTimeInterval(TimeInterval(+secondsFromGMT))
//            
//            // Step 3: Assign the UTC date to binding
//            self.parent.selectedDate = utcDate
//        }
//        
//        // Use this method to disable selection for dates before today
////        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
////            return date >= Calendar.current.startOfDay(for: Date())
////        }
//        func minimumDate(for calendar: FSCalendar) -> Date {
//            return calendar.today ?? Date()
//        }
//        
//    }
//}
//
//struct WeeklyCalendarView: View {
//    @Binding var selectedDate: Date?
//    
//    var body: some View {
//        VStack {
//            // Display selected date below the calendar
//            if let selectedDate = selectedDate {
////                Text("\(selectedDate, formatter: Self.taskDateFormat)")
//                Text(selectedDate.formatDate(format: "EEEE, MMMM d, yyyy"))
//                    .font(.semiBold(size: 13))
//                    .foregroundColor(.mainBlue)
//            }
//            WeeklyCalendarRepresentableView(selectedDate: $selectedDate)
//                .frame(height:300)
//                .padding(.bottom,-200)
//                .padding(.top,-40)
//        }
//        .onAppear(perform: {
//            print("appear selectedDate :\(selectedDate)") // 2024-11-06 22:00:00 +0000
//            print(selectedDate?.formatDate(format: "EEEE, MMMM d, yyyy"))
//            
//        })
//        .onChange(of: selectedDate, perform: { value in
//            guard let value else { return }
//            print("change date :\(value)") // 2024-11-06 22:00:00 +0000
//            print(value.formatDate(format: "EEEE, MMMM d, yyyy"))
//            
//        })
//    }
//    
////    static let taskDateFormat: DateFormatter = {
////        let formatter = DateFormatter.cachedFormatter
////        formatter.dateFormat = "EEEE dd, MMM yyyy"
////        return formatter
////    }()
//}



struct WeeklyCalendarView: View {
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack {
            // Display selected date below the calendar
            if let selectedDate = selectedDate {
                Text(formatDateForDisplay(selectedDate))
                    .font(.semiBold(size: 13))
                    .foregroundColor(.mainBlue)
            }
            WeeklyCalendarRepresentableView(selectedDate: $selectedDate)
                .frame(height: 300)
                .padding(.bottom, -200)
                .padding(.top, -40)
        }
        .onAppear(perform: {
            print("appear selectedDate: \(selectedDate?.description ?? "nil")")
            if let date = selectedDate {
                print("Formatted date: \(formatDateForDisplay(date))")
                print("App timezone: \(appTimeZone.identifier)")
            }
        })
        .onChange(of: selectedDate, perform: { value in
            print("change date: \(value?.description ?? "nil")")
            if let date = value {
                print("Formatted date: \(formatDateForDisplay(date))")
            }
        })
    }
    
    // Helper function to format date for display
    private func formatDateForDisplay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        formatter.timeZone = appTimeZone
        formatter.locale = LocalizeHelper.shared.currentLanguage == "en" ? Locale(identifier: "en") : Locale(identifier: "ar")
        return formatter.string(from: date)
    }
}

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
        
        // Configure selection
        calendar.allowsSelection = true
        calendar.allowsMultipleSelection = false
        calendar.today = nil
        
        // Set the calendar to select the current date
        let currentDate = Date()
        calendar.select(currentDate, scrollToDate: true)
        
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
            // The FSCalendar gives us a date, but we need to extract just the day/month/year
            // and create a new date that represents the start of that day in our app timezone
            
            var appCalendar = Calendar.current
            appCalendar.timeZone = appTimeZone
            
            // Extract date components from the selected date (using UTC to get the "calendar day")
            let utcCalendar = Calendar.current
            let components = utcCalendar.dateComponents([.year, .month, .day], from: date)
            
            // Create a new date using these components in our app timezone
            var newComponents = DateComponents()
            newComponents.year = components.year
            newComponents.month = components.month
            newComponents.day = components.day
            newComponents.hour = 0
            newComponents.minute = 0
            newComponents.second = 0
            newComponents.timeZone = appTimeZone
            
            if let startOfDayInAppTimeZone = appCalendar.date(from: newComponents) {
                print("User selected calendar date: \(date)")
                print("Extracted components: \(components)")
                print("Created start of day in app timezone: \(startOfDayInAppTimeZone)")
                print("App timezone: \(appTimeZone.identifier)")
                
                self.parent.selectedDate = startOfDayInAppTimeZone
            } else {
                print("❌ Failed to create date from components: \(newComponents)")
                // Fallback to original method
                let startOfDayInAppTimeZone = appCalendar.startOfDay(for: date)
                self.parent.selectedDate = startOfDayInAppTimeZone
            }
        }
        
        func minimumDate(for calendar: FSCalendar) -> Date {
            // Return today's date in app timezone
            var appCalendar = Calendar.current
            appCalendar.timeZone = appTimeZone
            return appCalendar.startOfDay(for: Date())
        }
    }
}


// MARK: - Enhanced Date Extension
extension Date {
    /// Formats date with proper timezone handling for API calls
    func formatDate(
        format: String,
        inputTimeZone: TimeZone = appTimeZone,
        outputLocal: SupportedLocale? = nil,
        outputTimeZone: TimeZone = appTimeZone
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = outputTimeZone
        formatter.locale = outputLocal?.locale ?? Locale.current
        return formatter.string(from: self)
    }
    
    /// Returns start of day in specified timezone
    func startOfDay(in timeZone: TimeZone) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        return calendar.startOfDay(for: self)
    }
    
    /// Debug description with timezone info
    var debugDescription: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z (EEEE)"
        formatter.timeZone = appTimeZone
        return formatter.string(from: self)
    }
}

// MARK: - Fixed String Extension
extension String {
    func ChangeDateFormat(
        FormatFrom inputFormat: String,
        FormatTo outputFormat: String,
        inputTimeZone: TimeZone = appTimeZone,
        outputTimeZone: TimeZone = appTimeZone,
        locale: Locale = .current
    ) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.timeZone = inputTimeZone
        inputFormatter.locale = locale
        
        guard let date = inputFormatter.date(from: self) else {
            print("❌ Failed to parse date: '\(self)' with format: '\(inputFormat)'")
            print("Expected format example: \(inputFormatter.string(from: Date()))")
            return self
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.timeZone = outputTimeZone
        outputFormatter.locale = locale
        
        let result = outputFormatter.string(from: date)
        print("✅ Date conversion: '\(self)' -> '\(result)'")
        return result
    }
}
