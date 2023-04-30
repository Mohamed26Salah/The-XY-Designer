import Foundation

// create the URL endpoint you want to send the request to
let url = URL(string: "https://engaged-diode-383214.lm.r.appspot.com/")!

// create the request object
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")

// create the JSON payload
// let payload = ["key1": "value1", "key2": "value2"]
let jsonData = /*json here ya salah*/

// add the JSON payload to the request body
request.httpBody = jsonData

// create the URLSession and data task to send the request
let session = URLSession.shared
let task = session.dataTask(with: request) { data, response, error in
    // handle the response
    if let error = error {
        print("Error: \(error)")
        return
    }

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        print("Error: invalid response")
        return
    }

    if let data = data {
        print("Response: \(String(data: data, encoding: .utf8) ?? "")")
    }
}

// start the data task
task.resume()
