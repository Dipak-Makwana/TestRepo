//
//  DestinationView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 20/05/24.
//

import SwiftUI
import MapKit
import SwiftData

struct DestinationView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var locationManager: LocationManager
    @Query(filter: #Predicate<MTPlacemark> {$0.destination == nil }) private var searchPlaceMarks: [MTPlacemark]
    @FocusState private var searchFieldFocus: Bool
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchText: String = ""
    @State private var selectedPlaceMark: MTPlacemark?
    @State private var isManualMarker: Bool = false
    
    private var listPlaceMark: [MTPlacemark] {
        searchPlaceMarks + selectedDestination.placemarks
    }
    var selectedDestination: Destination
    
    // Route
    @State private var showRoute: Bool = false 
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var timeInterval: TimeInterval?
    @State private var transportType =  MKDirectionsTransportType.automobile
    
    var body: some View {
        setRegionView
        mapView
            .safeAreaInset(edge: .bottom) {
                VStack {
                    toggleMarker
                    if !isManualMarker {
                        searchTextField
                    }
                }
            }
            .sheet(item: $selectedPlaceMark) { selectedPlace in
                openLocationDetailView()
            }
            .task(id: selectedPlaceMark) {
                if selectedPlaceMark != nil {
                    routeDisplaying = false
                    showRoute = false
                    route = nil
                    await fetchRoute()
                }
            }
            .onChange(of: showRoute) {
                selectedPlaceMark = nil 
                if showRoute {
                    withAnimation {
                        routeDisplaying = true
                        if let rect = route?.polyline.boundingMapRect {
                            cameraPosition = .rect(rect)
                        }
                    }
                }
            }
            .onMapCameraChange(frequency: .onEnd, { context in
                visibleRegion = context.region
            })
            .onAppear {
                removeResult()
                setRegion()
            }
            .onDisappear {
                removeResult()
            }
            .navigationTitle("Destination")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openLocationDetailView() ->  some View {
        LocationDetailView(destination: selectedDestination,selectedPlacemark: selectedPlaceMark, showRoute: $showRoute)
            .presentationDetents([.height(450)])
    }
    private func setRegion() {
        if let currentRegion = selectedDestination.region {
            cameraPosition = .region(currentRegion)
        }
    }
    private func removeResult() {
        MapManager.removeSearchResults(modelContext)
    }
    private var toggleMarker: some View {
        Toggle(isOn: $isManualMarker) {
        Label("Tap marker placement is \(isManualMarker ?  "ON" : "OFF")", systemImage: isManualMarker ? "mappin.circle" : "mappin.slash.circle")
        }
        .fontWeight(.bold)
        .padding(.horizontal)
        .toggleStyle(.button)
        .background(.ultraThinMaterial)
        .onChange(of: isManualMarker) {
            removeResult()
        }
    }
    private var searchTextField: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .focused($searchFieldFocus)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .overlay(alignment: .trailing) {
                    if searchFieldFocus {
                        Button {
                            searchText = ""
                            searchFieldFocus = false
                        }label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .offset(x: -5)
                    }
                }
                .onSubmit {
                    Task { @MainActor in
                        await MapManager.searchPlaces(
                            modelContext:modelContext,
                            searchText:searchText,
                            visibleRegion: visibleRegion
                        )
                        searchText = ""
                    }
                }
            if !searchPlaceMarks.isEmpty {
                removeResultButton
            }
        }
        .padding()
    }
    private var removeResultButton: some View  {
        Button {
           removeResult()
        } label: {
            Image(systemName: "mappin.slash.circle.fill")
                .imageScale(.large)
        }
        .foregroundStyle(.white)
        .padding(8)
        .background(.red)
        .clipShape(.circle)
    }
    
    private var setRegionView: some View {
        @Bindable var destination = selectedDestination
        return VStack {
            LabeledContent {
                TextField("Enter detination name", text: $destination.name)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.primary)
            } label: {
                Text("Name")
            }
            HStack {
                Text("Adjust map to set the region for your destination")
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Set Region") {
                    if let visibleRegion {
                        destination.latitude = visibleRegion.center.latitude
                        destination.longitude = visibleRegion.center.longitude
                        destination.latitudeDelta = visibleRegion.span.latitudeDelta
                        destination.longitudeDelta = visibleRegion.span.longitudeDelta
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal)
    }
    
    private var mapView: some View {
        MapReader { proxy in
            Map(position: $cameraPosition,selection: $selectedPlaceMark) {
                ForEach(listPlaceMark) { place in
                    
                    if isManualMarker {
                        if place.destination != nil {
                            Marker(place.name, systemImage: "star", coordinate: place.coordinate)
                                .tint(.blue)
                        }
                        else {
                            Marker(place.name, coordinate: place.coordinate)
                                .tint(.red)
                        }
                    }
                    else {
                        if !showRoute {
                            Group {
                                if place.destination != nil {
                                    Marker(place.name, systemImage: "star", coordinate: place.coordinate)
                                        .tint(.blue)
                                }
                                else {
                                    Marker(place.name, coordinate: place.coordinate)
                                        .tint(.red)
                                }
                            }.tag(place)

                        }
                        else {
                            if let routeDestination {
                                Marker(item: routeDestination)
                                    .tint(.green)
                            }
                        }
                    }
                    if let route, routeDisplaying {
                        MapPolyline(route.polyline)
                            .stroke(.blue,lineWidth: 6)
                    }

                   
                }
                            }
            .onTapGesture { position in
                if isManualMarker {
                    if let coordinate = proxy.convert(position, from: .local) {
                        let mtPlacemark = MTPlacemark(name: "", address: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                        modelContext.insert(mtPlacemark)
                        selectedPlaceMark = mtPlacemark
                    }
                }
                debugPrint(position)
            }
        }
        
    }
    
    private func fetchRoute() async {
        if let userLocation = locationManager.userLocation,let selectedPlaceMark {
            let source = MKPlacemark(coordinate: userLocation.coordinate)
            let routeSource = MKMapItem(placemark: source)
            let destination = MKPlacemark(coordinate: selectedPlaceMark.coordinate)
             routeDestination = MKMapItem(placemark: destination)
            let request = MKDirections.Request()
            routeDestination?.name = selectedPlaceMark.name
            
            request.source = routeSource
            request.destination = routeDestination
            
            let direction = MKDirections(request: request)
            let results = try? await direction.calculate()
            route = results?.routes.first
            timeInterval =  route?.expectedTravelTime
        }
    }
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor)[0]
    return NavigationStack {
        DestinationView(selectedDestination: destination)
            .modelContainer(Destination.preview)
        
    }
}
