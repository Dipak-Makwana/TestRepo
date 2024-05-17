//
//  HomeDetailView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 28/04/24.
//

import SwiftUI

struct HomeDetailView: View {
    let user: User
    var body: some View {
        ZStack {
            Color.red.opacity(0.5).ignoresSafeArea()
            Text(user.name)
        }
    }
}

#Preview {
    HomeDetailView(user: User.mock)
}
