//
//  ShowTextures.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 15/04/2023.
//

import SwiftUI

struct ShowTextures: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let images = ["1174", "black-brick-wall-textured-background", "rough-white-cement-plastered-wall-texture", "grunge-wall-texture"]
    @Binding var selectedImage: String?
    var body: some View {
        VStack{
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        ClickableImage2(imageName: image, isSelected: image == selectedImage) {
                            selectedImage = image
                        }
                    }
                }
            }
        }    }
}




struct ClickableImage2: View {
    let imageName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 3)
            )
            .onTapGesture(perform: action)
    }
}








//struct ShowTextures_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowTextures()
//    }
//}
