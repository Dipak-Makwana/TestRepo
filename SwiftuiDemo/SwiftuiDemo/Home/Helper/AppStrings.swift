//
//  AppStrings.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 29/05/24.
//

import Foundation

typealias str = AppStrings

struct AppStrings {
    static let welcomeMessage = "Welcome to My App"
    static let loginButtonTitle = "Log In"
    static let ok = "OK"
    static let mapStyle = "Map Style"
    static let showTraffic = "Show Traffic"
    static let poi = "Point of Interest"
    static let elevation = "Elevation"
    static let none = "None"
    static let all = "All"
    static let flat = "Flat"
    static let realistic = "Realistic"
    static let baseStyle = "Base Style"
    static let clearRoute = "Clear Route"
    static let showRoute = "Show Route"
    static let showSteps = "Show Steps"
    static let on = "ON"
    static let off = "OFF"
    static let tapMarker = "Tap marker placement is"
    static let search = "Search..."
    static let enterDestinationName = "Enter Destination Name"
    static let name = "Name"
    static let adjustMap = "Adjust map to set the region for your destination"
    static let setRegion = "Set Region"
    static let destination = "Destination"
    static let myDestination = "My Destinations"
    static let createDestination = "Create a new destination"
    static let cancel = "Cancel"
    static let noDestination = "No Destinations"
    static let delete = "Delete"
    static let address = "Address"
    static let update = "Update"
    static let remove = "Remove"
    static let add = "Add"
    static let noPreviewAvailabel = "No Preview Available"
    static let driving = "Driving"
    static let walking = "Walking"
    static let time = "Time"
    static let openInMaps = "Open In Maps"
    static let drive = "Drive"
    static let walk = "Walk"
    static let steps = "Steps"
    static let fromMyLocation = "From My Location"
    // Add more constants as needed
}

extension String {
    var mapStyle: String { "Map Style" }
    var ok: String { "OK" }
}
