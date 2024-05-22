//
//  LocationDeniedView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 17/05/24.
//

import SwiftUI

struct LocationDeniedView: View {
    var body: some View {
        ContentUnavailableView {
            // 1
            Label("Location Permission", systemImage: "paperplane")
            
        } description: {
            Text("""
    1. Tap on Setting
    2. Tap on General
    3. Tap on Location Services
    4. And Allow the location permission.
""")
            .multilineTextAlignment(.leading)
        } actions: {
            // 2
            Button("Go To Setting") {
                // Go to setting
                
            }
            .font(.title3)
            .buttonStyle(.borderedProminent)
            
            
        }
    }
}

#Preview {
    LocationDeniedView()
}
