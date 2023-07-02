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
        
        

            
            List(vm.workoutsToDisplay) { workout in
                
                
                VStack {
                    
                    HStack(spacing: 10) {
                        
                        Button {
                            
                            
                          // vm.tappedID = workout.id
                            vm.collapseRow(id: workout.id)
                            
                        } label: {
                            
                            HStack(spacing: 20) {
                                
                                Text(workout.nameWorkout)
                                    .minimumScaleFactor(0.2)
                                    .lineLimit(1)
                                    .font(.title)
                                    .foregroundColor(.white)
                                
                                Text(workout.dateWorkout, style: .date)
                                    .foregroundColor(.greenColor)
                                    .minimumScaleFactor(0.2)
                                    .lineLimit(1)
                            }
                            
                        }
                        .padding(.leading, 20)
                        
                         Spacer()
                        
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
                        .listRowSeparator(.hidden)
                )
                
            }
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Workouts History")
                        .font(.title)
                        .foregroundColor(.greenColor)
                }
            }
            .blendMode(vm.workoutsToDisplay.isEmpty ? .destinationOver: .normal)
            .toolbarBackground(Color.darkColor)
            .foregroundColor(.greenColor)
            .background(Color.darkColor)
            .scrollContentBackground(.hidden)
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
