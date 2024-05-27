//
//  MyContentUnAvailableView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 24/05/24.
//

import SwiftUI

struct MyContentUnAvailableView: View {
    
    let title: String
    let image: String?
    let description: String?
    
    init(title: String, image: String?, description: String? = nil) {
        self.title = title
        self.image = image
        self.description = description
    }
    
    var body: some View {
        ContentUnavailableView(title, systemImage: image ?? "", description: Text(description ?? ""))
        .multilineTextAlignment(.leading)
        .padding()
    }
}

#Preview {
    MyContentUnAvailableView(title: "No Item", image: "globe.desk")
}
