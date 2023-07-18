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
                                    
                                    
                                   // vm.tappedID = exercise.id
                                    vm.collapseRow(id: exercise.id)
                                    
                                } label: {
                                    if   !vm.expandedIDs.contains(exercise.id) {
                                        HStack(spacing: 20) {
                                            AsyncImage(url: vm.imageURL(source: exercise)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 110, height: 80)
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
                                                Text("Primary muscles:")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 12))
                                                Text(exercise.primaryMuscles.first?.rawValue ?? "-")
                                                    .foregroundColor(.greenColor)
                                                
                                            }
                                        }
                                    } else {
                                        HStack {
                                            Spacer()
                                            Text(exercise.name)
                                                .font(.title3)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                
                                          Spacer()
                                        }
                                        .padding(10)
                                    }
                                }
                                .padding(.leading, 5)
                                
                                
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
                           // if vm.tappedID == exercise.id {
                             if   vm.expandedIDs.contains(exercise.id) {
                                VStack {
                                    HStack {
                                       
                                            AsyncImage(url: vm.imageURL(source: exercise)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 120, height: 80)
                                                    .cornerRadius(5)
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: 120, height: 80, alignment: .center)
                                            }
                                          
                                                AsyncImage(url: vm.secondImageURL(source: exercise)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 120, height: 80)
                                                        .cornerRadius(5)
                                                } placeholder: {
                                                    ProgressView()
                                                        .frame(width: 120, height: 80, alignment: .center)
                                                }
                                    }
                                    Text("Instructions:")
                                        .padding()
                                    
                                    VStack(alignment: .leading, spacing: 0 )  {
                                        
                                        ForEach(exercise.instructions, id: \.self) { text in
                                            Text(text)
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    
                                    VStack {
                                        
                                        Text("Involved muscles:")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12))
                                        
                                        HStack {
                                            
                                            ForEach(exercise.primaryMuscles, id: \.self) { text in
                                                Text(text.rawValue)
                                                    .foregroundColor(.greenColor)
                                                    .font(.system(size: 12))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.2)
                                            }
                                        }
                                        HStack {
                                            ForEach(exercise.secondaryMuscles, id: \.self) { text in
                                                Text(text.rawValue)
                                                    .foregroundColor(.greenColor)
                                                    .font(.system(size: 12))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.2)
                                            }
                                        }
                                    }
                                        .padding(5)
                                    
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
                    
                    
                    VStack (spacing: 0) {
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
                                        .padding(10)
                                        .background(Color.secondaryDark)
                                        .cornerRadius(20)
                                        //.frame(width: 120, height: 120)
                                    }

                                       
                                    }
                                }
                            .frame(height: 100)
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
