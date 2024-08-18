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

final class CustomCalendarExampleController: DayViewController {
    var selectedDate: Date?
    var events: [EventM] = [] 
//    {
//        didSet {
//            // Update events and reload data
//            reloadData()
//        }
//    }
    var onCancelEvent: ((EventM) -> Void)?
    var onJoinEvent: ((EventM) -> Void)?
    var onEventSelected: ((EventM) -> Void)?
    
    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()
    
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]
    
    private lazy var dateIntervalFormatter: DateIntervalFormatter = {
        let dateIntervalFormatter = DateIntervalFormatter()
        dateIntervalFormatter.dateStyle = .none
        dateIntervalFormatter.timeStyle = .short
        
        return dateIntervalFormatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter.cachedFormatter

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.locale = Locale(identifier: "en")
        return formatter
    }()
    fileprivate lazy var timeFormatter2: DateFormatter = {
        let formatter = DateFormatter.cachedFormatter

        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.locale = Locale(identifier: "en_US_POSIX") // Use en_US_POSIX to ensure the correct interpretation of the time string

        return formatter
    }()
    
    override func loadView() {
        //    calendar.timeZone = TimeZone(identifier: "Africa/Cairo")!
//              calendar.timeZone = TimeZone(identifier: "UTC")!
                dayView.calendar.timeZone = TimeZone(identifier: "GMT")!

        dayView = DayView(calendar: calendar)
        dayView.move(to: selectedDate ?? Date())
        
//        dayView.calendar.timeZone = TimeZone(identifier: "GMT")!
//        dayView.calendar.locale = Locale(identifier: "en")

        view = dayView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CalendarKit Demo"
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        reloadData()
    }
    
    // MARK: EventDataSource
    //    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
    //        // Your logic to fetch events for the given date
    //        // This is just a placeholder, replace it with your actual data fetching logic
    //
    //
    //        // Check if the date matches the initialDate passed from SwiftUI
    //        if let initialDate = selectedDate, Calendar.current.isDate(date, inSameDayAs: initialDate) {
    //            // This is the date you want to show data for
    //            // Fetch and return events for this date
    //            let event = Event()
    //            event.dateInterval = DateInterval(start: initialDate, end: initialDate.addingTimeInterval(3600)) // 1 hour event as an example
    //            event.text = "Your event details for \(initialDate)"
    //            event.color = .green // Customize the color as needed
    //            return [event]
    //        }
    //
    //        // If the date does not match the initialDate, return an empty array
    //        return []
    //    }
    
