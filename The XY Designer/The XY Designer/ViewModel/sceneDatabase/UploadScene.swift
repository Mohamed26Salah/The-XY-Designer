import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UploadScene: ObservableObject {
    @Published var showLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    let manageSceneDataBase = ManageSceneDataBase()

    func uploadJSONAndAppendToArray(fileData: Data, id: String) {
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
                    "id": id,
                    "link": downloadURL,
                    "time": self.manageSceneDataBase.getCurrentTime()
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
                        self.updateJSONFilesArray(document: document, newJSONFile: newJSONFile)
                    } else {
                        // Scene does not exist, create a new document
                        self.createSceneDocument(id: id, newJSONFile: newJSONFile)
                    }
                }
            }
        }
    }
    
    func updateJSONFilesArray(document: DocumentSnapshot, newJSONFile: [String: Any]) {
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
                    DispatchQueue.main.async {
                        self.showLoading = false
                    }
//                    print("JSON file updated and appended to array successfully!")
                }
            }
        }
    }
    
    func createSceneDocument(id: String, newJSONFile: [String: Any]) {
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
                DispatchQueue.main.async {
                    self.showLoading = false
                }
//                print("Document created successfully!")
            }
        }
    }
}

