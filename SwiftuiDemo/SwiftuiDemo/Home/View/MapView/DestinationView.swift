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
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @Query(filter: #Predicate<MTPlacemark> {$0.destination == nil }) private var searchPlaceMarks: [MTPlacemark]
    private var listPlaceMark: [MTPlacemark] {
        searchPlaceMarks + selectedDestination.placemarks
    }
    var selectedDestination: Destination
    @State private var searchText: String = ""
    @FocusState private var searchFieldFocus: Bool
    @State private var selectedPlaceMark: MTPlacemark?
    
    var body: some View {
        setRegionView
        mapView
            .safeAreaInset(edge: .bottom) {
                searchTextField
            }
            .sheet(item: $selectedPlaceMark) { selectedPlace in
                
                LocationDetailView(destination: selectedDestination,selectedPlacemark: selectedPlaceMark)
                    .presentationDetents([.height(450)])
            }
            .onMapCameraChange(frequency: .onEnd, { context in
                visibleRegion = context.region
            })
            .onAppear {
                MapManager.removeSearchResults(modelContext)
                if let currentRegion = selectedDestination.region {
                    cameraPosition = .region(currentRegion)
                }
            }
            .onDisappear {
                MapManager.removeSearchResults(modelContext)
            }
            .navigationTitle("Destination")
            .navigationBarTitleDisplayMode(.inline)
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
                Button {
                    MapManager.removeSearchResults(modelContext)
                } label: {
                    Image(systemName: "mappin.slash.circle.fill")
                        .imageScale(.large)
                }
                .foregroundStyle(.white)
                .padding(8)
                .background(.red)
                .clipShape(.circle)
            }
        }
        .padding()
        
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
            }
        }
        .onTapGesture { position in
            debugPrint(position)
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