//    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
//        // Filter events for the selected date
//        let eventsForSelectedDate = events.filter { eventM in
//            if let dateString = eventM.date,
//               let eventDate = dateFormatter2.date(from: dateString) {
//                
//                return Calendar.current.isDate(eventDate, inSameDayAs: date)
//            }
//            return false
//        }
//        
//        // Convert EventM objects to EventDescriptor
//        let eventDescriptors = eventsForSelectedDate.compactMap { eventM in
//            let event = Event()
//            
//            // Configure event properties based on your EventM model
//            if let dateString = eventM.date,
//               let eventDate = dateFormatter2.date(from: dateString),
//               let timeFromString = eventM.timeFrom,
//               let timeToString = eventM.timeTo,
//               let timeFrom = timeFormatter2.date(from: timeFromString),
//               let timeTo = timeFormatter2.date(from: timeToString) {
//                print("timeFromString",timeFromString)
//                print("timeFrom",timeFrom)
//
//                // Safely unwrap startTimeComponents and endTimeComponents
//                let calendar = Calendar.current
//                var startTimeComponents = calendar.dateComponents([.hour, .minute], from: timeFrom)
//                var endTimeComponents = calendar.dateComponents([.hour, .minute], from: timeTo)
//                
////                startTimeComponents.timeZone = TimeZone(identifier: "UTC")
////                endTimeComponents.timeZone = TimeZone(identifier: "UTC")
//
//                
//                if let startHour = startTimeComponents.hour,
//                   let startMinute = startTimeComponents.minute,
//                   let endHour = endTimeComponents.hour,
//                   let endMinute = endTimeComponents.minute {
//                    
//                    let startDate = eventDate.addingTimeInterval(TimeInterval(startHour * 3600 + startMinute * 60))
//                    var endDate = eventDate.addingTimeInterval(TimeInterval(endHour * 3600 + endMinute * 60))
//                    
//                    // Handle case where end time is before start time (e.g., crosses midnight)
//                    if endDate <= startDate {
//                        endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate) ?? endDate
//                    }
//                    
//                    event.dateInterval = DateInterval(start: startDate, end: endDate)
//                    
//                    event.text = "\(eventM.groupName ?? "")"
//                    
//                    // Set color based on conditions
//                    let now = Date()
//                    if eventDate < Calendar.current.startOfDay(for: now) {
//                        // Event is before today
//                        event.color = .red
//                    } else if eventM.isCancel ?? false {
//                        // Event is canceled
//                        event.color = .red
//                    } else if endDate < now {
//                        // Event end time is in the past
//                        event.color = .red
//                    } else {
//                        // Default color for other events
//                        event.color = .green
//                    }
//                    
//                    // Store the EventM object in userInfo
//                    event.userInfo = eventM
//                    
//                    return event // Return the configured event
//                }
//            }
//            return nil // Return nil if any of the required components are missing
//        }
//        
//        return eventDescriptors
//    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        // Filter events for the selected date
        let eventsForSelectedDate = events.filter { eventM in
            if let dateString = eventM.date,
               let eventDate = dateFormatter2.date(from: dateString) {
                return Calendar.current.isDate(eventDate, inSameDayAs: date)
            }
            return false
        }
        
        // Convert EventM objects to EventDescriptor
        let eventDescriptors = eventsForSelectedDate.compactMap { eventM in
            let event = Event()
            
            // Configure event properties based on your EventM model
            if let dateString = eventM.date,
               let eventDate = dateFormatter2.date(from: dateString),
               let timeFromString = eventM.timeFrom,
               let timeToString = eventM.timeTo {
                
                // Extract hours and minutes from the time strings
                let timeFromComponents = timeFromString.split(separator: ":").map { Int($0) ?? 0 }
                let timeToComponents = timeToString.split(separator: ":").map { Int($0) ?? 0 }
                
                if timeFromComponents.count == 3, timeToComponents.count == 3 {
                    let calendar = Calendar.current
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

    
    
    
    
    //    private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
    //        var workingDate = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...15), to: date)!
    //        var events = [Event]()
    //        for i in 0...4 {
    //            let event = Event()
    //
    //            let duration = Int.random(in: 60 ... 160)
    //            event.dateInterval = DateInterval(start: workingDate, duration: TimeInterval(duration * 60))
    //
    //            var info = data.randomElement() ?? []
    //
    //            let timezone = dayView.calendar.timeZone
    //            print(timezone)
    //
    //            info.append(dateIntervalFormatter.string(from: event.dateInterval.start, to: event.dateInterval.end))
    //            event.text = info.reduce("", {$0 + $1 + "\n"})
    //            event.color = colors.randomElement() ?? .red
    //            event.isAllDay = Bool.random()
    //            event.lineBreakMode = .byTruncatingTail
    //
    //            events.append(event)
    //
    //            let nextOffset = Int.random(in: 40 ... 250)
    //            workingDate = Calendar.current.date(byAdding: .minute, value: nextOffset, to: workingDate)!
    //            event.userInfo = String(i)
    //        }
    //
    //        print("Events for \(date)")
    //        return events
    //    }
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
            print(" ---- eventM -----\n",eventM)
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
            if let eventDate = dateFormatter2.date(from: dateString) {
                return Calendar.current.isDate(eventDate, inSameDayAs: descriptor.dateInterval.start)
            }
            return false
        }) {
            // Check if the event is in the past or is canceled
            let currentDate = Date()
            if let eventDate = dateFormatter2.date(from: eventM.date ?? "") {
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
//        dayView.calendar.timeZone = TimeZone(identifier: "GMT")!
        endEventEditing()

        print("Did Tap at date: \(date)")
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        //        endEventEditing()
//        dayView.calendar.timeZone = TimeZone(identifier: "GMT")!

        print("DayView did begin dragging")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
//        dayView.calendar.timeZone = TimeZone(identifier: "GMT")!
//        dayView.calendar.locale = Locale(identifier: "en")
        selectedDate = date
        print("DayView = \(dayView) did move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
//        dayView.calendar.timeZone = TimeZone(identifier: "GMT")!
        
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
//        dayView.calendar.timeZone = TimeZone(identifier: "GMT")!
        dayView.calendar.timeZone = TimeZone(identifier: "GMT")!
        dayView.calendar.locale = Locale(identifier: "en")

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
        uiViewController.selectedDate = selectedDate
        uiViewController.events = events
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
            //            CalendarKitWrapper(selectedDate:$selectedDate, events: events,onCancelEvent:onCancelEvent )
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
                                if let index = events.firstIndex(where: { $0.id == event.id }) {
                                    events[index].isCancel = true
                                    onCancelEvent?(selectedEvent)
                                    //                        isError = true
                                }
                                isShowingDetailSheet = false
                            },onJoinEvent: { event in
                                print("Event joining closure executed")
                                if let index = events.firstIndex(where: { $0.id == event.id }) {
                                    onJoinEvent?(selectedEvent)
                                }
                            })
                        }
                    }
                    .padding()
                    .frame(height:360)
