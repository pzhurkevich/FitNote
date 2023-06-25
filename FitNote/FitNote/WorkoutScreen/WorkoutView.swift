//
//  WorkoutView.swift
//  FitNote
//
//  Created by Pavel on 11.06.23.
//

import SwiftUI

struct WorkoutView: View {
    
    
   
    @StateObject var vm = WorkoutViewViewModel()
    
    
    
    @State var textFieldIsDisabled = false
    
    var body: some View {
        ZStack {
            Color.darkColor.ignoresSafeArea()
            VStack {
                
                Text("Today is \(vm.currentDate)")
                    .foregroundColor(.white)
                //exercises
                if vm.workout1.isEmpty {
                    Spacer()
                    Text("Please add new exercise")
                        .foregroundColor(.white)
                        .font(.title2)
                } else {
                    //else starts
               //     Spacer()
                    
                    VStack {
                        List($vm.workout1) { $exercise in
                            
                            VStack {
                                
                                HStack() {
                                    
                                    Text("\((vm.workout1.firstIndex(of: exercise) ?? 0) + 1).")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.trailing, 10)
                                    
                                   
                                    
                                    Text(exercise.name)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .minimumScaleFactor(0.8)
                                        .lineLimit(1)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(5)

                                
                    
                                Divider()
                                    .background(Color.greenColor)
                                    .padding([.bottom, .top], 10)
                        
                                

                                
                                
                                VStack {
                                   
                                    ForEach($exercise.sets) { $item in
                                        
   
                                  
                                        
                                        HStack {
                                            Text("Set \(exercise.sets.firstIndex(of: item)! + 1):")
                                                .foregroundColor(.white)
                                                .padding(5)
                                            
                                            TextField("rep", text: $item.rep)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                                .padding(5)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 24)
                                                        .stroke(Color.white, lineWidth: 1)
                                                }
                                            
                                            TextField("ves", text: $item.ves)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                                .padding(5)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 24)
                                                        .stroke(Color.white, lineWidth: 1)
                                                }
                                                .padding(5)
                                        }
                                    }
                                }
                                
                                if !exercise.sets.isEmpty {
                                    Divider()
                                        .background(Color.greenColor)
                                        .padding([.bottom, .top], 10)
                                }
                                
                                HStack {
                                    Text("New set:")
                                        .foregroundColor(.greenColor)
                                        .padding(5)
                                    
                                    VStack {
                                        TextField("New rep", text: $exercise.newItem, onCommit: {
                                            
                                            vm.addSet(exercise: &exercise)
                                            
                                        }).multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                        
                                        
                                            Divider()
                                                .background(Color.greenColor)
                                        
                                               
                                    }
                                    
                                    VStack {
                                        TextField("New ves", text: $exercise.newItem2, onCommit: {

                                            vm.addSet(exercise: &exercise)
                                            
                                        }).multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                        Divider()
                                            .background(Color.greenColor)
                                           
                                    }
                                    
                                }.padding(.bottom, 8)
                                
                            } .padding(5)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.secondaryDark)
                                        .padding([.top, .bottom], 10)
                                        .listRowSeparator(.hidden)
                                )
                            
                        }
                        .background(Color.darkColor)
                        .scrollContentBackground(.hidden)
                        
//                        Button("Add Exercise") {
//                            vm.workout1.append(OneExersice(name: "\(vm.oneExerciseForWorkout?.name ?? "error")", sets: []))
//                           // print(vm.workout)
//                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    //end else
                }
                
                
                Spacer()
                
                
                Button {
                    vm.isPresented.toggle()
           
//                    vm.workout1.append(OneExersice(name: "\(vm.oneExerciseForWorkout?.name ?? "error")", sets: []))
                    
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
                    .padding()
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
            .sheet(isPresented: $vm.isPresented) {
                ExercisesView(vm: vm.exerciseListVM)
            }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
