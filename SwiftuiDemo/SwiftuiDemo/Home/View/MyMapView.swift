//
//  MyMapView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 15/05/24.
//

import SwiftUI
import MapKit
import SwiftData

struct MyMapView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @State private var cameraPosition:  MapCameraPosition = .userLocation(fallback: .automatic)
    @Query private var destinations: [Destination]
    @State private var destination: Destination?
    @State private var visibleRegion: MKCoordinateRegion?
    @Query private var listPlacemarks: [MTPlacemark]
    var body: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
            if let placemarks = destination?.placemarks {
                ForEach(placemarks) { placemark in
                    Marker(coordinate: placemark.coordinate) {
                        Label(placemark.name, systemImage: "star")
                    }
                    .tint(.yellow)
                }
            }
        }
        .onAppear {
            destination = destinations.first
            if let region = destination?.region {
                cameraPosition = .region(region)
            }
           // updateCameraPosition()
        }
        .onMapCameraChange(frequency: .onEnd){ context in
            visibleRegion = context.region
        }
        .mapControls {
            MapUserLocationButton()
        }
    }
    
    private func updateCameraPosition() {
        if let userLocation = locationManager.userLocation {
            let userRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 0.10, longitudinalMeters: 0.10)
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
}

#Preview {
    MyMapView()
}


