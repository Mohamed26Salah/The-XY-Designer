import SwiftUI
import SceneKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UploadScene: ObservableObject {
    @Published var showLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var sceneName: String = ""
    let manageSceneDataBase = ManageSceneDataBase()
    func uploadFile(scene: SCNScene, getSceneID: String = "" , dominantColors : [String : [String]], withOptimization: Bool) {
        
        // Save the JSON data to a file in the app's documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("scene.json")
        if (getSceneID != ""){
            sceneName = getSceneID
        } else {
            if !Validator.isValidUsername(for: sceneName) {
                DispatchQueue.main.async {
                    self.errorMessage = "Name is invalid"
                    self.showError.toggle()
                    self.showLoading = false
                }
                return
            }
            sceneName = Auth.auth().currentUser!.uid + sceneName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        try! SceneToJson().exportJson(to: fileURL, scene: scene, specialID: sceneName, dominantColors: dominantColors)
        if let fileData = try? Data(contentsOf: fileURL) {
            uploadJSONAndAppendToArray(fileData: fileData, id: sceneName, withOptimization: withOptimization)
        } else {
            print("Error reading data from file at URL: \(fileURL)")
        }
        
    }
    func uploadJSONAndAppendToArray(fileData: Data, id: String, withOptimization: Bool) {
        showLoading = true
        manageSceneDataBase.uploadJSONFile(fileData: fileData, id: id) { downloadURL, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showLoading = false
                    self.showError = true
                    self.errorMessage = "Error uploading JSON file: \(error.localizedDescription)"
                }
            } else if let downloadURL = downloadURL {
                let newJSONFile: [String: Any] = [
                    "BeingOptimized": withOptimization,
                    "id": id,
                    "link": downloadURL,
                    "time": self.manageSceneDataBase.getCurrentTime() as Timestamp
                ]
                
                self.manageSceneDataBase.documentRef.getDocument { document, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self.showLoading = false
                            self.showError = true
                            self.errorMessage = "Error getting document: \(error.localizedDescription)"
                        }
                    } else if let document = document, document.exists {
                        // Scene already exists, update the JSONFiles array
                        self.updateJSONFilesArray(document: document, newJSONFile: newJSONFile, withOptimization: withOptimization, fileData: fileData)
                    } else {
                        // Scene does not exist, create a new document
                        self.createSceneDocument(id: id, newJSONFile: newJSONFile, withOptimization: withOptimization, fileData: fileData)
                    }
                }
            }
        }
    }
    
    func updateJSONFilesArray(document: DocumentSnapshot, newJSONFile: [String: Any], withOptimization: Bool, fileData: Data) {
        if let jsonFiles = document.data()?["jsonFiles"] as? [[String: Any]] {
            var updatedJsonFiles = jsonFiles // Create a mutable copy of jsonFiles
            var jsonFileUpdated = false
            
            for (index, jsonFile) in jsonFiles.enumerated() {
                if let jsonFileId = jsonFile["id"] as? String, jsonFileId == newJSONFile["id"] as? String {
                    // Update the JSON file and time in the existing cell
                    updatedJsonFiles[index] = newJSONFile
                    jsonFileUpdated = true
                    break // Exit the loop as the update is done
                }
            }
            
            if !jsonFileUpdated {
                // If jsonFile not found, append newJSONFile to the array
                updatedJsonFiles.append(newJSONFile)
            }
            
            // Update the document with the updated JSONFiles array
            self.manageSceneDataBase.documentRef.updateData([
                "jsonFiles": updatedJsonFiles
            ]) { error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.showLoading = false
                        self.showError = true
                        self.errorMessage = "Error updating document: \(error.localizedDescription)"
                    }
                } else {
                    if (withOptimization){
                        SceneOptimization().sendToServer(sceneJson: fileData)
                    }
                    DispatchQueue.main.async {
                        self.showLoading = false
                    }
                }
            }
        }
    }
    
    func createSceneDocument(id: String, newJSONFile: [String: Any], withOptimization: Bool, fileData: Data) {
        let data: [String: Any] = [
            "jsonFiles": [
                newJSONFile
            ]
        ]
        self.manageSceneDataBase.documentRef.setData(data) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showLoading = false
                    self.showError = true
                    self.errorMessage = "Error creating document: \(error.localizedDescription)"
                }
            } else {
                if (withOptimization){
                    SceneOptimization().sendToServer(sceneJson: fileData)
                }
                DispatchQueue.main.async {
                    self.showLoading = false
                }
            }
        }
    }
}

