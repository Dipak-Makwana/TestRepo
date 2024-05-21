//
//  LaunchScreenView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 20/05/24.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.blue.opacity(0.3)
                .ignoresSafeArea()
            VStack {
                Image("launchScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 200)
                
            }
        }
        .statusBar(hidden: true)
    }
}

#Preview {
    LaunchScreenView()
}
