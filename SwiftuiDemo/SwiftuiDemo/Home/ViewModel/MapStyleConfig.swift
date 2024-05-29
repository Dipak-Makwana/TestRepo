//
//  MapStyleConfig.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 28/05/24.
//

import SwiftUI
import MapKit


struct MapStyleConfig {
    
    enum BaseMapStyle: CaseIterable {
        case standard, hybrid, imagery
        var label: String {
            switch self {
            case .standard: "Standard"
            case .hybrid:
                "Satelight with Roads"
            case .imagery:
                "Satelight Only"
            }
        }
    }
    
    enum MapElevation {
        case flat, realistic
        var selection: MapStyle.Elevation {
            switch self {
            case .flat:
                    .flat
            case .realistic:
                    .realistic
            }
        }
    }
    enum MapPOI {
        case all, excludingAll
        
        var selection: PointOfInterestCategories {
            switch self {
            case .all:
                    .all
            case .excludingAll:
                    .excludingAll
            }
        }
        
    }
    
    var baseStyle = BaseMapStyle.standard
    var elevation = MapElevation.flat
    var poi = MapPOI.excludingAll
    
    var showTraffic = false
    
    var mapStyle: MapStyle {
        switch baseStyle {
            
        case .standard:
            MapStyle.standard(elevation: elevation.selection,pointsOfInterest: poi.selection,showsTraffic: showTraffic)
        case .hybrid:
            MapStyle.hybrid(elevation: elevation.selection,pointsOfInterest: poi.selection,showsTraffic: showTraffic)
        case .imagery:
            MapStyle.imagery(elevation: elevation.selection)
        }
    }
}
