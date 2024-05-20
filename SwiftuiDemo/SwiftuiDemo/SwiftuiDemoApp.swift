//
//  SwiftuiDemoApp.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 23/04/24.
//

import SwiftUI

@main
struct SwiftuiDemoApp: App {
    @State private var locationManager = LocationManager()
    // to get update the status of Network Changes
    @State private var networkMonitor = NetworkMonitor()
    // Get error in whole  application
    @State private var appError: DemoError?
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.showError) { error, instruction  in
//                    appError = DemoError(error,instruction,isNeedToDisplay: true)
//                }
//                .modifier(ErrorAlert(error: $appError, displayType: .alert))
//                .environment(networkMonitor)
            
            if locationManager.isAuthorized {
                MyMapView()
                    
            }
            else {
                LocationDeniedView()
            }
        }
        .modelContainer(for: Destination.self)
        .environmentObject(locationManager)
        
    }
}
    
/*
 // let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
 
 //    var body: some View {
 //        HStack {
 //            ForEach(0..<2) {_ in
 //                VStack (alignment: .center) {
 //                    animationView(.white)
 //                    animationView(.red)
 //                    animationView(.white)
 //                }
 //            }
 //
 ////            .onReceive(timer) { input in
 ////                changeAngle += 5
 ////            }
 //        }
 //    }
 
 private func animationView(_ color: Color) -> some View {
 ZStack {
 Rectangle()
 .fill(color)
 .frame(width: 200)
 .frame(height: 200)
 .rotationEffect(Angle(degrees: changeAngle))
 .scaleEffect(x: scale)
 
 Text("Loading.....")
 .foregroundStyle(.cyan)
 }
 
 private func configure() -> some View  {
 TabView {
 NavigationStack(path: $coordinator.path) {
 coordinator.build(.home)
 .navigationDestination(for: Screen.self) { screen in
 coordinator.build(screen)
 
 }
 .sheet(item: $coordinator.sheet) { sheet in
 coordinator.build(sheet)
 }
 .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreeenCover in
 coordinator.build(fullScreeenCover)
 }
 }
 }
 }
 
 Button("• Home 🏠") {
 
 }
 Button("• Search 🔎") {
 coordinator.push(.search)
 }
 Button("• Cart 🛒") {
 
 }
 Button("• Profile 💂🏻‍♂️") {
 coordinator.presentFullScreen(.profile)
 }
 Button("• Setting ⚙️") {
 coordinator.present(.setting)
 }
 Spacer()
 }
 */
