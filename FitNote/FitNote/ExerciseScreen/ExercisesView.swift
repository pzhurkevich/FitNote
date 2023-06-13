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
        
        
        List(vm.searchResults, id: \.id) { exercise in
            
            
            VStack {
                
                HStack(spacing: 10) {
                    
                    Button {
                        
                        vm.tapped.toggle()
                        vm.tappedID = exercise.id
                        
                        
                    } label: {
                        
                        HStack(spacing: 20) {
                            AsyncImage(url: vm.imageURL(source: exercise)) { image in
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
                                
                                Text(exercise.primaryMuscles.first?.rawValue ?? "-")
                                    .foregroundColor(.greenColor)
                                
                            }
                        }
                        
                    }
                    .padding(.leading, 20)
                    
                    
                    Spacer()
                    
                    Button {
                        print("dobavil")
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .foregroundColor(.greenColor)
                    }
                    
                    
                }
                .buttonStyle(PlainButtonStyle())
                // доп инструкции
                if vm.tapped == true, vm.tappedID == exercise.id {
                    
                    VStack {
                        
                        Text("Instructions:")
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 0 )  {
                            
                            ForEach(exercise.instructions, id: \.self) { text in
                                Text(text)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
                
            }
            .padding(5)
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
        
        .task {
            await vm.fetchExercises()
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
    }
}
