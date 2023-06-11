//
//  WorkoutView.swift
//  FitNote
//
//  Created by Pavel on 11.06.23.
//

import SwiftUI

struct WorkoutView: View {
    var body: some View {
        ZStack {
            Color.darkColor.ignoresSafeArea()
            VStack {
                
                Text("Today is \(Date().formatted(date: .complete, time: .omitted))")
                    .foregroundColor(.white)
                
                Spacer()
                
                
                Button {
                    //action
                } label: {
                    HStack {
                        Text("New Exercise")
                            .font(.system(size: 20))
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                        
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                    }
                    .tint(.black)
                   // .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Color.greenColor)
                    .clipShape(Capsule())
                }.padding(.bottom, 20)
                
                
            }
        }.navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Current Workout")
                        .font(.largeTitle)
                        .foregroundColor(.greenColor)
                }
            }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