//                    .keyboardAdaptive()
                }
            }
        }
//                .sheet(isPresented: $isShowingDetailSheet) {
//                    if let selectedEvent = selectedEvent {
//                        EventDetailsView(event: selectedEvent, onCancelEvent: { event in
//                            // Handle the event cancellation here
//                            if let index = events.firstIndex(where: { $0.id == event.id }) {
//                                events[index].isCancel = true
//        
//        //                        error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
//        ////                            teacherdocumentsvm.DeleteTeacherDocument(id: document.id)
//        //                            onCancelEvent?(selectedEvent)
//        //                            isShowingDetailSheet = false
//        //
//        //                        })
//                                onCancelEvent?(selectedEvent)
//        //                        isError = true
//                            }
//                            isShowingDetailSheet = false
//                        },onJoinEvent: { event in
//                            print("Event joining closure executed")
//                            if let index = events.firstIndex(where: { $0.id == event.id }) {
//                                onJoinEvent?(selectedEvent)
//                            }
//                        })
//                    }
//                }
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
    
    
    // Date formatter for parsing the event date and time
//    fileprivate let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter.cachedFormatter
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
////        formatter.dateFormat = "HH:mm:ss"
//        formatter.timeZone = TimeZone(identifier: "GMT")
//        formatter.locale = Locale(identifier: "en")
//        return formatter
//    }()
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.locale = Locale(identifier: "en")

//        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure GMT or appropriate time zone
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    
    // Function to check if the event is in the past
//    func isEventInPast() -> Bool {
//        guard let eventDateStr = event.date, let timeToStr = event.timeTo else {
//            return false
//        }
//        print("eventDateStr: \(eventDateStr)")
//        print("timeToStr: \(timeToStr)")
//
//        
//        // Create full date strings with event date and times
////        let fromDateTimeStr = "\(eventDateStr.prefix(10))T\(timeFromStr)"
//        let toDateTimeStr = "\((eventDateStr.prefix(10)))T\(timeToStr)"
//        print("toDateTimestr: \(toDateTimeStr)")
//
//        // Parse the date strings into Date objects
//        guard let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
//            return false
//        }
//        print("toDateTime: \(toDateTime)")
//
//        let currentTime = Date()
//        return toDateTime < currentTime
//    }
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
        
        print("From Date Time String: \(fromDateTimeStr)")
        print("To Date Time String: \(toDateTimeStr)")
        
        guard let fromDateTime = dateFormatter.date(from: fromDateTimeStr),
              let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
            print("Failed to parse fromDateTime or toDateTime.")
            return false
        }
        
        let currentTime = Date()
        print("Current Time: \(currentTime)")
        print("Event From Time: \(fromDateTime)")
        print("Event To Time: \(toDateTime)")
        
        return currentTime >= fromDateTime && currentTime <= toDateTime
    }
    
    // Function to check if the current time is between timeFrom and timeTo
