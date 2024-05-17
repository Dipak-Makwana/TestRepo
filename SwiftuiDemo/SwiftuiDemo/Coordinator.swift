//
//  Coordinator.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 25/04/24.
//

import SwiftUI
import Foundation

protocol NavigationProtocol {
    func push()
    func pop()
    func popToRoot()
}

enum NavigationType {
    case push
    case present
    case fullScreenCover
    
}
struct DestinationModel {
    var name: Screen
    var type: NavigationType = .push
}

enum Screen: Identifiable,Hashable {
    case home
    case homeDetail(_ user: User)
    case search
    case cart
    case profile
    
    var id: String  {
        return UUID().uuidString
    }
}

enum Sheet: String,Identifiable {
    case setting
    var id: String {
        self.rawValue
    }
}

enum FullScreenCover: String,Identifiable {
    case profile
    var id : String {
        self.rawValue
    }
}

class Coordinator: ObservableObject  {
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet? = nil
    @Published var fullScreenCover: FullScreenCover?
    
    @ViewBuilder
    func build(_ screen: Screen) -> some View  {
        switch screen {
        case .home:
            TabView {
                HomeView()
                    .tabItem {
                        Text("Home")
                    }
            }
        case .search:
            SearchView()
        case .cart:
            CartView()
        case .profile:
            ProfileView()
        case .homeDetail (let user):
            HomeDetailView(user: user)
                .toolbar(.hidden, for: .tabBar)
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View  {
        switch sheet {
        case .setting:
            SettingView()
        }
    }
    
    @ViewBuilder
    func build(_ fullScreen: FullScreenCover) -> some View  {
        switch fullScreen {
        case .profile:
            ProfileView()
        }
    }
    
    func navigate(_ destination: DestinationModel) {
        
        switch destination.type {
        case .push:
            self.push(destination.name)
            
        default:
            debugPrint("")
        }
        
    }
    func present(_ sheet: Sheet) {
        self.sheet = sheet
    }
    func dismiss() {
        self.sheet = nil
    }
    func dismissFullScreen() {
        self.fullScreenCover = nil
    }
    func presentFullScreen(_ fullScreen: FullScreenCover) {
        self.fullScreenCover = fullScreen
    }
    func push(_ screen: Screen) {
        path.append(screen)
    }
    func pop() {
        path.removeLast()
    }
    func popToRoot() {
        path.removeLast(path.count)
    }
}
