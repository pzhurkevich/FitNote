//
//  WorkoutView.swift
//  FitNote
//
//  Created by Pavel on 11.06.23.
//

import SwiftUI

struct WorkoutView: View {
    
    
    @ObservedObject var vm: WorkoutViewViewModel
    @FocusState private var textIsFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
        ZStack {
            Color.darkColor.ignoresSafeArea()
            VStack {
                
                Text("Today is: \(vm.currentDate.stringEnDate())")
                    .foregroundColor(.white)
                    .padding(5)
                
                HStack {
                    
                    if vm.workoutNameEdit {
                        TextField("new workout", text: $vm.workoutName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($textIsFocused)
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
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.trailing, 10)
                                    
                                    
                                    
                                    Text(exercise.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .minimumScaleFactor(0.8)
                                        .lineLimit(1)
                                        .foregroundColor(.white)
                                    Spacer()
                                    
                                    if vm.editMode {
                                        Button(role: .destructive) {
                                            vm.deleteExerciseInWorkout(exercise1: exercise)
                                        } label: {
                                            Image(systemName: "trash")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.red)
                                            
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(5)
                                
                                
                                
                                Divider()
                                    .background(Color.greenColor)
                                    .padding(.bottom, 5)
                                
                                
                                
                                
                                
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
                                                    .padding(2)
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 24)
                                                            .stroke(Color.white, lineWidth: 1)
                                                        
                                                    }
                                                    .disabled(vm.textDisabled)
                                                Text("r")
                                                    .foregroundColor(.greenColor)
                                            }
                                            
                                            HStack {
                                                TextField("weight", text: $item.weight)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(.white)
                                                    .padding(2)
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 24)
                                                            .stroke(Color.white, lineWidth: 1)
                                                    }
                                                    .disabled(vm.textDisabled)
                                                Text("kg")
                                                    .foregroundColor(.greenColor)
                                            }.padding(2)
                                        }
                                    }
                                }
                                
                                if !exercise.sets.isEmpty {
                                    Divider()
                                        .background(Color.greenColor)
                                        .padding([.top, .bottom], 2)
                                }
                                if !vm.endedExercises.contains(exercise) {
                                    HStack(alignment: .firstTextBaseline) {
                                        Text("New set:")
                                            .foregroundColor(.greenColor)
                                            .padding(3)
                                        
                                        VStack(spacing: 0) {
                                            TextField("New rep", text: $exercise.newItem)
                                                .focused($textIsFocused)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white)
                                                .keyboardType(.decimalPad)
                                                .disableAutocorrection(true)
                                                .padding(.bottom, 2)
                                            
                                            Divider()
                                                .background(Color.greenColor)
                                            
                                            Text("reps")
                                                .foregroundColor(Color.greenColor)
                                            
                                            
                                        }
                                        
                                        VStack(spacing: 0) {
                                            TextField("New weight", text: $exercise.newItem2).multilineTextAlignment(.center)
                                                .focused($textIsFocused)
                                                .foregroundColor(.white)
                                                .keyboardType(.decimalPad)
                                                .disableAutocorrection(true)
                                                .padding(.bottom, 2)
                                            
                                            
                                            Divider()
                                                .background(Color.greenColor)
                                            
                                            Text("weigth")
                                                .foregroundColor(Color.greenColor)
                                        }
                                        Button {
                                            vm.addSet(exercise: exercise)
                                        } label: {
                                            Image(systemName: "plus")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.greenColor)
                                        }
                                        .padding(5)
                                        
                                    }.padding(.bottom, 3)
                                        .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(8)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.secondaryDark)
                                        .padding([.bottom, .top], 18)
                                        .padding(.horizontal, 5)
                                    
                                )
                                .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .background(Color.darkColor)
                        .scrollContentBackground(.hidden)
                        
                        
                        
                        
                    }
                    .padding(5)
                
                }
                
                
                HStack {
                    if !vm.workout.isEmpty {
                        Button {
                            vm.saveWorkout()
                            if Constants.currentState == .loggedAsTrainer {
                                dismiss()
                            }
                        } label: {
                            
                            Text("End Workout")
                                .foregroundColor(.black)
                                .fontDesign(.rounded)
                                .fontWeight(.bold)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                   
                    
                    Button {
                        vm.isPresented.toggle()
                    } label: {
                        
                        Text("Add Exercise")
                            .foregroundColor(.black)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(Color.greenColor)
                            .clipShape(Capsule())
                    }
                    
                }
                .padding([.bottom, .trailing, .leading], 10)
                
            }
     
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(vm.workoutName)
                    .font(.title2)
                    .foregroundColor(.greenColor)
            }
            
            if !vm.workout.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.editMode.toggle()
                        
                    } label: {
                        Text(vm.editMode ? "Done" : "Edit")
                            .font(.title3)
                        
                            .foregroundColor(.red)
                    }
                }
            }
            
            if Constants.currentState == .loggedAsTrainer {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .foregroundColor(.greenColor)
                    }
                }
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
                .onTapGesture {
                    textIsFocused = false
            }
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
