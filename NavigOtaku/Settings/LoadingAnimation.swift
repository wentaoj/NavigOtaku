//
//  LoadingAnimation.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/11/23.
//

import SwiftUI

struct LoadingAnimationView: View {
    @State private var isAnimating = false

    var body: some View {
        Image("loading")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .rotationEffect(.degrees(isAnimating ? 180 : 0))
            .onAppear() {
                withAnimation(Animation.linear(duration: 0.3).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}
