//
//  LocationDetailView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 22/05/24.
//

import SwiftUI
import SwiftData
import MapKit

extension LocationDetailView {
    var isChanged: Bool {
        guard let selectedPlacemark else { return false }
            return (name != selectedPlacemark.name || address != selectedPlacemark.address)
    }
}

struct LocationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var lookArroundScene: MKLookAroundScene?
    var destination: Destination?
    var selectedPlacemark: MTPlacemark?
    @Binding var showRoute: Bool 
    @Binding var timeInterval: TimeInterval?
    @Binding var transportType: MKDirectionsTransportType
    
    var travelTime: String? {
        guard let timeInterval else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour,.minute]
        return formatter.string(from: timeInterval)
    }
    
    private var nameAndAddressTextField: some View {
        VStack(alignment: .leading) {
            TextField(str.name, text: $name)
                .font(.title2)
            TextField(str.address , text: $address,axis: .vertical)
                .font(.caption)
        }
        .textFieldStyle(.roundedBorder)
    }
    
    private var updateButton: some View {
        Button(str.update) {
            selectedPlacemark?.name = name.removeWhiteSpace()
            selectedPlacemark?.address = address.removeWhiteSpace()
            dismiss()
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .buttonStyle(.borderedProminent)
    }
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: img.xmark_circle_fill)
                .imageScale(.large)
                .foregroundStyle(.gray)
        }
    }
    private var lookAroundView: some View {
        LookAroundPreview(initialScene: lookArroundScene)
            .frame(height: 200)
            .padding()
    }
    private func  addOrRemoveButton(inList: Bool) -> some View {
        let inList = (selectedPlacemark != nil && selectedPlacemark?.destination != nil)
        return Button {
            if let selectedPlacemark {
                if selectedPlacemark.destination == nil {
                    destination?.placemarks.append(selectedPlacemark)
                }
                else {
                    selectedPlacemark.destination = nil
                }
                dismiss()
            }
        } label: {
            Label(inList ? str.remove : str.add, systemImage: inList ? img.minus_circle : img.plus_circle)
        }
        .buttonStyle(.borderedProminent)
        .tint(inList ? .red : .green)
        .disabled(name.isEmpty || isChanged)
    }
    
    var body: some View {
        VStack {
            HStack {
                nameAndAddressTextField
                if isChanged {
                    Spacer()
                    updateButton
                }
                closeButton
            }
            if destination != nil {
               travelOption
            }
            if let _  = lookArroundScene {
                lookAroundView
            }
            else {
                MyContentUnAvailableView(title: str.noPreviewAvailabel,image: img.eye_slash)
            }
            HStack {
                Spacer()
                if let _ = destination {
                    let inList = (selectedPlacemark != nil && selectedPlacemark?.destination != nil)
                    addOrRemoveButton(inList: inList)
                }
                else {
                    openInMapsButtons
                }
            }
            Spacer()
        }
        .padding()
        .task(id: selectedPlacemark) {
             await fetchLookArroundScene()
        }
        .onAppear {
            setDefaultValue()
        }
    }
    private var travelOption: some View {
        HStack {
            Button {
                transportType = .automobile
            } label: {
                Image(systemName: img.car)
                    .imageScale(.large)
                    .symbolVariant(transportType == .automobile ? .circle : .none)
            }
            Button {
                transportType = .walking
            } label: {
                Image(systemName: img.figure_walk)
                    .imageScale(.large)
                    .symbolVariant(transportType == .walking ? .circle : .none)
            }
            if let travelTime {
                let prefix = transportType == .automobile ? str.driving : str.walking
                Text("\(prefix) \(str.time): \(travelTime)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
    
    private var openInMapsButtons: some View {
        HStack {
            mapButton
            showRouteButton
        }
        .buttonStyle(.borderedProminent)
    }
    private var mapButton: some View {
        Button(str.openInMaps,systemImage: img.map) {
            if let selectedPlacemark {
                let placemark = MKPlacemark(coordinate: selectedPlacemark.coordinate)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = selectedPlacemark.name
                mapItem.openInMaps()
            }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
    private var showRouteButton: some View {
        Button(str.showRoute,systemImage: img.location_north) {
            showRoute.toggle()
        }
        .fixedSize(horizontal: true, vertical: false)
    }
    
    private func fetchLookArroundScene() async {
        if let selectedPlacemark {
            lookArroundScene = nil
            let lookAroundReq = MKLookAroundSceneRequest(coordinate: selectedPlacemark.coordinate)
            lookArroundScene = try? await lookAroundReq.scene
        }
    }
    private func setDefaultValue() {
        if let placemark = selectedPlacemark, destination != nil {
            name = placemark.name
            address = placemark.address
        }
    }
}

#Preview("Destinatation Tab") {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor)[0]
    let placeMark = destination.placemarks.first
    return LocationDetailView(destination: destination, selectedPlacemark: placeMark, showRoute: .constant(false),timeInterval: .constant(nil),transportType: .constant(.automobile))
    
}

#Preview("Destination Detail Tab") {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<MTPlacemark>()
    let placemarks = try! container.mainContext.fetch(fetchDescriptor)
    let placeMark = placemarks.first
    return LocationDetailView(selectedPlacemark: placeMark, showRoute: .constant(false),timeInterval: .constant(nil),transportType: .constant(.automobile))
    
}

extension String {
    func removeWhiteSpace() -> String{
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
