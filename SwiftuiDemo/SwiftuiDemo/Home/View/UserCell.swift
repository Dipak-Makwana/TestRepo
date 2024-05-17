//
//  UserCell.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 28/04/24.
//

import SwiftUI

struct UserCell: View {
    let user: User
    var coordinator: Coordinator
    
    var body: some View {
        HStack (spacing: 8) {
            
            Circle().fill(.red.opacity(0.7))
                .frame(width: 30,height: 30)
                .padding(.horizontal,8)
            
            VStack(alignment: .leading,spacing: 8) {
                Text(user.name)
                    .font(.title3)
                    .foregroundStyle(.primary)
                Text(user.username)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding([.horizontal,.vertical],8)
            
        }
        .listRowSeparator(.hidden)
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .orange.opacity(0.3), radius: 10,y: 5)
        .onTapGesture {
            withAnimation {
                coordinator.push(.homeDetail(user))
            }
        }
        
    }
}

struct ImageCell: View {
    let image: ImageModel
    
    var body: some View {
        HStack (spacing: 8) {
            let url = URL(string: image.url)
            AsyncImage(
                url: url,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .padding()
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
            VStack {
            Text(image.title)
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity,alignment: .leading)
            Text(image.albumID.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity,alignment: .leading)
        }
        .padding([.horizontal,.vertical],4)
    }
    .frame(maxWidth: .infinity,alignment: .leading)
    .background(.white)
    .cornerRadius(10)
    .shadow(color: .blue, radius: 10,y:5)
       
}
}

#Preview {
    ImageCell(image: ImageModel.mock)
}
