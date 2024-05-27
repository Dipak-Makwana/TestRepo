//
//  DestinationListView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 21/05/24.
//

import SwiftUI
import SwiftData


struct DestinationListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Destination.name) private var destinations: [Destination]
    @State private var newDestination: Bool = false
    @State private var locationName: String = ""
    @State private var path = NavigationPath()
    var body: some View {
        
        NavigationStack(path: $path) {
            Group {
                if destinations.isEmpty {
                    contentUnAvailableView
                }
                else {
                    locationListView
                }
            }
            .navigationDestination(for: Destination.self, destination: { destination in
                DestinationView(selectedDestination: destination)
            })
            .navigationTitle("My Destinations")
            .toolbar {
                toolBarAddButton
            }
            .alert("Enter Destination Name", isPresented: $newDestination, actions: {
                alertTextField
                alertOKButton
                alertCancelButton
            }, message: {
                Text("Create a new destination")
            })
        }
    }
    private var locationListView: some View {
        List(destinations) { destination in
            NavigationLink(value: destination) {
                LocationCell(destination: destination)
            }
        }
    }
    private var toolBarAddButton: some View {
        Button(action: {
            newDestination.toggle()
        }, label: {
            Image(systemName: "plus.circle.fill")
        })

    }
    private var alertTextField: some View {
        TextField("Enter destination name", text: $locationName)
            .autocorrectionDisabled()
    }
    private var alertOKButton: some View {
        Button("OK") {
            if !locationName.isEmpty {
                let destination = Destination(name: locationName.trimmingCharacters(in: .whitespacesAndNewlines))
                modelContext.insert(destination)
                locationName = ""
                path.append(destination)
            }
        }
    }
    private var alertCancelButton: some View {
        Button("Cancel",role: .cancel) {}   
    }
    private var contentUnAvailableView : some View {
        MyContentUnAvailableView(
            title: "No Destinations",
            image: "globe.desk",
            description: """
                                                   1. You have not set any destinations yet. Tap on the \(Image(
                                                   systemName: "plus.circle.fill"
                                                   )) button in the toolbar to begin.
                                                   """
        )
    }
}

#Preview {
    DestinationListView()
        .modelContainer(Destination.preview)
}

