//
//  ActivityIndicator.swift
//  Stroke_LoadingButton
//
//  Created by baobeiAi on 1/30/23.
//

import SwiftUI

struct ActivityIndicator: View {
    
    @State var currentDegress = 0.0
    
//    let blueGradient = LinearGradient(gradient: Gradient(colors: [Color.yellow,
//                          Color.blue.opacity(0.75),
//                          Color.green.opacity(0.5),
//                          Color.purple.opacity(0.2),
//                          .clear]), startPoint: .leading, endPoint: .trailing)
    
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("Viva"),Color("Gradient2").opacity(0.7),Color("Gradient3").opacity(0.5)]), startPoint: .trailing, endPoint: .leading)
    
    var body: some View {
//        ProgressView().scaleEffect(10)
        Circle()
            .trim(from: 0.0,to:0.8)
            .stroke(gradient,style: StrokeStyle(lineWidth: 5,lineCap: .round))
            .frame(width: 40,height: 40,alignment: .center)
            .rotationEffect(Angle(degrees: currentDegress))
            .onAppear(perform: {
                Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { _ in
                    withAnimation{
                        self.currentDegress += 5

                    }
                })
            })
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}

