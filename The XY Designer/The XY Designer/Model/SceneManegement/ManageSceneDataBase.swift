//
//  ManageSceneDataBase.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 24/04/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ManageSceneDataBase {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let auth = Auth.auth()
    let documentRef: DocumentReference
    let collectionRef: CollectionReference
    init(){
        collectionRef = db.collection("usersScenes")
        if let currentUser = auth.currentUser {
            documentRef = collectionRef.document(currentUser.uid)
        } else {
            // If there is no current user, use a placeholder document reference
            documentRef = collectionRef.document("no-user")
        }    }
    //Serialization
    // Define your data structure
    struct JSONFile {
        let BeingOptimized: Bool
        let id: String
        let link: String
        let time: String
    }
    
    func getCurrentTime() -> Timestamp {
        let date = Date()
        return Timestamp(date: date)
    }
    
    
    // Function to upload JSON file to Firebase Storage
    func uploadJSONFile(fileData: Data, id: String, completion: @escaping (String?, Error?) -> Void) {
        let fileName = "Scenes/file\(id).json" // Generate a unique file name
        let fileRef = storage.reference().child(fileName)
        let metadata = StorageMetadata()
        metadata.contentType = "json"
        fileRef.putData(fileData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(nil, error)
            } else {
                fileRef.downloadURL { url, error in
                    if let error = error {
                        completion(nil, error)
                    } else if let downloadURL = url?.absoluteString {
                        completion(downloadURL, nil)
                    } else {
                        completion(nil, nil)
                    }
                }
            }
        }
    }
}
struct JsonFileArrayCell: Identifiable{
    var BeingOptimized: Bool
    var id: String
    var link: String
    var time: Date
    init(jsonFileCell: [String: Any]){
        self.BeingOptimized = jsonFileCell["BeingOptimized"] as! Bool
        self.id = jsonFileCell["id"] as! String
        self.link = jsonFileCell["link"] as! String
        let timeInterval = jsonFileCell["time"] as? Timestamp
        self.time = Date(timeIntervalSince1970: TimeInterval(timeInterval?.seconds ?? 0))
        
    }
}
//Deserialization
struct FireBaseSceneBody: Identifiable {
    var id: String
    var jsonFiles: [[String: Any]]
    var arrayOfJsonFiles: [JsonFileArrayCell]
    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
              let jsonFiles = data["jsonFiles"] as? [[String: Any]] else {
            return nil
        }
        
        self.id = document.documentID
        self.jsonFiles = jsonFiles
        var array = [JsonFileArrayCell]()
        for jsonCell in jsonFiles {
            let cell = JsonFileArrayCell(jsonFileCell: jsonCell)
            array.append(cell)
        }
        self.arrayOfJsonFiles = array
    }
}
