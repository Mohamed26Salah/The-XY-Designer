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

struct ManageSceneDataBase {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let auth = Auth.auth()
    let documentRef: DocumentReference
    let collectionRef: CollectionReference
    init(){
        collectionRef = db.collection("usersScenes")
        documentRef = collectionRef.document(auth.currentUser!.uid)
    }

    // Define your data structure
    struct JSONFile {
        let id: String
        let link: String
        let time: String
    }

    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
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

