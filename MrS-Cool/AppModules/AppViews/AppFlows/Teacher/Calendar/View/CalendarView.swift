import SwiftUI
import FSCalendar
import EventKit

struct EventCalendarView: UIViewControllerRepresentable {
    let event1 = EKEvent(eventStore: EKEventStore())
    event1.title = "Meeting with Client"
    event1.startDate = Date().addingTimeInterval(86400) // Tomorrow
    event1.endDate = event1.startDate.addingTimeInterval(3600) // 1 hour
    event1.calendar = EKEventStore().defaultCalendarForNewEvents

    let event2 = EKEvent(eventStore: EKEventStore())
    event2.title = "Team Lunch"
    event2.startDate = Date().addingTimeInterval(2 * 86400) // Day after tomorrow
    event2.endDate = event2.startDate.addingTimeInterval(3600) // 1 hour
    event2.calendar = EKEventStore().defaultCalendarForNewEvents

    let event3 = EKEvent(eventStore: EKEventStore())
    event3.title = "Presentation"
    event3.startDate = Date().addingTimeInterval(3 * 86400) // Three days from now
    event3.endDate = event3.startDate.addingTimeInterval(7200) // 2 hours
    event3.calendar = EKEventStore().defaultCalendarForNewEvents

    let eventsArray: [EKEvent] = [event1, event2, EKEvent.init(eventStore: EKEventStore().defaultCalendarForNewEvents?.title = "task")]
    
    @State private var events: [EKEvent] = []

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: EventCalendarView

        init(parent: EventCalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            // Implement logic to check if there are events on the specified date
            return parent.events.filter { $0.startDate == date }.count
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        viewController.view.addSubview(calendar)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Fetch events and update the calendar
        fetchEvents()
        // You may also want to refresh the calendar or update its appearance here
    }

    func fetchEvents() {
        // Example: Add some events for testing
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)

        for calendar in calendars {
            let startDate = Date()
            let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDate)!

            let event = EKEvent(eventStore: eventStore)
            event.calendar = calendar
            event.title = "Sample Event"
            event.startDate = startDate
            event.endDate = endDate

            do {
                try eventStore.save(event, span: .thisEvent)
            } catch {
                print("Error saving event: \(error.localizedDescription)")
            }
        }

        // Fetch events from the EventKit framework
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date().addingTimeInterval(60*60*24*365), calendars: nil)
        events = eventStore.events(matching: predicate)
    }
}


struct CalenderView: View {
    var body: some View {
        NavigationView {
            EventCalendarView()
                .navigationBarTitle("Event Calendar")
        }
    }
}
#Preview{
    CalenderView()
}
