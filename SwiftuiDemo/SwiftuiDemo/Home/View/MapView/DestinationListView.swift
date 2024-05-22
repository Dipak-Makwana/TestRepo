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
                    List(destinations) { destination in
                        NavigationLink(value: destination) {
                            LocationCell(destination: destination)
                        }
                        
                    }
                }
            }
            .navigationDestination(for: Destination.self, destination: { destination in
                DestinationView(selectedDestination: destination)
            })
            .navigationTitle("My Destinations")
            .toolbar {
                Button(action: {
                    newDestination.toggle()
                }, label: {
                    Image(systemName: "plus.circle.fill")
                })
            }
            .alert("Enter Destination Name", isPresented: $newDestination, actions: {
                TextField("Enter destination name", text: $locationName)
                    .autocorrectionDisabled()
                Button("OK") {
                    if !locationName.isEmpty {
                        let destination = Destination(name: locationName.trimmingCharacters(in: .whitespacesAndNewlines))
                        modelContext.insert(destination)
                        locationName = ""
                        path.append(destination)
                    }
                }
                Button("Cancel",role: .cancel) {}
            }, message: {
                Text("Create a new destination")
            })
        }
        
    }
    private var contentUnAvailableView : some View {
        ContentUnavailableView("No Destinations", systemImage: "globe.desk", description: Text("""
                                                   1. You have not set any destinations yet. Tap on the \(Image(systemName: "plus.circle.fill")) button in the toolbar to begin.
                                                   """))
        .multilineTextAlignment(.leading)
        .padding()
    }
}

#Preview {
    DestinationListView()
        .modelContainer(Destination.preview)
}

