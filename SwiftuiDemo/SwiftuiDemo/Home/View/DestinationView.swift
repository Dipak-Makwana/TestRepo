//
//  DestinationView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 20/05/24.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(MyPlaces.places) { place in
                //  Marker(place.title, coordinate: place.coordinate)
                
                //                Marker(coordinate: place.coordinate, label: {
                //                    Label(place.title, systemImage: place.image)
                //
                //                })
                //                .tint(place.tintColor)
                
                Annotation(place.title, coordinate: place.coordinate, content: {
                    Image(systemName: place.image)
                        .imageScale(.large)
                        .foregroundStyle(place.tintColor)
                        .padding(10)
                        .background(.white)
                        .clipShape(Circle())
                })
                
                MapCircle(center: .shriRamJanamBhumi, radius: 5000)
                    .foregroundStyle(.blue.opacity(0.1))
            }
            
        }
        .onMapCameraChange(frequency: .onEnd, { context in
            visibleRegion = context.region
        })
        .onAppear {
            
            let ayodhya = CLLocationCoordinate2D(latitude: 26.795479, longitude: 82.194316)
            let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            let ayodhyaRegion = MKCoordinateRegion(center: ayodhya, span: span)
            cameraPosition = .region(ayodhyaRegion)
        }
    }
}

#Preview {
    DestinationView()
        .modelContainer(Destination.preview)
}
