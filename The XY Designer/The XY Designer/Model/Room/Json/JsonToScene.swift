//
//  JsonToScene.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 25/04/2023.
//


import Foundation
import RoomPlan
import simd
import SceneKit
import FirebaseAuth


struct JsonToScene {
    func getJsonFile(url: String, completion: @escaping (PrepareJsonToScene?, Error?) -> Void) {
        let jsonFileURL = URL(string: url)!
        let session = URLSession.shared
        let task = session.dataTask(with: jsonFileURL) { (data, response, error) in
            if let error = error {
//                print("Error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            guard let data = data else {
                print("No data received")
                let customError = NSError(domain: "NoDataError", code: 0, userInfo: nil)
                completion(nil, customError)
                return
            }
            do {
                let decodedScene = try JSONDecoder().decode(DecodeScene.self, from: data)
                let prepareJsonToScene = PrepareJsonToScene(decodedScene: decodedScene)
                completion(prepareJsonToScene, nil)
            } catch {
//                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        task.resume()
    }
}

//completion: @escaping (Result<DecodeScene, Error>) -> Void)
//                completion(.failure(error))
//                completion(.failure(customError))
//                completion(.success(decodedScene))
//                completion(.failure(error))
