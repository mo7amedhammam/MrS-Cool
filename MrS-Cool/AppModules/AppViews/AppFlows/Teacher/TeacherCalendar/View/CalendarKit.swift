//
//  CalendarKit.swift
//  MrS-Cool
//
//  Created by wecancity on 20/12/2023.
//

import UIKit
import CalendarKit
import SwiftUI
import FSCalendar

import Foundation

struct CalendarFormatters {
    static let dateIntervalFormatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    //    static let timeFormatter: DateFormatter = {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "HH:mm:ss"
    //        return formatter
    //    }()
    
    static let dayNameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage)
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    static let dayNumberFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage)
        formatter.setLocalizedDateFormatFromTemplate("dd")
        return formatter
    }()
}


final class CustomCalendarExampleController: DayViewController {
    var selectedDate: Date?
    var events: [EventM] = [] {
        didSet {
            // Update events and reload data
            reloadData()
        }
    }
    var onCancelEvent: ((EventM) -> Void)?
    var onJoinEvent: ((EventM) -> Void)?
    var onEventSelected: ((EventM) -> Void)?
    
    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()
    
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]
    
    override func loadView() {
        //    calendar.timeZone = TimeZone(identifier: "Africa/Cairo")!
        //      calendar.timeZone = TimeZone(identifier: "UTC")!
        dayView = DayView(calendar: calendar)
        dayView.move(to: selectedDate ?? Date())
        view = dayView
        
        //        calendar.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CalendarKit Demo"
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        //        reloadData()
        setupDayView()
    }
    private func setupDayView() {
        
        // Update day names based on current locale
        let calendar = Calendar.current
        let today = Date()
        let weekdaySymbols = calendar.shortWeekdaySymbols
        
        // Find the first day of the current week
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        components.weekday = calendar.firstWeekday
        guard let firstDayOfWeek = calendar.date(from: components) else { return }
        
        // Generate localized day names for the week
        _ = (0..<7).map { dayOffset -> String in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: firstDayOfWeek) else {
                return weekdaySymbols[dayOffset]
            }
            return CalendarFormatters.dayNameFormatter.string(from: date)
        }
        
    }
    
    
    // MARK: EventDataSource
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        // Filter events for the selected date
        let eventsForSelectedDate = events.filter { eventM in
            if let dateString = eventM.date,
               let eventDate = CalendarFormatters.dateFormatter.date(from: dateString) {
                return Calendar.current.isDate(eventDate, inSameDayAs: date)
            }
            return false
        }
        
        // Convert EventM objects to EventDescriptor
        let eventDescriptors = eventsForSelectedDate.compactMap { eventM in
            let event = Event()
            
            // Configure event properties based on your EventM model
            if let dateString = eventM.date,
               let eventDate = CalendarFormatters.dateFormatter.date(from: dateString),
               let timeFromString = eventM.timeFrom,
               let timeToString = eventM.timeTo {
                
                // Extract hours and minutes from the time strings
                let timeFromComponents = timeFromString.split(separator: ":").map { Int($0) ?? 0 }
                let timeToComponents = timeToString.split(separator: ":").map { Int($0) ?? 0 }
                
                if timeFromComponents.count == 3, timeToComponents.count == 3 {
                    let calendar = Calendar.current
                    //                    calendar.timeZone = TimeZone(identifier: "GMT")!
                    //                        calendar.locale = Locale(identifier: "ar")
                    
                    var startTimeComponents = DateComponents()
                    startTimeComponents.hour = timeFromComponents[0]
                    startTimeComponents.minute = timeFromComponents[1]
                    
                    var endTimeComponents = DateComponents()
                    endTimeComponents.hour = timeToComponents[0]
                    endTimeComponents.minute = timeToComponents[1]
                    
                    if let startHour = startTimeComponents.hour,
                       let startMinute = startTimeComponents.minute,
                       let endHour = endTimeComponents.hour,
                       let endMinute = endTimeComponents.minute {
                        
                        let startDate = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: eventDate)!
                        var endDate = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: eventDate)!
                        
                        // Handle case where end time is before start time (e.g., crosses midnight)
                        if endDate <= startDate {
                            endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate) ?? endDate
                        }
                        
                        event.dateInterval = DateInterval(start: startDate, end: endDate)
                        event.text = "\(eventM.groupName ?? "")"
                        
                        // Set color based on conditions
                        let now = Date()
                        if eventDate < calendar.startOfDay(for: now) {
                            // Event is before today
                            event.color = .red
                        } else if eventM.isCancel ?? false {
                            // Event is canceled
                            event.color = .red
                        } else if endDate < now {
                            // Event end time is in the past
                            event.color = .red
                        } else {
                            // Default color for other events
                            event.color = .green
                        }
                        
                        // Store the EventM object in userInfo
                        event.userInfo = eventM
                        print("------*-*--*-\n",eventM)
                        print("------*-*--*-\n",event)
                        
                        return event // Return the configured event
                    }
                }
            }
            return nil // Return nil if any of the required components are missing
        }
        
        return eventDescriptors
    }
    
    private func cancelEvent(_ event: Event) {
        // Implement the logic to cancel the event here
        // You may need to update your data model, set a flag, or perform any necessary actions
        // After canceling the event, you should update the events array and call reloadData()
        
        if generatedEvents.firstIndex(where: { $0 === event }) != nil {
            //            generatedEvents.remove(at: index)
            reloadData()
        }
    }
    private func isEventCanceled(_ event: Event) -> Bool {
        // Implement the logic to check if the event is canceled
        // You may need to access your data model or perform any necessary checks
        // Return true if the event is canceled, otherwise false
        return false
    }
    
    // MARK: DayViewDelegate
    private var createdEvent: EventDescriptor?
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
        
        if let eventM = descriptor.userInfo as? EventM {
            onEventSelected?(eventM)
        }
        
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        //        endEventEditing()
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        //        beginEditing(event: descriptor, animated: true)
        if let eventM = events.first(where: { event in
            let dateString = event.date ?? ""
            if let eventDate = CalendarFormatters.dateFormatter.date(from: dateString) {
                return Calendar.current.isDate(eventDate, inSameDayAs: descriptor.dateInterval.start)
            }
            return false
        }) {
            // Check if the event is in the past or is canceled
            let currentDate = Date()
            if let eventDate = CalendarFormatters.dateFormatter.date(from: eventM.date ?? "") {
                if eventDate <= currentDate || eventM.isCancel == true {
                    // The event is in the past or is canceled, do not show the action sheet
                    return
                }
            }
            
            //            let alertController = UIAlertController(title: "Event Options", message: nil, preferredStyle: .actionSheet)
            //
            //            // Add a Cancel option
            //            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            //
            //            // Add an option to cancel the event
            //            alertController.addAction(UIAlertAction(title: "Cancel Event", style: .destructive) { [weak self] _ in
            //                guard let self = self else {return}
            //                // Handle the cancellation of the event here
            //                //              self.cancelEvent(descriptor)
            //                self.onCancelEvent?(eventM)
            //                self.reloadData()
            //            })
            //
            //            // Present the action sheet
            //            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
        print("Did Tap at date: \(date)")
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        //        endEventEditing()
        print("DayView did begin dragging")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        selectedDate = date
        print("DayView = \(dayView) did move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        print("Did long press timeline at date \(date)")
        // Cancel editing current event and start creating a new one
        //        endEventEditing()
        //        let event = generateEventNearDate(date)
        print("Creating a new event")
        //        create(event: event, animated: true)
        //        createdEvent = event
    }
    
    //    private func generateEventNearDate(_ date: Date) -> EventDescriptor {
    //        let duration = (60...220).randomElement()!
    //        let startDate = Calendar.current.date(byAdding: .minute, value: -Int(Double(duration) / 2), to: date)!
    //        let event = Event()
    //
    //        event.dateInterval = DateInterval(start: startDate, duration: TimeInterval(duration * 60))
    //
    //        var info = data.randomElement()!
    //
    //        info.append(dateIntervalFormatter.string(from: event.dateInterval)!)
    //        event.text = info.reduce("", {$0 + $1 + "\n"})
    //        event.color = colors.randomElement()!
    //        event.editedEvent = event
    //
    //        return event
    //    }
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        print("did finish editing \(event)")
        print("new startDate: \(event.dateInterval.start) new endDate: \(event.dateInterval.end)")
        
        if let _ = event.editedEvent {
            event.commitEditing()
        }
        
        if let createdEvent = createdEvent {
            createdEvent.editedEvent = nil
            generatedEvents.append(createdEvent)
            self.createdEvent = nil
            endEventEditing()
        }
        
        reloadData()
    }
    
}


