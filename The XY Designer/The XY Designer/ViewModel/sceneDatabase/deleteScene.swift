//
//  deleteScene.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 20/05/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class deletescene {
    func deleteScene(userId: String, sceneId: String, completion: @escaping (Error?) -> Void) {
        let userDocumentRef = ManageSceneDataBase().documentRef
        
        userDocumentRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                completion(error)
            } else if let snapshot = snapshot, let data = snapshot.data(), var jsonFiles = data["jsonFiles"] as? [[String: Any]] {
                // Find index of dictionary with matching id
                if let index = jsonFiles.firstIndex(where: { $0["id"] as? String == sceneId }) {
                    // Remove dictionary from array
                    jsonFiles.remove(at: index)
                    
                    // Update user's list of scenes
                    userDocumentRef.updateData([
                        "jsonFiles": jsonFiles
                    ]) { error in
                        if let error = error {
                            print("Error updating user's list of scenes: \(error.localizedDescription)")
                            completion(error)
                        } else {
                            print("User's list of scenes successfully updated")
                            completion(nil)
                        }
                    }
                } else {
                    print("Scene not found in user's list of scenes")
                    completion(nil)
                }
            } else {
                print("Error fetching user document")
                completion(nil)
            }
        }
    }


}
