//
//  LocationManager.swift
//  MapViewInSwiftUI
//
//  Created by Dipak Makwana on 16/05/24.
//

import Foundation
import MapKit

//@Observable
class LocationManager: NSObject ,ObservableObject{
    private let locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var userLocation: CLLocation?
    @Published var isAuthorized: Bool = false
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        startLocationService()
    }
    
    func startLocationService() {
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            isAuthorized = true
            locationManager.startUpdatingLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
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
        self.authorizationStatus = status
        
        switch status {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.locationManager.requestWhenInUseAuthorization()
        case .denied:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            startLocationService()
        case .authorizedWhenInUse:
            startLocationService()
        @unknown default:
            startLocationService()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isAuthorized = false 
        debugPrint("Error in Location Manager \(error.localizedDescription)")
    }
}
