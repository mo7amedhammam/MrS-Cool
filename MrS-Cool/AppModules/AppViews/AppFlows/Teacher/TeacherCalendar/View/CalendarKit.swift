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
    var events: [EventM] = [] {
        didSet {
            // Update events and reload data
            reloadData()
        }
    }
    var onCancelEvent: ((EventM) -> Void)?
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
        let formatter = DateFormatter()
        //        calendar.timeZone = TimeZone(identifier: "UTC")!
        //        formatter.timeZone = TimeZone(identifier: "Africa/Cairo")!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    fileprivate lazy var timeFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        //        calendar.timeZone = TimeZone(identifier: "UTC")!
        //        formatter.timeZone = TimeZone(identifier: "Africa/Cairo")!
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    override func loadView() {
        //    calendar.timeZone = TimeZone(identifier: "Africa/Cairo")!
        //      calendar.timeZone = TimeZone(identifier: "UTC")!
        dayView = DayView(calendar: calendar)
        dayView.move(to: selectedDate ?? Date())
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
        let eventDescriptors = eventsForSelectedDate.map { eventM in
            let event = Event()
            // Configure event properties based on your EventM model
            // For example:
            if let dateString = eventM.date,
               let eventDate = dateFormatter2.date(from: dateString),
               let timeFrom = timeFormatter2.date(from:eventM.timeFrom ?? ""),
               let timeTo = timeFormatter2.date(from:eventM.timeTo ?? "") {
                // Set the start and end times based on timeFrom and timeTo
                let startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: timeFrom)
                let endTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: timeTo)
                
                event.dateInterval = DateInterval(start: eventDate.addingTimeInterval(TimeInterval(startTimeComponents.hour! * 3600 + startTimeComponents.minute! * 60)),
                                                  end: eventDate.addingTimeInterval(TimeInterval(endTimeComponents.hour! * 3600 + endTimeComponents.minute! * 60)))
                event.text = "\(eventM.groupName ?? "")"
                //                event.color = .green // Customize the color as needed
                // Set color based on conditions
                if eventDate < Calendar.current.startOfDay(for: Date()) {
                    // Event is before today
                    event.color = .red
                } else if eventM.isCancel ?? false {
                    // Event is canceled
                    event.color = .red
                } else {
                    // Default color for other events
                    event.color = .green
                }
                
                // Store the EventM object in userInfo
                event.userInfo = eventM
                
            }
            return event
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
            
            let alertController = UIAlertController(title: "Event Options", message: nil, preferredStyle: .actionSheet)
            
            // Add a Cancel option
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // Add an option to cancel the event
            alertController.addAction(UIAlertAction(title: "Cancel Event", style: .destructive) { [weak self] _ in
                guard let self = self else {return}
                // Handle the cancellation of the event here
                //              self.cancelEvent(descriptor)
                self.onCancelEvent?(eventM)
                self.reloadData()
            })
            
            // Present the action sheet
            present(alertController, animated: true, completion: nil)
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


//struct CalendarKitWrapper: UIViewControllerRepresentable {
//    typealias UIViewControllerType = CustomCalendarExampleController
//
//    let selectedDate: Binding<Date>
//    var events: [EventM]
//    var onCancelEvent: ((EventM) -> Void)?
//
//    init(selectedDate: Binding<Date>,events: [EventM],onCancelEvent: ((EventM) -> Void)?) {
//        self.selectedDate = selectedDate
//        self.onCancelEvent = onCancelEvent
//        self.events = events
//    }
//
//    func makeUIViewController(context: Context) -> CustomCalendarExampleController {
//        let controller = CustomCalendarExampleController()
//        controller.selectedDate = selectedDate.wrappedValue
//        controller.events = events
//        controller.onCancelEvent = onCancelEvent
//
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: CustomCalendarExampleController, context: Context) {
//        // Update your view controller if needed
//
//    }
//}
import SwiftUI

struct CalendarKitWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = CustomCalendarExampleController
    
    @Binding var selectedDate: Date
    @Binding var events: [EventM]
    @Binding var isShowingDetailSheet: Bool
    @Binding var selectedEvent: EventM?
    
    var onCancelEvent: ((EventM) -> Void)?
    
    init(selectedDate: Binding<Date>, events: Binding<[EventM]>, isShowingDetailSheet: Binding<Bool>, selectedEvent: Binding<EventM?>, onCancelEvent: ((EventM) -> Void)?) {
        self._selectedDate = selectedDate
        self._events = events
        self._isShowingDetailSheet = isShowingDetailSheet
        self._selectedEvent = selectedEvent
        self.onCancelEvent = onCancelEvent
    }
    
    func makeUIViewController(context: Context) -> CustomCalendarExampleController {
        let controller = CustomCalendarExampleController()
        controller.selectedDate = selectedDate
        controller.events = events
        controller.onCancelEvent = onCancelEvent
        controller.onEventSelected = { eventM in
            selectedEvent = eventM
            isShowingDetailSheet = true
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
        .sheet(isPresented: $isShowingDetailSheet) {
            if let selectedEvent = selectedEvent {
                EventDetailsView(event: selectedEvent, onCancelEvent: { event in
                    // Handle the event cancellation here
                    if let index = events.firstIndex(where: { $0.id == event.id }) {
                        events[index].isCancel = true
                        onCancelEvent?(selectedEvent)
                    }
                    isShowingDetailSheet = false
                },onJoinEvent: { event in
                    onJoinEvent?(selectedEvent)
                })
            }
        }
    }
}

#Preview{
    ContentView3(selectedDate: .constant(Date()), scope: .constant(.week), events: .constant([]))
}


