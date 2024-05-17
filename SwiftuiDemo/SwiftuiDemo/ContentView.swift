//
//  ContentView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 23/04/24.
//

import SwiftUI

#Preview {
    ContentView()
}

struct ContentView: View {
    @State private var selection: TabItem = .home
    var body: some View {
        AppTabView(selection: $selection)
    }
}

//////////////////////////////////////////////////////x//////////////////////////////////////////////////////////////////
struct SearchView: View {
    @EnvironmentObject var  coordinator: Coordinator
    
    var body: some View {
        VStack {
            Color.pink.ignoresSafeArea()
            Text("SearchView")
                .titleFont()
            
            Button("Pop") {
                coordinator.pop()
            }
        }
    }
}

struct CartView: View {
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            Text("CartView")
                .titleFont()
        }
    }
}

struct MapView: View {
    var body: some View {
        ZStack {
            Color.cyan.ignoresSafeArea()
            Text("MapView")
                .titleFont()
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var  coordinator: Coordinator
    
    var body: some View {
        VStack {
            Color.purple.ignoresSafeArea()
            Text("ProfileView")
                .titleFont()
            
            Button("Dismiss") {
                coordinator.dismissFullScreen()
            }
        }
    }
}

struct SettingView: View {
    var body: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
            Text("SettingView")
                .titleFont()
        }
    }
}

extension Text {
    func titleFont() -> some View {
       // if #available(iOS 16.1, *) {
            self
                .font(.largeTitle)
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .fontWidth(.condensed)
//        } else {
//            // Fallback on earlier versions
//            self
//                .font(.largeTitle)
//        }
    }
}

