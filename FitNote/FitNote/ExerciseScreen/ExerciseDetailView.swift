//
//  ExerciseDetailView.swift
//  FitNote
//
//  Created by Pavel on 12.06.23.
//

import SwiftUI

struct ExerciseDetailView: View {
    
    var exercise: Exercise?
    
    var body: some View {
        
        ZStack {
            
            Color.darkColor.ignoresSafeArea()
            
            if let exercise = exercise {
                VStack {
                    
                    Text(exercise.name)
                        .fontWeight(.heavy)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                    
 
                    AsyncImage(url: URL(string: "\(Constants.imgDB)\(exercise.images[0])")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(5)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20))
                    } placeholder: {
                        ProgressView()
                    }
                    
                    VStack {
                        Text("Primary muscles: \(exercise.primaryMuscles[0].rawValue)")
                            .fontWeight(.semibold)
                            .foregroundColor(.greenColor)
                        
                        Text("Secondary muscles: \(exercise.secondaryMuscles.first?.rawValue ?? "-")")
                            .fontWeight(.semibold)
                            .foregroundColor(.greenColor)
                            .padding(.bottom, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 0 )  {
                        ForEach(exercise.instructions, id: \.self) { text in
                            Text(text)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Button("Add Exercise") {
                        print("Do nothing")
                    }
                    .padding()
                    
                }
                
            }
            
            
        }
    }
}

struct ExerciseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailView()
    }
}
