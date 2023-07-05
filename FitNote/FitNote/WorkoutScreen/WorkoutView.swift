//
//  WorkoutView.swift
//  FitNote
//
//  Created by Pavel on 11.06.23.
//

import SwiftUI

struct WorkoutView: View {
    
    
    @ObservedObject var vm: WorkoutViewViewModel
    
    
    var body: some View {
        ZStack {
            Color.darkColor.ignoresSafeArea()
            VStack {
                
                Text("Today is: \(vm.currentDate.stringEnDate())")
                    .foregroundColor(.white)
                    .padding()
                
                HStack {
                    
                    if vm.workoutNameEdit {
                        TextField("new workout", text: $vm.workoutName).textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading, 20)
                            .padding(.trailing, 5)
                            .font(.system(size: 25))
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    } else {
                        Text(vm.workoutName)
                            .font(.system(size: 25))
                        
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    
                    
                    Button(action: {
                        
                        vm.checkWorkoutName()
                    }) {
                        Image(systemName: vm.workoutNameEdit ? "checkmark.circle" : "pencil.circle")
                            .font(.title2)
                            .foregroundColor(.greenColor)
                            .padding(.trailing, 10)
                    }
                }
                
                //exercises
                if vm.workout.isEmpty {
                    Spacer()
                    Text("Please add new exercise")
                        .foregroundColor(.white)
                        .font(.title2)
                    Spacer()
                } else {
                    //else starts
                    
                    VStack {
                        List($vm.workout) { $exercise in
                            
                            VStack {
                                
                                HStack() {
                                    
                                    Text(vm.exerciseNumberText(exercise: exercise))
                                        .font(.title2)
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
                                    .padding([.bottom, .top], 5)
                                
                                
                                
                                
                                
                                VStack {
                                    
                                    ForEach($exercise.sets) { $item in
                                        
                                        
                                        
                                        
                                        HStack {
                                            Text(vm.setNumberText(set: item, sets: exercise.sets))
                                                .foregroundColor(.white)
                                                .padding(5)
                                            
                                            HStack {
                                                TextField("rep", text: $item.rep)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(.white)
                                                    .padding(3)
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 24)
                                                            .stroke(Color.white, lineWidth: 1)
                                                        
                                                    }
                                                    .disabled(vm.endedExercises.contains(exercise))
                                                Text("r")
                                                    .foregroundColor(.greenColor)
                                            }
                                            
                                            HStack {
                                                TextField("weight", text: $item.weight)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(.white)
                                                    .padding(3)
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 24)
                                                            .stroke(Color.white, lineWidth: 1)
                                                    }
                                                    .disabled(vm.endedExercises.contains(exercise))
                                                Text("kg")
                                                    .foregroundColor(.greenColor)
                                            }.padding(3)
                                        }
                                    }
                                }
                                
                                if !exercise.sets.isEmpty {
                                    Divider()
                                        .background(Color.greenColor)
                                        .padding([.bottom, .top], 5)
                                }
                                if !vm.endedExercises.contains(exercise) {
                                    HStack(alignment: .firstTextBaseline) {
                                        Text("New set:")
                                            .foregroundColor(.greenColor)
                                            .padding(5)
                                        
                                        VStack(spacing: 0) {
                                            TextField("New rep", text: $exercise.newItem).multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                                .keyboardType(.decimalPad)
                                                .disableAutocorrection(true)
                                                .padding(.bottom, 3)
                                            
                                            Divider()
                                                .background(Color.greenColor)
                                            
                                            Text("reps")
                                                .foregroundColor(Color.greenColor)
                                            
                                            
                                        }
                                        
                                        VStack(spacing: 0) {
                                            TextField("New weight", text: $exercise.newItem2).multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                                .keyboardType(.decimalPad)
                                                .disableAutocorrection(true)
                                                .padding(.bottom, 3)
                                            
                                            
                                            Divider()
                                                .background(Color.greenColor)
                                            
                                            Text("weigth")
                                                .foregroundColor(Color.greenColor)
                                        }
                                        Button {
                                            vm.addSet(exercise: exercise)
                                        } label: {
                                            Image(systemName: "plus")
                                            
                                                .foregroundColor(.greenColor)
                                        }
                                        .padding(5)
                                        
                                    }.padding(.bottom, 8)
                                        .buttonStyle(PlainButtonStyle())
                                }
                            } .padding(5)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.secondaryDark)
                                        .padding([.top, .bottom], 10)
                                      
                                )
                                .listRowSeparator(.hidden)
                        }
                        .background(Color.darkColor)
                        .scrollContentBackground(.hidden)
                        
                        
                        
                        
                    }
                    
                    Button {
                        vm.saveWorkout()
                    } label: {
                        
                        Text("End Workout")
                            .foregroundColor(.black)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .padding(.horizontal, 60)
                            .padding(.vertical, 15)
                            .background(Color.greenColor)
                            .clipShape(Capsule())
                    }
                    //end else
                }
                
                
                
                
            }
        }.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(vm.workoutName)
                        .font(.title)
                        .foregroundColor(.greenColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.isPresented.toggle()
                        
                    } label: {
                        Image(systemName: "plus")
                        
                            .foregroundColor(.greenColor)
                    }
                }
            }
            .sheet(isPresented: $vm.isPresented) {
                ExercisesView(vm: vm.exerciseListVM)
            }
            .alert("", isPresented: $vm.warningAlert) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(vm.warningText)
            }
            .ignoresSafeArea(.keyboard)
            .hideKeyboardWhenTappedAround()
        
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(vm: WorkoutViewViewModel(clientData: Client()))
    }
}


extension Formatter {
    static let weekDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        return formatter
    }()
}
