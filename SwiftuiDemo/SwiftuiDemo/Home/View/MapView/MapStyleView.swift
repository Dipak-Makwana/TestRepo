//
//  MapStyleView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 28/05/24.
//

import SwiftUI

struct MapStyleView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var mapConfig: MapStyleConfig
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                baseStyleView
                elevationView
                if mapConfig.baseStyle != .imagery {
                    imageryView
                }
                okButton
                Spacer()
            }
            .padding()
            .navigationTitle(str.mapStyle)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    private var baseStyleView: some View {
        LabeledContent(str.baseStyle) {
            Picker(str.baseStyle, selection: $mapConfig.baseStyle){
                ForEach(MapStyleConfig.BaseMapStyle.allCases ,id:\.self) { type in
                    Text(type.label)
                }
            }
        }
    }
    private var elevationView: some View {
        LabeledContent(str.elevation) {
            Picker(str.elevation, selection: $mapConfig.elevation){
                Text(str.flat)
                        .tag(MapStyleConfig.MapElevation.flat)
                Text(str.realistic)
                        .tag(MapStyleConfig.MapElevation.realistic)
            }
        }
    }
    private var imageryView: some View {
        VStack {
            LabeledContent(str.poi) {
                Picker(str.poi, selection: $mapConfig.poi){
                    Text(str.none)
                        .tag(MapStyleConfig.MapPOI.excludingAll)
                    Text(str.all)
                        .tag(MapStyleConfig.MapPOI.all)
                }
            }
            Toggle(str.showTraffic, isOn: $mapConfig.showTraffic)
                .tint(.accent)
        }
    }
    private var okButton: some View {
        Button(str.ok) {
            dismiss()
        }
        .frame(maxWidth: .infinity,alignment: .trailing)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    MapStyleView(mapConfig: .constant(MapStyleConfig.init()))
}
