//
//  LocationCell.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 21/05/24.
//

import SwiftUI
import SwiftData

struct LocationCell: View {
    var destination: Destination
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        HStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text(destination.name)
                Text("^[\(destination.placemarks.count) location](inflect: true)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                modelContext.delete(destination)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor)[0]
    return NavigationStack {
        LocationCell(destination: destination)
    }
    
}
