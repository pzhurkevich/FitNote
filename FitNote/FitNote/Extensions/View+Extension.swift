//
//  View+Extension.swift
//  FitNote
//
//  Created by Pavel on 10.06.23.
//

import SwiftUI


extension View {
    func specificCornersRadius(radius: CGFloat, coners: UIRectCorner) -> some View {
        
        clipShape(RoundedCorners(radius: radius, corners:  coners))
         
    }
    
 
    
}



struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct View_Extension_Previews: PreviewProvider {
    static var previews: some View {
        RoundedCorners()
    }
}
