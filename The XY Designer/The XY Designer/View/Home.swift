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
    @Binding var isSignedIn: Bool
    @Binding var selectedTab: Int
    var jsonToScene = JsonToScene()
    var body: some View {
        ZStack{
            VStack{
                if fetchScenes.noScenes {
                    Spacer()
                    Image("Scan") // Replace "yourImageName" with the name of your image asset
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                    Text("You need to make some scans !")
                        .font(.body)
                        .padding()
                    
                    Button(action: {
                        withAnimation {
                            selectedTab = 1
                        }
                    }) {
                        Text("Scan Now")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(BlurView(style: .systemChromeMaterialDark))
                            .cornerRadius(10)
                    }
                    .padding()
                    Spacer()

                    
                }else {
                    List {
                        ForEach(scenes) { scene in
                            Row(link: scene.link, id: scene.id, time: scene.time)
                                .disabled(scene.BeingOptimized)
                        }
                        .onDelete(perform: { indexSet in
                            for index in indexSet {
                                if let userId = Auth.auth().currentUser?.uid {
                                    deletescene().deleteScene(userId: userId, sceneId: scenes[index].id) {_ in
                                        //                                    print(error as Any)
                                    }
                                    scenes.remove(at: index)
                                }
                            }
                        })
                    }
                    .listStyle(PlainListStyle()) // or InsetGroupedListStyle()
                    .background(Color.clear) // Set the background color to clear
                    .padding(.top,70)
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
        .onChange(of: isSignedIn) { newValue in
            fetchScenesOne()
        }
        
        
    }
    func fetchScenesOne() {
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


//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home(isSignedIn: true)
//    }
//}

