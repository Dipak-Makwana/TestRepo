//
//  MapManager.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 22/05/24.
//

import SwiftData
import MapKit

enum MapManager {
    
    @MainActor
    
    static func searchPlaces(modelContext: ModelContext, searchText: String, visibleRegion: MKCoordinateRegion?) async {
        removeSearchResults(modelContext)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        if let visibleRegion {
            request.region = visibleRegion
        }
        
        let searchItems = try? await MKLocalSearch(request: request).start()
        let results = searchItems?.mapItems ?? []
        results.forEach {
            let mtPlacemark = MTPlacemark(name: $0.placemark.name ?? "", address: $0.placemark.title ?? "", latitude: $0.placemark.coordinate.latitude, longitude: $0.placemark.coordinate.longitude)
            modelContext.insert(mtPlacemark)
        }
    }
    static func removeSearchResults(_ modelContext: ModelContext) {
        let searchPredicate = #Predicate<MTPlacemark> {$0.destination == nil }
        try? modelContext.delete(model: MTPlacemark.self,where: searchPredicate)
    }
    
}