struct CalendarKitWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = CustomCalendarExampleController
    
    @Binding var selectedDate: Date
    @Binding var events: [EventM]
    @Binding var isShowingDetailSheet: Bool
    @Binding var selectedEvent: EventM?
    
    var onCancelEvent: ((EventM) -> Void)?
    //    var onJoinEvent: ((EventM) -> Void)?
    
    init(selectedDate: Binding<Date>, events: Binding<[EventM]>, isShowingDetailSheet: Binding<Bool>, selectedEvent: Binding<EventM?>, onCancelEvent: ((EventM) -> Void)?) {
        self._selectedDate = selectedDate
        self._events = events
        self._isShowingDetailSheet = isShowingDetailSheet
        self._selectedEvent = selectedEvent
        self.onCancelEvent = onCancelEvent
        //        self.onJoinEvent = onJoinEvent
    }
    
    func makeUIViewController(context: Context) -> CustomCalendarExampleController {
        let controller = CustomCalendarExampleController()
        controller.selectedDate = selectedDate
        controller.events = events
        //        controller.calendar.timeZone = TimeZone(identifier: "GMT")!
        //        controller.calendar.locale = Locale(identifier: "ar")
        controller.calendar.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage)
        
        // Configure RTL support at the controller level
              if LocalizeHelper.shared.currentLanguage == "ar" {
                  controller.view.semanticContentAttribute = .forceRightToLeft
              }
        controller.onCancelEvent = onCancelEvent
        //        controller.onJoinEvent = onJoinEvent
        controller.onEventSelected = { eventM in
            selectedEvent = eventM
            isShowingDetailSheet = true
            print(" ---- eventM -----\n",eventM)
            
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CustomCalendarExampleController, context: Context) {
        // Update your view controller if needed
        //        uiViewController.calendar.timeZone = TimeZone(identifier: "GMT")!
        //        uiViewController.calendar.locale = Locale(identifier: "en")
        
        uiViewController.selectedDate = selectedDate
        uiViewController.events = events
        
        uiViewController.calendar.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage)
        // Ensure RTL configuration is maintained on updates
               if LocalizeHelper.shared.currentLanguage == "ar" {
                   uiViewController.view.semanticContentAttribute = .forceRightToLeft
               }
        
    }
}

