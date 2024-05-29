//
//  DirectionStepsView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 28/05/24.
//

import SwiftUI
import MapKit

struct DirectionStepsView: View {
    
    @Binding var route: MKRoute?
    @Binding var transportType: MKDirectionsTransportType
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Image(systemName: img.mappin_circle_fill)
                        .imageScale(.large)
                        .foregroundStyle(.red)
                    Text(str.fromMyLocation)
                    Spacer()
                }
                VStack(alignment: .leading) {
                    if let route {
                        ForEach(1..<route.steps.count,id: \.self) { index in
                            
                            let prefix = transportType == .automobile ? str.drive : str.walk
                            let distance = route.steps[index].distance
                            let instructions = route.steps[index].instructions
                            Text("\(prefix) \(MapManager.distance(meters: distance))")
                                .bold()
                            Text(" - \(instructions)")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(str.steps)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DirectionStepsView(route: .constant(nil), transportType: .constant(.automobile))
}
