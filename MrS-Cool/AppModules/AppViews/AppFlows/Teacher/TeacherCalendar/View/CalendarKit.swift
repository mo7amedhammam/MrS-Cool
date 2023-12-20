//
//  CalendarKit.swift
//  MrS-Cool
//
//  Created by wecancity on 20/12/2023.
//

import UIKit
import CalendarKit
import SwiftUI

final class CustomCalendarExampleController: DayViewController {
    var selectedDate: Date? {
           didSet {
//               selectedDate = selectedDate?.addingTimeInterval(24 * 60 * 60)

               reloadData()
           }
       }
  var data = [["Breakfast at Tiffany's",
               "New York, 5th avenue"],
              
              ["Workout",
               "Tufteparken"],
              
              ["Meeting with Alex",
               "Home",
               "Oslo, Tjuvholmen"],
              
              ["Beach Volleyball",
               "Ipanema Beach",
               "Rio De Janeiro"],
              
              ["WWDC",
               "Moscone West Convention Center",
               "747 Howard St"],
              
              ["Google I/O",
               "Shoreline Amphitheatre",
               "One Amphitheatre Parkway"],
              
              ["✈️️ to Svalbard ❄️️❄️️❄️️❤️️",
               "Oslo Gardermoen"],
              
              ["💻📲 Developing CalendarKit",
               "🌍 Worldwide"],
              
              ["Software Development Lecture",
               "Mikpoli MB310",
               "Craig Federighi"],
              
  ]
  
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
  
  override func loadView() {
//    calendar.timeZone = TimeZone(identifier: "Africa/Cairo")!
      calendar.timeZone = TimeZone(identifier: "UTC")!
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
  
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        // Your logic to fetch events for the given date
        // This is just a placeholder, replace it with your actual data fetching logic


        // Check if the date matches the initialDate passed from SwiftUI
        if let initialDate = selectedDate, Calendar.current.isDate(date, inSameDayAs: initialDate) {
            // This is the date you want to show data for
            // Fetch and return events for this date
            let event = Event()
            event.dateInterval = DateInterval(start: initialDate, end: initialDate.addingTimeInterval(3600)) // 1 hour event as an example
            event.text = "Your event details for \(initialDate)"
            event.color = .green // Customize the color as needed
            return [event]
        }

        // If the date does not match the initialDate, return an empty array
        return []
    }
  
  private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
    var workingDate = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...15), to: date)!
    var events = [Event]()
    for i in 0...4 {
      let event = Event()
      
      let duration = Int.random(in: 60 ... 160)
      event.dateInterval = DateInterval(start: workingDate, duration: TimeInterval(duration * 60))
      
      var info = data.randomElement() ?? []
      
      let timezone = dayView.calendar.timeZone
      print(timezone)
      
      info.append(dateIntervalFormatter.string(from: event.dateInterval.start, to: event.dateInterval.end))
      event.text = info.reduce("", {$0 + $1 + "\n"})
      event.color = colors.randomElement() ?? .red
      event.isAllDay = Bool.random()
      event.lineBreakMode = .byTruncatingTail
      
      events.append(event)
      
      let nextOffset = Int.random(in: 40 ... 250)
      workingDate = Calendar.current.date(byAdding: .minute, value: nextOffset, to: workingDate)!
      event.userInfo = String(i)
    }
    
    print("Events for \(date)")
    return events
  }
  
  // MARK: DayViewDelegate
  private var createdEvent: EventDescriptor?
  
  override func dayViewDidSelectEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
  }
  
  override func dayViewDidLongPressEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    endEventEditing()
    print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    beginEditing(event: descriptor, animated: true)
    print(Date())
  }
  
  override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
    endEventEditing()
    print("Did Tap at date: \(date)")
  }
  
  override func dayViewDidBeginDragging(dayView: DayView) {
    endEventEditing()
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
    endEventEditing()
    let event = generateEventNearDate(date)
    print("Creating a new event")
    create(event: event, animated: true)
    createdEvent = event
  }
  
  private func generateEventNearDate(_ date: Date) -> EventDescriptor {
    let duration = (60...220).randomElement()!
    let startDate = Calendar.current.date(byAdding: .minute, value: -Int(Double(duration) / 2), to: date)!
    let event = Event()
    
    event.dateInterval = DateInterval(start: startDate, duration: TimeInterval(duration * 60))
    
    var info = data.randomElement()!
    
    info.append(dateIntervalFormatter.string(from: event.dateInterval)!)
    event.text = info.reduce("", {$0 + $1 + "\n"})
    event.color = colors.randomElement()!
    event.editedEvent = event
    
    return event
  }
  
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

    let selectedDate: Binding<Date>

    init(selectedDate: Binding<Date>) {
        self.selectedDate = selectedDate
    }

    func makeUIViewController(context: Context) -> CustomCalendarExampleController {
        let controller = CustomCalendarExampleController()
        controller.selectedDate = selectedDate.wrappedValue
        return controller
    }

    func updateUIViewController(_ uiViewController: CustomCalendarExampleController, context: Context) {
        // Update your view controller if needed
 
    }
}

struct ContentView3: View {
    @Binding var selectedDate : Date

    var body: some View {
        NavigationView {
            VStack {
                // Your other SwiftUI content here
                CalendarKitWrapper(selectedDate:$selectedDate )
                    .navigationBarTitle("Custom Calendar")
            }
        }
    }
}

#Preview{
    ContentView3(selectedDate: .constant(Date()))
}
