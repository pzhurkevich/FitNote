//
//  HistoryView.swift
//  FitNote
//
//  Created by Pavel on 29.06.23.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var vm: HistoryViewViewModel
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.darkColor.ignoresSafeArea()
                if vm.workoutsToDisplay.isEmpty {
                    VStack {
                        Spacer()
                        Text("Finish at least one workout, and it appears in the history")
                            .padding(20)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.title2)
                        Spacer()
                    }
                } else {
                    
                    List(vm.workoutsToDisplay) { workout in
                        
                        
                        VStack {
                            
                            HStack(spacing: 10) {
                                
                                Button {
                                    
                                    vm.collapseRow(id: workout.id)
                                    
                                } label: {
                                    
                                    HStack(spacing: 20) {
                                        
                                        Text(workout.nameWorkout)
                                            .lineLimit(2)
                                            .font(.title2)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        Text(workout.dateWorkout, style: .date)
                                            .foregroundColor(.greenColor)
                                            .minimumScaleFactor(0.2)
                                            .lineLimit(1)
                                    }
                                    
                                }
                                .padding(.leading, 20)
                                
                                Image(systemName: vm.expandedIDs.contains(workout.id) ? "chevron.down" : "chevron.right" )
                                    .padding()
                                
                                
                            }
                            
                            if  vm.expandedIDs.contains(workout.id) {
                                Divider()
                                    .frame(minHeight: 2)
                                    .background(Color.greenColor)
                                
                                VStack {
                                    
                                    
                                    VStack(alignment: .leading, spacing: 0 )  {
                                        
                                        ForEach(workout.allExercises) { exercise in
                                            VStack() {
                                                HStack {
                                                    Text(exercise.name)
                                                        .foregroundColor(.white)
                                                        .padding(8)
                                                    
                                                    Spacer()
                                                }
                                                
                                                VStack {
                                                    HStack {
                                                        Text("Sets:")
                                                            .padding()
                                                        
                                                        VStack {
                                                            ForEach(exercise.sets) { eachSet in
                                                                
                                                                
                                                                VStack {
                                                                    Text("\(eachSet.rep) X \(eachSet.weight) kg")
                                                                }
                                                                
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                }.padding(.leading, 20)
                                                
                                            }
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
                                .padding(.horizontal, 10)
                            
                        )
                        .listRowSeparator(.hidden)
                    }
                    .padding(5)
                    .listStyle(.plain)
                    .blendMode(vm.workoutsToDisplay.isEmpty ? .destinationOver: .normal)
                    .foregroundColor(.greenColor)
                    .background(Color.darkColor)
                    .scrollContentBackground(.hidden)
                    
                    
                    
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Workouts History")
                        .font(.title)
                        .foregroundColor(.greenColor)
                }
            }
            .toolbarBackground(Color.darkColor)
        }
        .task {
            await vm.getWorkouts()
        }
        
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(vm: HistoryViewViewModel(clientData: Client()))
    }
}
