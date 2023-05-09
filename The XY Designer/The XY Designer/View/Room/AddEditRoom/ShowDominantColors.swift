//
//  ShowDominantColors.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 08/05/2023.
//

import SwiftUI

struct ShowDominantColors: View {
    let roomDominantColors: [String : [UIColor]]
    @Binding var selectedColor: Color
    var body: some View {
        List {
            ForEach(roomDominantColors.keys.sorted(), id: \.self) { room in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        let parts = room.components(separatedBy: "+")
                        Text(parts.first ?? "Furniture")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        
                        ForEach(roomDominantColors[room]!, id: \.self) { color in
                            ColorCircle(color: Color(color),choosedColor: $selectedColor)
                        }
                    }
                    .padding(.vertical, 1)
                }
            }
        }
    }
}
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
//struct ShowDominantColors_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowDominantColors()
//    }
//}
