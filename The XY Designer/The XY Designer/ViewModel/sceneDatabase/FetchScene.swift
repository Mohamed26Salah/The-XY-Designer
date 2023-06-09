//
//  FetchScene.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 25/04/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FetchScene: ObservableObject{
    @Published var showLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var noScenes: Bool = false
   
//    let manageSceneDataBase = ManageSceneDataBase()
    func fetchAllScenes(completion: @escaping ([JsonFileArrayCell]?, Error?) -> Void) {
        showLoading = true
        ManageSceneDataBase().documentRef.getDocument { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showLoading = false
                    self.showError = true
                    self.errorMessage = "Error fetching scenes: \(error.localizedDescription)"
                }
                completion(nil, error)
            } else if let snap = snapshot {
                if !snap.exists { // Check if document doesn't exist
                    DispatchQueue.main.async {
                        self.showLoading = false
//                        self.showError = true
//                        self.errorMessage = "No scenes found"
                        self.noScenes = true
                    }
                    completion(nil, nil)
                } else {
                    // Condition if document exists but has no data
                    let sceneJsonDocument = FireBaseSceneBody(document: snap)
                    if sceneJsonDocument?.arrayOfJsonFiles.isEmpty ?? true {
                        DispatchQueue.main.async {
                            self.showLoading = false
//                            self.showError = true
//                            self.errorMessage = "No scenes found"
                            self.noScenes = true
                        }
                        completion(nil, nil)
                    } else {
                        self.noScenes = false
                        var fetchedScenes: [JsonFileArrayCell] = []
                        fetchedScenes = sceneJsonDocument!.arrayOfJsonFiles
                        let sortedScenes = fetchedScenes.sorted { $0.time.compare($1.time) == .orderedDescending }
                        completion(sortedScenes, nil)
                    }
                }
            }
        }
    }



}
