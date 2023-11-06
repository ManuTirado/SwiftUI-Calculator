//
//  SplashView.swift
//  SwiftUICalculator
//
//  Created by manuel.tirado on 3/11/23.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    @State var scale: CGFloat = 0
    @State var opacity: CGFloat = 1
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if isActive {
                CalculatorView()
                    .environmentObject(GlobalEnviroment())
            } else {
                VStack(spacing: 30) {
                    Constants.Images.splash
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    Text(Constants.Texts.author)
                        .modifier(SplashTextModifier())
                }
                .scaleEffect(scale)
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 25, initialVelocity: 1)) {
                scale = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.easeOut(duration: 0.2)) {
                    opacity = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1.1) {
                isActive = true
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
