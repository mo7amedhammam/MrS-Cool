//
//  eventKit.swift
//  MrS-Cool
//
//  Created by wecancity on 20/12/2023.
//

import SwiftUI
import EventKit
import EventKitUI

struct CalView2: View {
    @State private var isPresentingEventView = false

    var body: some View {
        VStack {
            Button("Show Calendar") {
                isPresentingEventView.toggle()
            }
            .eventSheet(isPresented: $isPresentingEventView) {
                EventKitView(isPresented: $isPresentingEventView)
            }
        }
        .padding()
    }
}

struct EventKitView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventVC = EKEventEditViewController()
        eventVC.eventStore = EKEventStore()
        eventVC.editViewDelegate = context.coordinator
        return eventVC
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventKitView

        init(_ parent: EventKitView) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.isPresented = false
        }
    }
}

extension View {
    func eventSheet<Sheet>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Sheet) -> some View where Sheet: View {
        modifier(EventSheetModifier(isPresented: isPresented, sheetContent: content))
    }
}

struct EventSheetModifier<Sheet>: ViewModifier where Sheet: View {
    @Binding var isPresented: Bool
    @ViewBuilder var sheetContent: () -> Sheet

    func body(content: Content) -> some View {
        content
            .background(
                EmptyView()
                    .sheet(isPresented: $isPresented, content: sheetContent)
            )
    }
}

struct CalView_Previews: PreviewProvider {
    static var previews: some View {
        CalView2()
    }
}
