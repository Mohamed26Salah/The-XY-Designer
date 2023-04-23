//
//  UI-Image.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/04/2023.
//

import UIKit
extension UIImage {
    // Retrieve local file URL from UIImage
    func retrieveImageFileURL() -> URL? {
        if let imageData = self.jpegData(compressionQuality: 1.0) {
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = documentsDirectory?.appendingPathComponent("image.jpg")
            do {
                try imageData.write(to: fileURL!)
                return fileURL
            } catch {
                print("Error saving image to local file URL: \(error.localizedDescription)")
            }
        }
        return nil
    }
}

extension URL {
    // Create UIImage from local file URL
    func createImageFromLocalFileURL() -> UIImage? {
        return UIImage(contentsOfFile: self.path)
    }
    // Convert URL to String
    func toString() -> String? {
        return self.absoluteString
    }
}

extension String {
    // Convert String to URL
    func toURL() -> URL? {
        return URL(string: self)
    }
}

