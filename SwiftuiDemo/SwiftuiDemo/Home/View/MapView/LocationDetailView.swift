//
//  LocationDetailView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 22/05/24.
//

import SwiftUI
import SwiftData
import MapKit


struct LocationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var destination: Destination?
    var selectedPlacemark: MTPlacemark?
    @State private var name: String = ""
    @State private var address: String = ""
    
    @State private var lookArroundScene: MKLookAroundScene?
    var isChanged: Bool {
        //return true
        guard let selectedPlacemark else { return false }
            return (name != selectedPlacemark.name || address != selectedPlacemark.address)
    }
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    TextField("Name", text: $name)
                        .font(.title2)
                    TextField("Address", text: $address,axis: .vertical)
                        .font(.caption)
                }
                .textFieldStyle(.roundedBorder)
                if isChanged {
                    Spacer()
                    Button("Update") {
                        selectedPlacemark?.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        selectedPlacemark?.address = address.trimmingCharacters(in: .whitespacesAndNewlines)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .buttonStyle(.borderedProminent)
                }
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.gray)
                }
            }
            if let lookArroundScene {
                LookAroundPreview(initialScene: lookArroundScene)
                    .frame(height: 200)
                    .padding()
            }
            else {
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
            }
            HStack {
                Spacer()
                if let destination {
                    let inList = (selectedPlacemark != nil && selectedPlacemark?.destination != nil)
                    Button {
                        if let selectedPlacemark {
                            if selectedPlacemark.destination == nil {
                                destination.placemarks.append(selectedPlacemark)
                            }
                            else {
                                selectedPlacemark.destination = nil
                            }
                            dismiss()
                        }
                    } label: {
                        Label(inList ? "Remove" : "Add", systemImage: inList ? "minus.circle" : "plus.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(inList ? .red : .green)
                    .disabled(name.isEmpty || isChanged)
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

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor)[0]
    let placeMark = destination.placemarks.first
    return LocationDetailView(destination: destination, selectedPlacemark: placeMark)
    
}
