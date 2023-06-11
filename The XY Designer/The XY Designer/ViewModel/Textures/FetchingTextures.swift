//
//  FetchingTextures.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 24/05/2023.
//


import SwiftUI
import FirebaseStorage

class FetchingTextures: ObservableObject {
    @Published var imageUrls: [URL] = []
    
    func fetchImageUrls() {
//        let storageRef = Storage.storage().reference()
//        let folderRef = storageRef.child("Textures")
//        
//        folderRef.listAll { [weak self] (result, error) in
//            if let error = error {
//                // Handle error
//            } else {
//                // result.items is an array of StorageReference objects
//                // representing the files in the folder
//                if let result = result {
//                    for fileRef in result.items {
//                        // You can get the download URL for each file
//                        fileRef.downloadURL { (url, error) in
//                            if let error = error {
//                                // Handle error
//                            } else if let url = url {
//                                self?.imageUrls.append(url)
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    func fetchImageUrls2() {
        let storageRef = Storage.storage().reference()
        let folderRef = storageRef.child("Textures")

        folderRef.listAll { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let error = error {
                // Handle error
                print("Error: \(error)")
                return
            }
            
            guard let result = result else {
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            for fileRef in result.items {
                dispatchGroup.enter()
                fileRef.downloadURL { (url, error) in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    if let error = error {
                        // Handle error
                        print("Error: \(error)")
                        return
                    }
                    
                    if let url = url {
                        DispatchQueue.main.async { [weak self] in
                            self?.imageUrls.append(url)
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                // All downloadURL requests completed
                // You can perform additional actions here if needed
            }
        }
    }
}
