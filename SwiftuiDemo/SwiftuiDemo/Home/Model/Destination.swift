//
//  Destination.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 20/05/24.
//

import SwiftData
import MapKit

@Model
class Destination {
    var name: String
    var latitude: Double?
    var longitude: Double?
    var latitudeDelta: Double?
    var longitudeDelta: Double?
    @Relationship(deleteRule: .cascade)
    var placemarks: [MTPlacemark] = []
    
    init(name: String, latitude: Double? = nil, longitude: Double? = nil, latitudeDelta: Double? = nil, longitudeDelta: Double? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
    
    var region: MKCoordinateRegion? {
        if let latitude, let longitude, let latitudeDelta, let longitudeDelta {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            )
        } else {
            return nil
        }
    }
}

extension Destination {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Destination.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
       
        let ayodhya = Destination(
            name: "Ayodhya ",
            latitude: 26.795479,
            longitude: 82.194316,
            latitudeDelta: 0.15,
            longitudeDelta: 0.15
        )
        container.mainContext.insert(ayodhya)
         var placeMarks: [MTPlacemark] {
             [
                MTPlacemark(name: "Ayodhya Airport", address: "",latitude: 26.748197,longitude: 82.150602),
                MTPlacemark(name: "Shri Ram Janam Bhumi", address: "",latitude: 26.7892357,longitude: 82.1971316),
                MTPlacemark(name: "Shri Ram Janam Bhumi-2", address: "",latitude: 26.796502220733597,longitude: 82.19752908913104),
                MTPlacemark(name: "Shri Ram Janam Bhumi-3", address: "",latitude: 26.795913230561627,longitude: 82.19446605793306),
                MTPlacemark(name: "Shri Hanuman Garhi", address: "",latitude: 26.795539558018277,longitude: 82.20227962536545),
                MTPlacemark(name: "Dashrath Mahal", address: "",latitude: 26.796821804778002,longitude: 82.20053387333384),
                MTPlacemark(name: "Hotel Surya Palace", address: "",latitude: 26.797795320577645,longitude: 82.21978402785206),
                
            ]
        }
        placeMarks.forEach { placemark in
            ayodhya.placemarks.append(placemark)
        }
        return container
    }
}

