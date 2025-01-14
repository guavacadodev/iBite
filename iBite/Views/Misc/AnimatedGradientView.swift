//
//  AnimatedGradientView.swift
//  iBite
//
//  Created by Jake Woodall on 1/13/25.
//

import SwiftUI

struct AnimatedGradientView: View {
    @State private var animateGradient = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                animateGradient ? Color("orange1") : Color("yellow2"),
                animateGradient ? Color("yellow1") : Color("orange1"),
                animateGradient ? Color("yellow2") : Color("yellow1")
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateGradient)
        .onAppear {
            animateGradient.toggle() // Start the animation when the view appears
        }
        .edgesIgnoringSafeArea(.all) // Optional, makes the gradient cover the entire screen
    }
}
