//
//  StatisticsView.swift
//  FitNote
//
//  Created by Pavel on 6.07.23.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        ZStack {
            
            Color.darkColor.ignoresSafeArea()
            Text("Will be added in the next versions of the app")
                .foregroundColor(.white)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
