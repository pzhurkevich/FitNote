//
//  ExercisesView.swift
//  FitNote
//
//  Created by Pavel on 12.06.23.
//

import SwiftUI

struct ExercisesView: View {
    
    @StateObject var vm = ExercisesViewViewModel()
    
    
    var body: some View {
        
        NavigationView {
            List(vm.searchResults, id: \.id) { exercise in
                
//                NavigationLink(destination: ExerciseDetailView(exercise: exercise), label: {
                    
                    HStack(spacing: 10) {
                        
                        AsyncImage(url: URL(string: "\(Constants.imgDB)\(exercise.images[0])")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 70)
                                .cornerRadius(5)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 70, alignment: .center)
                        }
                        
                        
                        VStack (alignment: .leading, spacing: 5) {
                            Text(exercise.name)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            
                            Text(exercise.primaryMuscles[0].rawValue)
                                .foregroundColor(.greenColor)
                            
                        }
                        .padding(.leading, 30)
                        
                    Spacer()
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 7)
                            .foregroundColor(.greenColor)
                        
                        
                    }
                    .background(
                        NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {}
                            .navigationBarTitleDisplayMode(.inline)
                            .opacity(0)
                    )
                    .padding(5)
                    
                    
                //})
                .listRowBackground(
                RoundedRectangle(cornerRadius: 20)
                    .background(.clear)
                    .foregroundColor(.secondaryDark)
                    .padding([.top, .bottom], 10)
                    .listRowSeparator(.hidden)
                )

            }
            .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always))
            //поиск всегда закреплен наверху
            .foregroundColor(.greenColor)
            //эта штука делает бэкграунд при загрузке не белым
            .blendMode(vm.exercises.isEmpty ? .destinationOver: .normal)
            .background(Color.darkColor)
            .scrollContentBackground(.hidden)
            .toolbarBackground(Color.darkColor) //цвет бэкграунда у навигации (где поиск)
          
            
            //.navigationTitle("Exercise Database")
            
            .onAppear {
                vm.fetchExercises()
            }
        } .accentColor(Color.greenColor) 
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
    }
}
