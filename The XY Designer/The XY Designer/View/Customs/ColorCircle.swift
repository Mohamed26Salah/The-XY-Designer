//
//  ColorCircle.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 11/04/2023.
//

import SwiftUI

struct ColorCircle: View {
    let color: Color
    @State private var isTapped = false
    @Binding var choosedColor: Color
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 30, height: 30)
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 1)
            )
            .scaleEffect(isTapped ? 0.9 : 1)
            .onTapGesture {
                isTapped = true
                choosedColor = color
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTapped = false
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                print("Tapped on Sama color \(color)")
            }
    }
}


