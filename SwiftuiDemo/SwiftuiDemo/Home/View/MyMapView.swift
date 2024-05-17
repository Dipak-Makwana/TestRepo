//
//  MyMapView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 15/05/24.
//

import SwiftUI
import MapKit

struct MyMapView: View {
    
    @State private var cameraPosition:  MapCameraPosition = .userLocation(fallback: .automatic)
    var body: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()
            
        }
    }
}

#Preview {
    MyMapView()
}