struct ContentView3: View {
    //    @Binding var selectedDate : Date
    //    @Binding  var scope: FSCalendarScope
    //    @Binding var events: [EventM]
    //    var onCancelEvent: ((EventM) -> Void)?
    
    @Binding var selectedDate: Date
    @Binding var scope: FSCalendarScope
    @Binding var events: [EventM]
    @State private var isShowingDetailSheet = false
    @State private var selectedEvent: EventM?
    
    var onCancelEvent: ((EventM) -> Void)?
    var onJoinEvent: ((EventM) -> Void)?
    
    @State var isError : Bool = false
    @State var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    var body: some View {
        VStack {
            CalendarKitWrapper(
                selectedDate: $selectedDate,
                events: $events,
                isShowingDetailSheet: $isShowingDetailSheet,
                selectedEvent: $selectedEvent,
                onCancelEvent: onCancelEvent
            )
        }
        .overlay{
            if isShowingDetailSheet{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation{
                            isShowingDetailSheet = false
                        }
                    }
                    .blur(radius: 4) // Adjust the blur radius as needed
                DynamicHeightSheet(isPresented: $isShowingDetailSheet){
                    VStack{
                        if let selectedEvent = selectedEvent {
                            EventDetailsView(event: selectedEvent, onCancelEvent: { event in
                                // Handle the event cancellation here
                                if Helper.shared.getSelectedUserType() == .Teacher && !(event.teacherSubjectAcademicSemesterYearId == nil){
                                    onCancelEvent?(selectedEvent)
                                }else{
                                    if let index = events.firstIndex(where: { $0.id == event.id }) {
                                        events[index].isCancel = true
                                        onCancelEvent?(selectedEvent)
                                        //                        isError = true
                                    }
                                }
                                isShowingDetailSheet = false
                                
                            },onJoinEvent: { event in
                                print("Event joining closure executed",event)
                                //                                if let index = events.firstIndex(where: { $0.id == event.id }) {
                                onJoinEvent?(selectedEvent)
                                //                                }
                            },isError: $isError,error: $error)
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(height:330)
                    //                    .keyboardAdaptive()
                }
                
            }
        }
        .showAlert(hasAlert: $isError, alertType: error)
    }
}

#Preview{
    ContentView3(selectedDate: .constant(Date()), scope: .constant(.week), events: .constant([]))
}


