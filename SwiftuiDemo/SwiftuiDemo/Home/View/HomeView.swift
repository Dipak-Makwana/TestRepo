//
//  HomeView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 25/04/24.
//

import SwiftUI

struct ShowErrorEnviornmentKey: EnvironmentKey {
    
    static var defaultValue: (Error,String) -> Void = { _,_ in
    }
    //    static var defaultValue: (Error,String) -> Void = { _,_ in
    //    }
}
extension EnvironmentValues {
    var showError: (Error,String) -> Void {
        get { self[ShowErrorEnviornmentKey.self] }
        set { self[ShowErrorEnviornmentKey.self] = newValue }
    }
}

struct HomeView: View {
    @Environment(NetworkMonitor.self) private var newtworkMonitor
    @StateObject var  coordinator =  Coordinator()
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.showError) private var showError
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                userList
            }
            .modifier(NavigationModifier(coordinator: coordinator))
        }
        .task {
            do {
                if newtworkMonitor.isConnected {
                   try viewModel.fetchUsers()
                    //try viewModel.fetchPhotos()
                }
                else {
                    let error = ErrorType.networkError
                    showError(error,error.errorDescription ?? "")
                }
                
                
            }
            catch (let error) {
                showError(error,error.localizedDescription)
            }
        }
        .onAppear {
            if viewModel.users.isEmpty {
                if let error = viewModel.appError?.error {
                    showError(error,error.localizedDescription)
                }
            }
            
        }
    }
    
    private var userSection1: some View {
        Section("Users 1", content: {
            ForEach(viewModel.users) { user in
                UserCell(user: user, coordinator: coordinator)
                    .listRowBackground(Color.clear)
            }
        }).background(.red)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    private var userSection: some View {
        Section(content: {
            ForEach(viewModel.users) { user in
                UserCell(user: user, coordinator: coordinator)
            }
            .listRowBackground(Color.clear)
        }, header: {
            Text("Users Start")
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding()
                .background(.primary)
        }, footer: {
            Text("Users End")
        })
    }
    private var imageSection: some View {
        Section("Users 2", content: {
            ForEach(viewModel.first20Images) { image in
                ImageCell(image: image)
            }
        })
    }
    private var gridSection: some View {
        Section("Grid ", content: {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images) { image in
                        ImageCell(image: image)
                    }
                }
            }
        })
        .scrollContentBackground(.hidden)
        .background(Color.blue)
    }
    private var userList: some View {
        
        List {
            userSection
            // imageSection
            //gridSection
        }
        //.background(.pink)
        //.scrollContentBackground(.hidden)
        .listRowBackground(Color.red)
    }
}

#Preview {
    HomeView()
}

struct NavigationModifier: ViewModifier {
    var coordinator: Coordinator
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Screen.self) { screen in
                coordinator.build(screen)
            }
    }
}
