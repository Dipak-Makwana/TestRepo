//
//  AppTabView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 26/04/24.
//

import SwiftUI

//enum TabItem: String,CaseIterable {
//    case home, search, map,cart,profile
//    
//    var image: String? {
//        switch self {
//        case .home: "house.and.flag.circle"
//        case .search: "house.and.flag.circle"
//        case .map: "house.and.flag.circle"
//        case .cart: "house.and.flag.circle"
//        case .profile: "house.and.flag.circle"
//        }
//    }
//    
//    var title: String? {
//        switch self {
//        case .home: "Home"
//        case .search: "Search"
//        case .map: "Map"
//        case .cart: "Cart"
//        case .profile: "Profile"
//        }
//    }
//}

struct TabItemView: View  {
    let tabItem: TabItem
    var body: some View {
        VStack {
            Image(systemName: tabItem.image ?? "")
            Text(tabItem.title ?? "")
        }
    }
}

enum TabItem: Hashable , Identifiable,CaseIterable  {
    case home
    case destination
    case map
    case cart
    case profile
    
    var id: TabItem { self }
}
extension TabItem {
    
    var image: String? {
        switch self {
        case .home: "house.and.flag.circle"
        case .destination: "house.and.flag.circle"
        case .map: "house.and.flag.circle"
        case .cart: "house.and.flag.circle"
        case .profile: "house.and.flag.circle"
        }
    }
    
    var title: String? {
        switch self {
        case .home: "Home"
        case .destination: "Search"
        case .map: "Map"
        case .cart: "Cart"
        case .profile: "Profile"
        }
    }
    
    var tag: Int {
        switch self {
        case .home: return 0
        case .destination: return  1
        case .map: return 2
        case .cart: return 3
        case .profile:return 4
        }
    }
    @ViewBuilder
    var label: some View {
        switch self {
        case .home:
            TabItemView(tabItem: .home)
        case .destination:
            TabItemView(tabItem: .destination)
        case .map:
            TabItemView(tabItem: .map)
        case .cart:
            TabItemView(tabItem: .cart)
        case .profile:
            TabItemView(tabItem: .profile)
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            HomeView()
        case .destination:
            DestinationView()
        case .map:
            MapView()
        case .cart:
            CartView()
        case .profile:
            ProfileView()
        }
    }
}

struct AppTabView: View {
    
    @Binding var selection: TabItem
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(TabItem.allCases) { screen in
                screen.destination
                    .tag(screen.tag)
                    .tabItem { screen.label }
            }
            .toolbarBackground(.appBlue.opacity(0.8), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
       
    }
}

#Preview {
    AppTabView(selection: .constant(.home))
}