//MARK: -- event Details --
struct EventDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    let event: EventM
    let onCancelEvent: ((EventM) -> Void)? // Closure to handle event cancellation
    let onJoinEvent: ((EventM) -> Void)? // Closure to handle event join
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //        formatter.timeZone = TimeZone(identifier: "GMT")
        //        formatter.locale = Locale(identifier: "en")
        
        //        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure GMT or appropriate time zone
        //        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    func isEventInPast() -> Bool {
        guard let eventDateStr = event.date, let timeToStr = event.timeTo else {
            return false
        }
        
        let toDateTimeStr = "\(eventDateStr.prefix(10))T\(timeToStr)"
        print("toDateTimestr: \(toDateTimeStr)")
        
        guard let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
            print("Failed to parse toDateTime: \(toDateTimeStr)")
            return false
        }
        print("toDateTime: \(toDateTime)")
        
        // Convert current time to local time zone
        let currentTime = Date()
        
        return toDateTime < currentTime
    }
    
    func isCurrentTimeWithinEventTime() -> Bool {
        guard let eventDateStr = event.date, let timeFromStr = event.timeFrom, let timeToStr = event.timeTo else {
            print("One of the required date/time components is nil.")
            return false
        }
        
        let fromDateTimeStr = "\(eventDateStr.prefix(10))T\(timeFromStr)"
        let toDateTimeStr = "\(eventDateStr.prefix(10))T\(timeToStr)"
        
        //        print("From Date Time String: \(fromDateTimeStr)")
        //        print("To Date Time String: \(toDateTimeStr)")
        //
        guard let fromDateTime = dateFormatter.date(from: fromDateTimeStr),
              let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
            print("Failed to parse fromDateTime or toDateTime.")
            return false
        }
        
        // Convert current time to local time zone
        let currentTime = Date()
        //         let datestr = dateFormatter.string(from: Date())
        //        else{return false}
        //        guard let currentTime = dateFormatter.date(from: datestr)else{return false}
        
        //        print("Current Time: \(currentTime)")
        //        print("Event From Time: \(fromDateTime)")
        //        print("Event To Time: \(toDateTime)")
        
        return currentTime >= fromDateTime && currentTime <= toDateTime
    }
    
    // Function to check if the event is not started yet
    func isEventNotStartedYet() -> Bool {
        guard let eventDateStr = event.date, let timeFromStr = event.timeFrom else {
            return false
        }
        
        // Create full date string with event date and timeFrom
        let fromDateTimeStr = "\(eventDateStr.prefix(10))T\(timeFromStr)"
        
        // Parse the date string into Date object
        guard let fromDateTime = dateFormatter.date(from: fromDateTimeStr) else {
            return false
        }
        
        // Convert current time to local time zone
        let currentTime = Date()
        
        return currentTime < fromDateTime
    }
    
    @Binding var isError : Bool
    @Binding var error: AlertType
    
    var body: some View {
        //        NavigationView {
        VStack(spacing: 20) {
            Group {
                Text(event.groupName ?? "No Group Name")
                    .font(.title)
                    .padding(.top)
                    .frame(maxWidth: .infinity,alignment: .center)
                
                Group{
                    Text("Date: ".localized()) + Text("\(event.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd") ?? "No Date")")
                    //                            .font(.body)
                    
                    Text("From: ".localized()) + Text("\(event.timeFrom?.ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "HH:mm a") ?? "No Start Time")")
                    
                    //                            .font(.body)
                    
                    Text("To: ".localized()) + Text("\(event.timeTo?.ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "HH:mm a") ?? "No End Time")")
                    //                            .font(.body)
                    
                }
                .font(.body)
                
                
                // Display event status
                Text(event.isCancel == true ? "This event is canceled".localized() : isEventInPast() ? "This event is in the past".localized() : "This event is active".localized())
                    .foregroundColor(event.isCancel == true || isEventInPast() ? .red : .green)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //                Spacer()
            
            // Join Meeting button
            if let meetingLink = event.teamMeetingLink , isCurrentTimeWithinEventTime() {
                
                Spacer()
                Button(action: {
                    
                    print("join btn for event",event)
                    
                    joinMeeting(event: event, meetingLink: meetingLink)
                }){
                    HStack {
                        Image("microsoftteams")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .aspectRatio(contentMode: .fit)
                        Text("Join Meeting".localized())
                            .foregroundColor(.mainBlue)
                    }
                }
                .frame(height: 50)
                .frame(maxWidth:.infinity)
                .overlay(RoundedCorners(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8)
                    .stroke(ColorConstants.MainColor,lineWidth: 2))
            }
            // Cancel Event button
            else if event.isCancel != true && isEventNotStartedYet() {
                
                Spacer()
                CustomButton(Title:"Cancel Event",bgColor: .red,IsDisabled: .constant(false), action: {
                    error = .question( image: "img_group", message: "Are you sure you want to cancel this event ?", buttonTitle: "Confirm", secondButtonTitle: "Cancel", mainBtnAction: {
                        onCancelEvent?(event)
                    })
                    isError = true
                    //                        onCancelEvent?(event)
                })
                .frame(height: 50)
                //                    .padding(.top,30)
                
                
            }
        }
        .padding()
        //            .navigationBarItems(trailing: Button("Close".localized()) {
        //                presentationMode.wrappedValue.dismiss()
        //            })
        //            .showAlert(hasAlert: $isError, alertType: error)
        
        //        }
    }
    
    private func joinMeeting(event: EventM, meetingLink: String) {
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            // Handle expiration here if needed
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        })
        
        print("Joining event...")
        onJoinEvent?(event)
        print("onJoinEvent closure executed")
        
        if let teamsURL = URL(string: "msteams://") {
            // Try to open Teams app first
            if UIApplication.shared.canOpenURL(teamsURL) {
                UIApplication.shared.open(teamsURL, options: [:]) { success in
                    if success {
                        print("Teams app opened successfully.")
                    } else {
                        // If Teams app failed to open, fall back to the provided meeting link
                        self.openMeetingLink(meetingLink)
                    }
                    UIApplication.shared.endBackgroundTask(backgroundTask)
                    backgroundTask = .invalid
                }
            } else {
                // If Teams app is not available, open the meeting link directly
                self.openMeetingLink(meetingLink)
            }
        } else {
            // If URL creation fails, open the meeting link directly
            self.openMeetingLink(meetingLink)
        }
    }
    
    private func openMeetingLink(_ meetingLink: String) {
        if let url = URL(string: meetingLink) {
            UIApplication.shared.open(url) { success in
                print("URL opened: \(success)")
                if success {
                    // Perform any additional actions if needed
                }
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = .invalid
            }
        } else {
            print("Invalid URL: \(meetingLink)")
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
}

#Preview{
    EventDetailsView(event: EventM(id: 1, groupName: "Math Class", date: "2024-05-29", timeFrom: "10:00", timeTo: "11:00", isCancel: false, cancelDate: nil, teamMeetingLink: "https://example.com/meeting"), onCancelEvent: { _ in }, onJoinEvent: { _ in },isError: .constant(false),error: .constant(.error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")))
}