//    func isCurrentTimeWithinEventTime() -> Bool {
//        guard let eventDateStr = event.date, let timeFromStr = event.timeFrom, let timeToStr = event.timeTo else {
//            print("One of the required date/time components is nil.")
//
//            return false
//        }
//        
//        // Create full date strings with event date and times
//        let fromDateTimeStr = "\(eventDateStr.prefix(10))T\(timeFromStr)"
//        let toDateTimeStr = "\(eventDateStr.prefix(10))T\(timeToStr)"
//        
//        
//        // Debugging output
//        print("From Date Time String: \(fromDateTimeStr)")
//        print("To Date Time String: \(toDateTimeStr)")
//        
//        // Parse the date strings into Date objects
//        guard let fromDateTime = dateFormatter.date(from: fromDateTimeStr),
//              let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
//            print("Failed to parse fromDateTime or toDateTime. Check format.")
//            return false
//        }
//        
//        let currentTime = Date()
//                print("Current Time: \(currentTime)")
//                print("Event From Time: \(fromDateTime)")
//                print("Event To Time: \(toDateTime)")
//        
//        return currentTime >= fromDateTime && currentTime <= toDateTime
//    }
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
        
        let currentTime = Date()
        return currentTime < fromDateTime
    }
    
    @State var isError : Bool = false
    @State var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    var body: some View {
        NavigationView {
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
                    Text(event.isCancel == true ? "This event is canceled.".localized() : isEventInPast() ? "This event is in the past.".localized() : "This event is active.".localized())
                        .foregroundColor(event.isCancel == true || isEventInPast() ? .red : .green)
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // Join Meeting button
                if let meetingLink = event.teamMeetingLink, !meetingLink.isEmpty, isCurrentTimeWithinEventTime() {
                    
                    //                    Button(action: {
                    ////                        print("Joining event...")
                    ////                        onJoinEvent?(event)
                    ////                        print("onJoinEvent closure executed")
                    ////                        if let url = URL(string: meetingLink) {
                    ////                            UIApplication.shared.open(url)
                    ////                        }
                    //
                    //                        joinMeeting(event: event, meetingLink: meetingLink)
                    //                    }){
                    //                        HStack {
                    //                            Image("microsoftteams")
                    //                                .resizable()
                    //                                .frame(width: 30,height: 30)
                    //                                .aspectRatio(contentMode: .fit)
                    //                            Text("Join Meeting".localized())
                    //                                .foregroundColor(.whiteA700)
                    //                        }
                    //                    }
                    //                    .frame(height: 50)
                    //                    .frame(maxWidth:.infinity)
                    //                    .background{ColorConstants.MainColor}
                    //                    .cornerRadius(8)
                    Spacer()
                    Button(action: {
                        ////                        print("Joining event...")
                        ////                        onJoinEvent?(event)
                        ////                        print("onJoinEvent closure executed")
                        ////                        if let url = URL(string: meetingLink) {
                        ////                            UIApplication.shared.open(url)
                        ////                        }
                        
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
                        .stroke(ColorConstants.MainColor,lineWidth: 2))                }
                
                
                // Cancel Event button
                if event.isCancel != true, isEventNotStartedYet() {
                    //                    Button(action: {
                    //                        error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                    ////                            teacherdocumentsvm.DeleteTeacherDocument(id: document.id)
                    //                            onCancelEvent?(event)
                    ////                            isShowingDetailSheet = false
                    //                        })
                    //                        isError = true
                    ////                        onCancelEvent?(event)
                    //                    }) {
                    //                        Text("Cancel Event".localized())
                    //                            .foregroundColor(.red)
                    //                    }
                    
                    Spacer()
                    CustomButton(Title:"Cancel Event",bgColor: .red,IsDisabled: .constant(false), action: {
                        error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                            //                            teacherdocumentsvm.DeleteTeacherDocument(id: document.id)
                            onCancelEvent?(event)
                            //                            isShowingDetailSheet = false
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
            .showAlert(hasAlert: $isError, alertType: error)
            
        }
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
        
        if let url = URL(string: meetingLink) {
            UIApplication.shared.open(url) { success in
                print("URL opened: \(success)")
                if success {
                    // Perform any additional actions if needed
                }
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = .invalid
            }
        }
    }
}




#Preview{
    EventDetailsView(event: EventM(id: 1, groupName: "Math Class", date: "2024-05-29", timeFrom: "10:00", timeTo: "11:00", isCancel: false, cancelDate: nil, teamMeetingLink: "https://example.com/meeting"), onCancelEvent: { _ in }, onJoinEvent: { _ in })
}
