//
//  LocationManager.swift
//  MrS-Cool
//
//  Created by mohamed hammam on 18/08/2025.
//

import SwiftUI
import CoreLocation

//class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
//    static let shared = LocationService()
//     let manager = CLLocationManager()
//    @Published var countryCode: String?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location) { placemarks, error in
//            if let country = placemarks?.first?.isoCountryCode {
//                DispatchQueue.main.async {
//                    self.countryCode = country
//                }
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get location:", error.localizedDescription)
//    }
//}
class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationService()

    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var countryCode: String?

    private var lastLookupTime: Date?
    private var lastCountryCode: String?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        // ⏱ Throttle: only check every 60 seconds
        if let last = lastLookupTime, Date().timeIntervalSince(last) < 60 {
            return
        }

        // 🛑 If already got a country, stop updating
        if lastCountryCode != nil {
            manager.stopUpdatingLocation()
            return
        }

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let code = placemarks?.first?.isoCountryCode {
                DispatchQueue.main.async {
                    self.lastLookupTime = Date()
                    self.lastCountryCode = code
                    self.countryCode = code
                    print("🌍 Detected Country: \(code)")

                    // Stop updates after success (optional)
                    manager.stopUpdatingLocation()
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location:", error.localizedDescription)
    }
}


//MARK: --- plain (not just swiftui) ---
//class LocationService: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationService()
//    private let locationManager = CLLocationManager()
//    var onCountryDetected: ((String?) -> Void)?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            let countryCode = placemarks?.first?.isoCountryCode
//            self.onCountryDetected?(countryCode)
//            manager.stopUpdatingLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get location: \(error.localizedDescription)")
//        onCountryDetected?(nil)
//    }
//}
