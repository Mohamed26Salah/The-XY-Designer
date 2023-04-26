//
//  Home.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI
import FirebaseAuth
struct Home: View {
    @ObservedObject var fetchScenes = FetchScene()
    @State private var scenes: [JsonFileArrayCell] = []
    var jsonToScene = JsonToScene()
    var body: some View {
        ZStack{
            VStack{
                List(scenes) { scene in
                    NavigationLink(destination: View3DRoomNew(link: scene.link)) {
                        VStack(alignment: .leading) {
                            Text("Scene ID: \(scene.id)")
                            Text("Time: \(scene.time)")
                        }
//                        .onTapGesture {
//                            jsonToScene.getJsonFile(url: scene.link)
//                        }
                        
                    }
                }
            }
            if fetchScenes.showLoading {
                ProgressView()
                    .tint(.primary)
                    .foregroundColor(.secondary)
                    .scaleEffect(2)
            }
        }
        
        .onAppear {
            fetchScenes.fetchAllScenes { scenes, error in
                if let scenes = scenes {
                    DispatchQueue.main.async {
                        fetchScenes.showLoading = false
                    }
                    self.scenes = scenes
                } else if let error = error {
                    print("Error fetching scenes: \(error.localizedDescription)")
                }
            }
        }
        .alert(fetchScenes.errorMessage, isPresented: $fetchScenes.showError) {}
        
    }
}

struct SceneDetailView: View {
    var scene: JsonFileArrayCell
    
    var body: some View {
        VStack {
            Text("Scene ID: \(scene.id)")
            Text("Time: \(scene.time)")
            Text("Link: \(scene.link)")
            
        }
        .padding()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

