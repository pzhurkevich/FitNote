//
//  WorkoutView.swift
//  FitNote
//
//  Created by Pavel on 11.06.23.
//

import SwiftUI

struct WorkoutView: View {
    
    
    @State var isPresented = false
    @StateObject var vm = WorkoutViewViewModel()
    @State var repetitions = [""]
    @State var weights = [""]
    @State var currentDate = Date().formatted(date: .complete, time: .omitted)
    
    @State var textFieldIsDisabled = false
    
    var body: some View {
        ZStack {
            Color.darkColor.ignoresSafeArea()
            VStack {
                
                Text("Today is \(currentDate)")
                    .foregroundColor(.white)
                //exercises
                if vm.workout.isEmpty {
                    Spacer()
                    Text("Please add new exercise")
                        .foregroundColor(.white)
                } else {
                    Spacer()
                    
                    ScrollView {
                        ForEach(Array(vm.workout.enumerated()), id: \.element.id) { index, element in
                            
                            
                            VStack {
                                HStack(spacing: 0) {
                                    
                                    Text("\(index + 1).")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                    
                                 
                                        Text(element.name)
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(2)
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .padding()
                                        
                                        
                                        Button {
                                            
                                            textFieldIsDisabled.toggle()
                                            
                                        } label: {
                                            
                                            Text("End Exercise")
                                                .foregroundColor(.black)
                                                .fontDesign(.rounded)
                                                .fontWeight(.bold)
                                                .minimumScaleFactor(0.2)
                                                .lineLimit(1)
                                                .padding()
                                                .background(Color.greenColor)
                                                .clipShape(Capsule())
                                        }
                                        .padding()
                                    
                                }
                                
                                
                                Divider()
                                    .background(.white)
                                    .padding(.bottom, 10)
                                
                                // сеты
                                
                                VStack {
                                    
                                    HStack (spacing: 40) {
                                        
                                        
                                        VStack {
                                            ForEach(repetitions.indices, id: \.self) { index in
                                                
                                                
                                                
                                                HStack (alignment: .lastTextBaseline) {
                                                    
                                                    Text("Set \(index + 1)")
                                                        .foregroundColor(.greenColor)
                                                        .padding(5)
                                                    
                                                    VStack (alignment: .center) {
                                                        
                                                        
                                                        Text("Reps")
                                                            .foregroundColor(.white)
                                                        TextField("repetitions", text: $repetitions[index])
                                                            .disabled(textFieldIsDisabled)
                                                            .foregroundColor(Color.greenColor)
                                                            .padding(5)
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 24)
                                                                    .stroke(Color(uiColor: .white), lineWidth: 1)
                                                            }
                                                        
                                                        
                                                        
                                                    }
                                                    .padding(.leading, 10)
                                                }
                                            }
                                        }
                                        .padding(.leading, 20)
                                        
                                        
                                        
                                        
                                        VStack {
                                            ForEach(weights.indices, id: \.self) { index in
                                                
                                                
                                                VStack (alignment: .leading)  {
                                                    Text("Weight")
                                                        .foregroundColor(.white)
                                                    TextField("weight", text: $weights[index])
                                                        .disabled(textFieldIsDisabled)
                                                        .foregroundColor(Color.greenColor)
                                                        .padding(5)
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 24)
                                                                .stroke(Color(uiColor: .white), lineWidth: 1)
                                                        }
                                                }
                                                .padding(.trailing, 40)
                                            }
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    Button(action: {
                                        
                                        weights.append("")
                                        repetitions.append("")
                                        
                                        
                                    }) {
                                        HStack {
                                            Text("Next Set")
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(Color.greenColor)
                                        }.tint(Color.greenColor)
                                    }
                                    .padding()
                                }
                                
                                
                                
                                
                                
                            }
                            
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                
                                    .foregroundColor(.secondaryDark)
                                    .padding([.top, .bottom], 10)
                            )
                            .padding()
                        }
                    }
                }
                
                
                Spacer()
                
                
                Button {
                    self.isPresented.toggle()
                    self.textFieldIsDisabled = false
                    
                    repetitions = [""]
                    weights = [""]
                    
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
                    .padding(20)
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
            .sheet(isPresented: $isPresented) {
                ExercisesView(vm: vm.exerciseListVM)
            }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
