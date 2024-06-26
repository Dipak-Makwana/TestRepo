//
//  ScrollViewDemo.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 12/06/24.
//

import SwiftUI

//if #available(iOS 17.0 , *)
//if #available(iOS 17.0, *)
    
    struct ScrollViewDemo: View {
        @State private var scrollPosition: Int? = nil
        
        var body: some View {
            VStack {
                Button("Scroll To") {
                    scrollPosition = (1..<20).randomElement()
                }
                .padding()
                .buttonStyle(.borderedProminent)
                ScrollView(.horizontal) {
                    HStack (spacing: 30) {
                        ForEach(1..<20) { index in
                                Rectangle()
                                .fill(.orange)
                                .frame(width: 250,height: 250)
                                .cornerRadius(10)
                                .overlay {
                                    Text("\(index)")
                                        .foregroundStyle(.white)
                                        .bold()
                                }
                                .frame(maxWidth: .infinity)
                                .shadow(color: .black, radius: 15,  y: 25)
                                .scrollClipDisabled()
                                .padding()
                                .id(index)
                                .scrollTransition( .interactive) { content, phase in
                                        content
                                      //  .opacity(phase.isIdentity ? 1 : 0)
                                        .scaleEffect(1 - abs(phase.value
                                                            ))
                                        .rotation3DEffect(.degrees(phase.value * 90),axis: (x: 0, y: 1, z: 0))
                                        //.offset(y: phase.isIdentity ? 0 : -250)
                                }
                                .containerRelativeFrame(.horizontal, alignment: .center)
                        }
                    }
                    .scrollTargetLayout()
                    .padding()
                    .background(.red)
                }
               // .padding()
                //.safeAreaPadding(32)
                .scrollPosition(id: $scrollPosition)
                .scrollTargetBehavior(.paging)
                .animation(.smooth, value: scrollPosition)
            }
        }
    }

#Preview {
    ScrollViewDemo()
}
