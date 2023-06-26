//
//  Planner.swift
//  FitNote
//
//  Created by Pavel on 26.06.23.
//

import SwiftUI

struct Planner: View {
    @State var currentDate: Date = Date()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20){
                //дэйт пикер
                DatePicker()
            }
        }
    }
}

struct Planner_Previews: PreviewProvider {
    static var previews: some View {
        Planner()
    }
}
