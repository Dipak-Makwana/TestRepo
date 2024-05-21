//
//  SampleLocations.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 21/05/24.
//

import CoreLocation
import SwiftUI

struct MyPlaces: Identifiable {
    let id = UUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
    let tintColor: Color
    let image: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, tintColor: Color, imageName: String = "house.fill") {
        self.title = title
        self.coordinate = coordinate
        self.tintColor = tintColor
        self.image = imageName
    }
    
    static var places: [MyPlaces] {
        return [
        
            MyPlaces(title: "Ayodhya Airport", coordinate: .ayodhyaAirport, tintColor: .cyan,imageName:"airplane.arrival"),
            MyPlaces(title: "Shri Ram Janam Bhumi", coordinate: .shriRamJanamBhumi, tintColor: .orange),
            MyPlaces(title: "Shri Ram Janam Bhumi2", coordinate: .shriRamJanamBhumi2, tintColor: .orange),
            MyPlaces(title: "Shri Hanuman Garhi", coordinate: .shreeHanumanGarhi, tintColor: .orange),
            MyPlaces(title: "Dashrath Mahal", coordinate: .dashrathMahal, tintColor: .cyan),
            MyPlaces(title: "Hotel Surya Palace", coordinate: .hotelSuryaPalace, tintColor: .red),
        
        ]
    }
}

// Sample Ayodhya Location
extension CLLocationCoordinate2D {
    static let ayodhyaAirport: Self = .init(
        latitude: 26.748197,
        longitude: 82.150602
    )
    
    static let shriRamJanamBhumi: Self = .init(
        latitude: 26.7892357,
        longitude: 82.1971316
    )
    
    static let shriRamJanamBhumi2: Self = .init(
        latitude:  26.796502220733597,
        longitude: 82.19752908913104
    )
    static let shriRamJanamBhumi3: Self = .init(
        latitude: 26.795913230561627,
        longitude: 82.19446605793306
    )
    static let shreeHanumanGarhi: Self = .init(
        latitude: 26.795539558018277,
        longitude: 82.20227962536545
    )
    static let dashrathMahal: Self = .init(
        latitude: 26.796821804778002,
        longitude: 82.20053387333384
    )
    static let maharishiValmikiAirport: Self = .init(
        latitude: 26.747960081823067,
        longitude: 82.15130324136038
    )
    static let hotelSuryaPalace: Self = .init(
        latitude: 26.797795320577645,
        longitude: 82.21978402785206
    )
}
