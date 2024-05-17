//
//  ErrorView.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 29/04/24.
//

import SwiftUI



struct ErrorView: View {
    let demoError: DemoError
    var body: some View {
        VStack {
            Text(demoError.error?.localizedDescription ?? strError)
                .font(.title2)
                .foregroundStyle(.red)
                .bold()
            if let instruction = demoError.instruction {
                Text(instruction)
                    .font(.title2)
                    .foregroundStyle(.green)
                    .bold()
            }
        }.padding()
    }
}

#Preview {
    ErrorView(demoError: DemoError(ErrorType.networkError, strPleaseTryAgain))
}

struct ErrorAlert: ViewModifier {
    
    @Binding var error: DemoError?
    let alertButton: AlertButton = .ok
    let displayType: DisplayType
    
   // let title: String = "Error"
    
    enum AlertButton {
        case ok
        case okCancel
        case cancel
    }
    
    enum DisplayType {
        case alert
        case sheet
        case fullCover
    }
  
    var isPresented: Binding<Bool>{
        
       // let err = self.error
        return Binding(get: {
               guard let error = self.error else { return false }
                return (error.isNeedToDisplay)
           }, set: {_ in
               // because of the two-way connection you need to make sure $0 matches the type of the original Stat or it will fail.
               //Here is a very crude way to make it adapt
               //statValue = $0 as? Stat ?? Double($0) as? Stat ?? Int($0) as? Stat ?? statValue //If all else fails just return the original
           })
       }
    
    func body(content: Content) -> some View {
        
        switch displayType {
        case .alert:
            switch alertButton {
            case .ok:
                content
                    .alert(strError, isPresented: isPresented) {
                        Button(strOk, role: .cancel) {}
                    } message: {
                        Text(error?.instruction ?? "")
                    }
            case .okCancel:
                content
                    .alert(strError, isPresented: isPresented) {
                        Button(strOk) { }
                        Button(strCancel, role: .cancel) {}
                    } message: {
                        Text(error?.instruction ?? "")
                    }
            case .cancel:
                content
                    .alert(strError, isPresented: isPresented) {
                        Button(strCancel, role: .cancel) {}
                    } message: {
                        Text(error?.instruction ?? "")
                    }
            }
        case .fullCover:
            content
            .fullScreenCover(item: $error) { error in
                ErrorView(demoError: error)
            }
        case .sheet:
            content
            .sheet(item: $error) { error in
                ErrorView(demoError: error)
            }
        }
    }
}
