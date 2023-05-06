//
//  SceneOptimization.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 28/04/2023.
//

import Foundation
class SceneOptimization {
    func sendToServer(sceneJson: Data) {
        let serverURL = URL(string: "https://engaged-diode-383214.lm.r.appspot.com/")!
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = sceneJson
        let session = URLSession.shared
//        print("One Mara Only")
        let task = session.dataTask(with: request)
//        {data,response,error in
//            if error != nil {
//                print("Fuck you ya speed")
//            }
//            if let response = response {
//                print("Fuck Mee")
//                print(response)
//            }
//            guard data != nil else {
//                print("No Both OF use")
//                return
//            }
//        }
        task.resume()
    }

//    let url = URL(string: "https://example.com/api%22")
//
//    // Create a JSON object to send
//    let json: [String: Any] = [
//        "name": "John",
//        "age": 30,
//        "email": "john@example.com"
//    ]
//
//    // Convert the JSON object to Data
//    let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//    // Create a URLRequest with the URL
//    var request = URLRequest(url: url!)
//
//    // Set the HTTP method to POST
//    request.httpMethod = "POST"
//
//    // Set the content type to JSON
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    // Set the HTTP body to the JSON data
//    request.httpBody = jsonData
//
//    // Create a URLSession instance
//    let session = URLSession.shared
//
//    // Create a data task with the URLRequest
//    let task = session.dataTask(with: request) { (data, response, error) in
//        // Handle the response
//
//
//        // Start the task
//        task.resume()
        
//    }
}

