//
//  CustomPopoverView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 07/06/24.
//

import SwiftUI

class  PopoverViewModel {
    @Published var array: [String] = [
    "Very Good 😀",
    "Good 😄",
    "Average 😁",
    "Bad 😭"
    ]
}

struct CustomPopoverView: View {
    
    @State private var isPopupOver: Bool = false
    private var viewModel = PopoverViewModel()
    var body: some View {
        VStack {
            Button("Click Me") {
                isPopupOver.toggle()
            }
            .buttonStyle(.borderedProminent)
            .popover(isPresented: $isPopupOver,attachmentAnchor: .point(.top), content: {
                ForEach(viewModel.array, id: \.self) { item in
                    Button {
                    }label: {
                        Text(item)
                        .padding(8)
                    }
                    .tint(.black)
                }
                .presentationCompactAdaptation(.popover)
            })
        }
        .padding()
    }
}

#Preview {
    CustomPopoverView()
}
