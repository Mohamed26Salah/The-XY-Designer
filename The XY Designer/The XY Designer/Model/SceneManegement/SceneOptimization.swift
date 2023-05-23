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
        let task = session.dataTask(with: request)
        task.resume()
    }

}

