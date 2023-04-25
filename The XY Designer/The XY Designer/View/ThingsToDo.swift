//
//  ThingsToDo.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 25/04/2023.
//

import Foundation
import SwiftUI
struct ScreenShotView: View {
    @State private var image: UIImage?

    var body: some View {
        VStack {
            // Display the captured screenshot image
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }

            // Button to capture screenshot
            Button("Capture Screenshot") {
                captureScreenshot()
            }
            .padding()
        }
    }

    func captureScreenshot() {
        let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
        let image = renderer.image { context in
            UIApplication.shared.keyWindow?.rootViewController?.view?.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
        }
        self.image = image
    }
}