//MARK: -- event Details --
struct EventDetailsView: View {
    @Environment(\.presentationMode) var presentationMode

    let event: EventM
    let onCancelEvent: ((EventM) -> Void)? // Closure to handle event cancellation
    let onJoinEvent: ((EventM) -> Void)? // Closure to handle event cancellation

    // Function to check if the event is in the past
    func isEventInPast() -> Bool {
        guard let eventDateStr = event.date, let eventDate = dateFormatter.date(from: eventDateStr) else {
            return false
        }
        return eventDate < Date()
    }

    // Function to check if the current time is between timeFrom and timeTo
    func isCurrentTimeWithinEventTime() -> Bool {
        guard let timeFromStr = event.timeFrom, let timeToStr = event.timeTo else {
            return false
        }
        
        // Create full date strings with event date and times
        guard let eventDateStr = event.date else {
            return false
        }
        let fromDateTimeStr = "\(eventDateStr)T\(timeFromStr)"
        let toDateTimeStr = "\(eventDateStr)T\(timeToStr)"
        
        // Parse the date strings into Date objects
        guard let fromDateTime = dateFormatter.date(from: fromDateTimeStr),
              let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
            return false
        }
        
        let currentTime = Date()
        return currentTime >= fromDateTime && currentTime <= toDateTime
    }

    // Date formatter for parsing the event date and time
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Group {
                    Text(event.groupName ?? "No Group Name")
                        .font(.title)
                        .padding(.top)

                    Text("Date: \(event.date ?? "No Date")")
                        .font(.body)

                    Text("From: \(event.timeFrom ?? "No Start Time")")
                        .font(.body)

                    Text("To: \(event.timeTo ?? "No End Time")")
                        .font(.body)

                    // Display event status
                    Text(event.isCancel == true ? "This event is canceled.".localized() : isEventInPast() ? "This event is in the past.".localized() : "This event is active.".localized())
                        .foregroundColor(event.isCancel == true || isEventInPast() ? .red : .green)
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                // Join Meeting button
                if let meetingLink = event.teamMeetingLink, !meetingLink.isEmpty, event.isCancel != true, isCurrentTimeWithinEventTime() {
                    Button(action: {
                        if let url = URL(string: meetingLink) {
                            UIApplication.shared.open(url)
                            onJoinEvent?(event)
                        }
                    }) {
                        Text("Join Meeting".localized())
                            .foregroundColor(.blue)
                    }
                }

                // Cancel Event button
                if event.isCancel != true, !isEventInPast() {
                    Button(action: {
                        onCancelEvent?(event)
                    }) {
                        Text("Cancel Event".localized())
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .navigationBarItems(trailing: Button("Close".localized()) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}



#Preview{
    EventDetailsView(event: EventM(id: 1, groupName: "Math Class", date: "2024-05-29", timeFrom: "10:00", timeTo: "11:00", isCancel: false, cancelDate: nil, teamMeetingLink: "https://example.com/meeting"), onCancelEvent: { _ in }, onJoinEvent: { _ in })
}
