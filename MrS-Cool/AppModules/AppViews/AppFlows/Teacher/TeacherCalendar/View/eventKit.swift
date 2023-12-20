//
//  eventKit.swift
//  MrS-Cool
//
//  Created by wecancity on 20/12/2023.
//

//import SwiftUI
//import EventKit
//import EventKitUI
//
//struct CalView2: View {
//    @State private var isPresentingEventView = false
//
//    var body: some View {
//        VStack {
//            Button("Show Calendar") {
//                isPresentingEventView.toggle()
//            }
//            .eventSheet(isPresented: $isPresentingEventView) {
//                EventKitView(isPresented: $isPresentingEventView)
//            }
//        }
//        .padding()
//    }
//}
//
//struct EventKitView: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//
//    func makeUIViewController(context: Context) -> EKEventEditViewController {
//        let eventVC = EKEventEditViewController()
//        eventVC.eventStore = EKEventStore()
//        eventVC.editViewDelegate = context.coordinator
//        return eventVC
//    }
//
//    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, EKEventEditViewDelegate {
//        var parent: EventKitView
//
//        init(_ parent: EventKitView) {
//            self.parent = parent
//        }
//
//        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
//            parent.isPresented = false
//        }
//    }
//}
//
//extension View {
//    func eventSheet<Sheet>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Sheet) -> some View where Sheet: View {
//        modifier(EventSheetModifier(isPresented: isPresented, sheetContent: content))
//    }
//}
//
//struct EventSheetModifier<Sheet>: ViewModifier where Sheet: View {
//    @Binding var isPresented: Bool
//    @ViewBuilder var sheetContent: () -> Sheet
//
//    func body(content: Content) -> some View {
//        content
//            .background(
//                EmptyView()
//                    .sheet(isPresented: $isPresented, content: sheetContent)
//            )
//    }
//}
//
//struct CalView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalView2()
//    }
//}



//
//  EKWrapper.swift
//  Calendar
//
//  Created by Richard Topchii on 22.05.2021.
//
//import CalendarKit
//
//struct CalendarKitView: UIViewControllerRepresentable {
//    class Coordinator: NSObject, EventDataSource {
//        var parent: CalendarKitView
//
//        init(parent: CalendarKitView) {
//            self.parent = parent
//        }
//
//        // Implement required EventDataSource methods
//        func eventsForDate(_ date: Date) -> [EventDescriptor] {
//            // Return events for the given date
//            return []
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = DayViewController()
//        viewController.dataSource = context.coordinator
//        // Customize other properties if needed
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        // Update if needed
//    }
//}

import SwiftUI

struct CalendarView1: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: CalendarView1

        init(parent: CalendarView1) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            // Handle completion if needed
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    @Environment(\.presentationMode) var presentationMode
    var eventStore = EKEventStore()

    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = UIViewController() // Replace with your SwiftUI Calendar implementation
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Update if needed
    }
    
}



import UIKit
import EventKit
import CalendarKit
import EventKitUI

final class EKWrapper: EventDescriptor {
    public var dateInterval: DateInterval {
        get {
            DateInterval(start: ekEvent.startDate, end: ekEvent.endDate)
        }
        
        set {
            ekEvent.startDate = newValue.start
            ekEvent.endDate = newValue.end
        }
    }
    
    public var isAllDay: Bool {
        get {
            ekEvent.isAllDay
        }
        set {
            ekEvent.isAllDay = newValue
        }
    }
    
    public var text: String {
        get {
            ekEvent.title
        }
        
        set {
            ekEvent.title = newValue
        }
    }

    public var attributedText: NSAttributedString?
    public var lineBreakMode: NSLineBreakMode?
    
    public var color: UIColor {
        get {
            UIColor(cgColor: ekEvent.calendar.cgColor)
        }
    }
    
    public var backgroundColor = UIColor()
    public var textColor = SystemColors.label
    public var font = UIFont.boldSystemFont(ofSize: 12)
    public weak var editedEvent: EventDescriptor? {
        didSet {
            updateColors()
        }
    }
    
    public private(set) var ekEvent: EKEvent
    
    public init(eventKitEvent: EKEvent) {
        self.ekEvent = eventKitEvent
        applyStandardColors()
    }
    
    public func makeEditable() -> Self {
        let cloned = Self(eventKitEvent: ekEvent)
        cloned.editedEvent = self
        return cloned
    }
    
    public func commitEditing() {
        guard let edited = editedEvent else {return}
        edited.dateInterval = dateInterval
    }
    
    private func updateColors() {
      (editedEvent != nil) ? applyEditingColors() : applyStandardColors()
    }
    
    /// Colors used when event is not in editing mode
    private func applyStandardColors() {
      backgroundColor = dynamicStandardBackgroundColor()
      textColor = dynamicStandardTextColor()
    }
    
    /// Colors used in editing mode
    private func applyEditingColors() {
      backgroundColor = color.withAlphaComponent(0.95)
      textColor = .white
    }
    
    /// Dynamic color that changes depending on the user interface style (dark / light)
    private func dynamicStandardBackgroundColor() -> UIColor {
      let light = backgroundColorForLightTheme(baseColor: color)
      let dark = backgroundColorForDarkTheme(baseColor: color)
      return dynamicColor(light: light, dark: dark)
    }
    
    /// Dynamic color that changes depending on the user interface style (dark / light)
    private func dynamicStandardTextColor() -> UIColor {
      let light = textColorForLightTheme(baseColor: color)
      return dynamicColor(light: light, dark: color)
    }
    
    private func textColorForLightTheme(baseColor: UIColor) -> UIColor {
      var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
      baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
      return UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a)
    }
    
    private func backgroundColorForLightTheme(baseColor: UIColor) -> UIColor {
      baseColor.withAlphaComponent(0.3)
    }
    
    private func backgroundColorForDarkTheme(baseColor: UIColor) -> UIColor {
      var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
      color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
      return UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a * 0.8)
    }
    
    private func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
      if #available(iOS 13.0, *) {
        return UIColor { traitCollection in
          let interfaceStyle = traitCollection.userInterfaceStyle
          switch interfaceStyle {
          case .dark:
            return dark
          default:
            return light
          }
        }
      } else {
        return light
      }
    }
}




struct ContentView2: View {
    var body: some View {
        NavigationView {
            VStack {
                // Your other SwiftUI content here
                CalendarView1()
                    .navigationBarTitle("CalendarKit")
            }
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}

