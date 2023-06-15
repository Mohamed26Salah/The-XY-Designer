//
//  ShowTextures.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 15/04/2023.
//
//
//  ShowTextures.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 15/04/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShowTextures: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var images: [String] = []
    let textures = Textures()
    private static let topId = "topIdHere"
    @Binding var selectedImage: String?
    
    var body: some View {
        VStack {
//            ScrollViewReader { reader in
            ScrollView {
//                EmptyView().id(Self.topId)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(images, id: \.self) { imageName in
                           Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                                .shadow(radius: 20)
                                .border(selectedImage == imageName ? Color.yellow : Color.clear, width: 10)
                                .onTapGesture {
                                    selectedImage = imageName
//                                    withAnimation {  // add animation for scroll to top
//                                        reader.scrollTo(Self.topId, anchor: .top) // scroll
//                                    }
                                }
                        }
                    }
//                }
//            .id(Self.topId)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [Color(hex: "#42C2FF"), Color(hex: "#00B4D8")]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(0.3)
        )
        .onAppear(perform: loadModels)

    }
    private func loadModels() {
        DispatchQueue.global(qos: .userInitiated).async {
            var loadedImages: [String] = []
            for image in textures.images {
                loadedImages.append(image)
            }
            DispatchQueue.main.async {
                self.images = loadedImages
            }
        }
    }
}




//struct ClickableImage2: View {
//    let imageURL: URL
//    let isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Image(imageName)
//            .resizable()
//            .scaledToFit()
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 3)
//            )
//            .onTapGesture(perform: action)
//    }
//}

