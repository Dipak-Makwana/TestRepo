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
    @State private var pickerMapStyle: Bool = false
    @Namespace private var mapScope
    
    private var listPlaceMark: [MTPlacemark] {
        searchPlaceMarks + selectedDestination.placemarks
    }
    var selectedDestination: Destination
    
    // Route
    @State private var showSteps: Bool = false
    @State private var showRoute: Bool = false
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var timeInterval: TimeInterval?
    @State private var transportType =  MKDirectionsTransportType.automobile
    @State private var mapStyleConfig = MapStyleConfig()
    
    var body: some View {
        setRegionView
        mapView
            
            .safeAreaInset(edge: .bottom) {
                VStack {
                    toggleMarker
                        .padding(8)
                    if !isManualMarker {
                        HStack {
                            searchTextField
                                .padding()
                            if !searchPlaceMarks.isEmpty {
                                removeResultButton
                            }
                            mapButtons
                        }
                    }
                    if routeDisplaying {
                        routeButtons
                    }
                }
            }
            .sheet(item: $selectedPlaceMark) { selectedPlace in
                openLocationDetailView()
            }
            .task(id: selectedPlaceMark) {
                await fetchRoute()
            }
            .task(id: transportType) {
                await fetchRoute()
            }
            .onChange(of: showRoute) {
                drawRoute()
            }
            .onMapCameraChange(frequency: .onEnd, { context in
                visibleRegion = context.region
            })
            .mapStyle(mapStyleConfig.mapStyle)
            .onAppear {
                removeResult()
                setRegion()
            }
            .onDisappear {
                removeResult()
            }
            .navigationTitle(str.destination)
            .navigationBarTitleDisplayMode(.inline)
    }
    private var mapButtons: some View {
        VStack {
            
            Button {
                pickerMapStyle.toggle()
            } label: {
                Image(systemName: img.globe_america_fill)
                    .imageScale(.large)
            }
            
            .padding(8)
            .background(.thickMaterial)
            .addBorder(.blue, width: 0.5, cornerRadius: 20)
//            .clipShape(.circle)
//            .overlay( /// apply a rounded border
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(.blue, lineWidth: 3)
//            )
            .sheet(isPresented: $pickerMapStyle) {
                MapStyleView(mapConfig: $mapStyleConfig)
                    .presentationDetents([.height(270)])
            }
////            
////
//            MapCompass(scope: mapScope)
//                .mapControlVisibility(.visible)
//                .background(.thickMaterial)
//                .clipShape(.circle)
////            MapScaleView(scope: mapScope)
////                .mapControlVisibility(.visible)
////                .background(.thickMaterial)
////                .clipShape(.circle)
//            MapPitchToggle(scope: mapScope)
//                .mapControlVisibility(.visible)
//                .background(.thickMaterial)
//                .clipShape(.circle)
        }
    }
    private var routeButtons: some View {
        HStack {
            Button(str.clearRoute,systemImage: img.xmark_circle_fill) {
                resetRouteValue()
                updateCameraPosition()
            }
            .buttonStyle(.borderedProminent)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.bottom,16)
            
            Button(str.showSteps,systemImage: img.location_north) {
                showSteps.toggle()
            }
            .buttonStyle(.borderedProminent)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.bottom,16)
            
            .sheet(isPresented: $showSteps, content: {
                DirectionStepsView(route: $route, transportType: $transportType)
            })
        }
    }
    func updateCameraPosition() {
        if let userLocation = locationManager.userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
    private func drawRoute() {
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
    private func openLocationDetailView() ->  some View {
        LocationDetailView(destination: selectedDestination,selectedPlacemark: selectedPlaceMark, showRoute: $showRoute,timeInterval: $timeInterval,transportType: $transportType)
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
            Label(" \(str.tapMarker) \(isManualMarker ?  str.on : str.off)", systemImage: isManualMarker ? img.mappin_slash : img.mappin_slash_circle)
        }
        .fontWeight(.bold)
        .toggleStyle(.button)
        .background(.ultraThinMaterial)
        .onChange(of: isManualMarker) {
            removeResult()
        }
    }
    private var searchTextField: some View {
        TextField(str.search, text: $searchText)
            .textFieldStyle(.roundedBorder)
            .focused($searchFieldFocus)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .overlay(alignment: .trailing) {
                if searchFieldFocus {
                    Button {
                        clearSearch()
                    } label: {
                        clearImage
                    }
                    .offset(x: -5)
                }
            }
            .onSubmit {
                saveSearchItem()
            }
    }
    private var clearImage: some View {
        Image(systemName: img.xmark_circle_fill)
    }
    private func clearSearch() {
        searchText = ""
        searchFieldFocus = false
    }
    private func saveSearchItem() {
        Task { @MainActor in
            await MapManager.searchPlaces(
                modelContext:modelContext,
                searchText:searchText,
                visibleRegion: visibleRegion
            )
            searchText = ""
        }
    }
    private var removeResultButton: some View  {
        Button {
            removeResult()
        } label: {
            Image(systemName: img.mappin_slash_circle_fill)
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
                TextField(str.enterDestinationName, text: $destination.name)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.primary)
            } label: {
                Text(str.name)
            }
            regionButton
        }
        .padding(.horizontal)
    }
    private var regionButton: some View {
        HStack {
            Text(str.adjustMap)
                .foregroundStyle(.secondary)
            Spacer()
            Button(str.setRegion) {
                setRegionValues()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    private func setRegionValues() {
        @Bindable var destination = selectedDestination
        if let visibleRegion {
            destination.latitude = visibleRegion.center.latitude
            destination.longitude = visibleRegion.center.longitude
            destination.latitudeDelta = visibleRegion.span.latitudeDelta
            destination.longitudeDelta = visibleRegion.span.longitudeDelta
        }
        
    }
    private func markerWithSystemImage(_ place: MTPlacemark) -> Marker<Label<Text,Image>> {
        return Marker(place.name, systemImage: img.star, coordinate: place.coordinate)
    }
    private func marker(_ place: MTPlacemark) -> Marker<Text> {
        return Marker(place.name, coordinate: place.coordinate)
    }
    private var mapView: some View {
        MapReader { proxy in
            Map(position: $cameraPosition,selection: $selectedPlaceMark,scope: mapScope) {
                UserAnnotation()
                ForEach(listPlaceMark) { place in
                    
                    if isManualMarker {
                        if place.destination != nil {
                            markerWithSystemImage(place)
                                .tint(.blue)
                        }
                        else {
                            marker(place)
                                .tint(.red)
                        }
                    }
                    else {
                        if !showRoute {
                            Group {
                                if place.destination != nil {
                                    markerWithSystemImage(place)
                                        .tint(.blue)
                                }
                                else {
                                    marker(place)
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
            .mapControls {
                MapUserLocationButton()
                MapScaleView()
                MapCompass()
                MapPitchToggle()
            }
            .mapScope(mapScope)
        }
    }
    
    private func resetRouteValue() {
        routeDisplaying = false
        showRoute = false
        route = nil
        selectedPlaceMark = nil
    }
    private func resetValues() {
        if selectedPlaceMark != nil {
            routeDisplaying = false
            showRoute = false
            route = nil
        }
    }
    private func fetchRoute() async {
        resetValues()
        if let userLocation = locationManager.userLocation,let selectedPlaceMark {
            let source = MKPlacemark(coordinate: userLocation.coordinate)
            let routeSource = MKMapItem(placemark: source)
            let destination = MKPlacemark(coordinate: selectedPlaceMark.coordinate)
            routeDestination = MKMapItem(placemark: destination)
            let request = MKDirections.Request()
            routeDestination?.name = selectedPlaceMark.name
            request.source = routeSource
            request.destination = routeDestination
            request.transportType = transportType
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
