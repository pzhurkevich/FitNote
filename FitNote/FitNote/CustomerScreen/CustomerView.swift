//
//  CustomerView.swift
//  FitNote
//
//  Created by Pavel on 10.06.23.
//

import SwiftUI

struct CustomerView: View {
    var body: some View {
        ZStack {
            
          Color.darkColor.ignoresSafeArea()
          
  
            GeometryReader { geometry in
                
                VStack {
                    Spacer()
                
                        Rectangle()
                            .frame(maxHeight: geometry.size.height * 0.85)
                            .foregroundColor(Color.secondaryDark)
                        .specificCornersRadius(radius: 30, coners: [.topLeft, .topRight])
                } .ignoresSafeArea(edges: .bottom)
              
                VStack {
                    ZStack(alignment: .center) {
                        Circle()
                            .foregroundColor(Color.secondaryDark)
                       // Image(systemName: "camera")
                       // Image("pic")
                        Image("user")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                            
                            .foregroundColor(.white)
                           
                      
                            .overlay(Circle()
                                    .stroke(Color.greenColor, lineWidth: 10))
                            .clipShape(Circle())
                            .padding()
                            
                            
                    }
                    
                  .padding(.horizontal, geometry.size.width / 5)
                  .padding(.top, 20)
                    
                    Spacer()
                }
 
            }
            
          
            
            VStack {
                
                Spacer()
                
                Button {
                    
                } label: {
                    HStack {
                        Text("Start Now")
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                        
                        Image(systemName: "chevron.forward")
                            .fontWeight(.bold)
                    }
                    .tint(.black)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                    .background(Color.greenColor)
                    .clipShape(Capsule())
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Text("Start Now")
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                        
                        Image(systemName: "chevron.forward")
                            .fontWeight(.bold)
                    }
                    .tint(.black)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                    .background(Color.greenColor)
                    .clipShape(Capsule())
                }
                Button {
                    
                } label: {
                    HStack {
                        Text("Start Now")
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                        
                        Image(systemName: "chevron.forward")
                            .fontWeight(.bold)
                    }
                    .tint(.black)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                    .background(Color.greenColor)
                    .clipShape(Capsule())
                }
            }
        }
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView()
    }
}
