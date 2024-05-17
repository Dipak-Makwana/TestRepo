//
//  LocationManager.swift
//  MapViewInSwiftUI
//
//  Created by Dipak Makwana on 16/05/24.
//

import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    public func requestAuthorisation(always: Bool = false) {
        if always {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
        
        switch status {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.locationManager.requestWhenInUseAuthorization()
        case .denied:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            self.locationManager.requestWhenInUseAuthorization()
        @unknown default:
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}
