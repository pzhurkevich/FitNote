//
//  NetworkErrorView.swift
//  FitNote
//
//  Created by Pavel on 5.07.23.
//

import SwiftUI

struct NetworkErrorView: View {
    @State private var showStart = false
    
    var body: some View {
        ZStack {
            
            Color.darkColor.ignoresSafeArea()
            VStack {
                Image(systemName: "wifi.slash")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.greenColor)
                    .padding(40)
                
                VStack {
                    Text("No internet connection")
                        .font(.title3)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                       
                    Text("This app needs an internet connection for all functions to work, please check it and try again.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                
                Button("Try again") {
                    showStart.toggle()
                }
                .foregroundColor(.greenColor)
            }
            .fullScreenCover(isPresented: $showStart) {
                StartView()
            }
        }
    }
}

struct NetworkErrorView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkErrorView()
    }
}
