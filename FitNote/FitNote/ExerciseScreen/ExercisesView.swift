//
//  ExercisesView.swift
//  FitNote
//
//  Created by Pavel on 12.06.23.
//

import SwiftUI

struct ExercisesView: View {
    
    @ObservedObject var vm: ExercisesViewViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.darkColor.ignoresSafeArea()
                
                VStack {
                    List(vm.searchResults, id: \.id) { exercise in
                        
                        
                        VStack {
                            
                            HStack(spacing: 10) {
                                
                                Button {
                                    
                                    
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
                                    vm.workoutExercise = exercise
                                    dismiss()
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
                            if vm.tappedID == exercise.id {
                                
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
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 20)
                                .background(.clear)
                                .foregroundColor(.secondaryDark)
                                .padding([.top, .bottom], 10)
                        )
                    }
                    .padding(5)
                    .background(Color.darkColor)
                .toolbarBackground(Color.darkColor)
                    
                    
                    VStack {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.greenColor)
                                .padding(.leading, 10)
                            
                            Spacer()
                            
                            Text("Filter Exercises by muscles")
                                .foregroundColor(.greenColor)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(.greenColor)
                                .padding(.trailing, 10)
                        }
                        ScrollView (.horizontal)  {
                            HStack(spacing: 10) {
                                ForEach(vm.exerciseCategories, id: \.id) { category in
                                    Button {
                                        vm.filterExercises(muscle: category)
                                    } label: {
                                        VStack {
                                            Image(category.img)
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                //.scaledToFit()
                                                .foregroundColor(.greenColor)
                                            
                                            Text(category.name)
                                                .foregroundColor(.white)
                                                
                                        }
                                        .padding(20)
                                        .background(Color.secondaryDark)
                                        .cornerRadius(30)
                                        //.frame(width: 120, height: 120)
                                    }

                                       
                                    }
                                }
                            .frame(height: 120)
                        }
                        .scrollIndicators(.hidden)
                        .padding(5)
                    }
                       
                }
            }
            .navigationTitle("\(vm.currentMuscles) muscles")
            .navigationBarTitleDisplayMode(.inline)
        }

        .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .accentColor(.greenColor)
        //поиск всегда закреплен наверху
        .foregroundColor(.greenColor)
        //эта штука делает бэкграунд при загрузке не белым
        .blendMode(vm.exercises.isEmpty ? .destinationOver: .normal)
        .background(Color.darkColor)
        .scrollContentBackground(.hidden)
        
        .task {
            await vm.fetchExercises()
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView(vm: ExercisesViewViewModel())
    }
}
