//
//  LocationDetailView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 22/05/24.
//

import SwiftUI
import SwiftData


struct LocationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var destination: Destination?
    var selectedPlacemark: MTPlacemark?
    @State private var name: String = ""
    @State private var address: String = ""
    
    var isChanged: Bool {
        return true
//        guard let selectedPlacemark else { return false }
//        return (name != selectedPlacemark.name || address != selectedPlacemark.address)
    }
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    TextField("Name", text: $name)
                        .font(.title2)
                    TextField("Address", text: $address)
                        .font(.caption)
                }
                .textFieldStyle(.roundedBorder)
                if isChanged {
                    Button("Update") {
                        selectedPlacemark?.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        selectedPlacemark?.address = address.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .buttonStyle(.borderedProminent)
                }
                Spacer()
                Button {
                    dismiss()
                }label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
        }
        .padding()
            .onAppear {
                if let placemark = selectedPlacemark, destination != nil {
                    name = placemark.name
                    address = placemark.address
                }
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
