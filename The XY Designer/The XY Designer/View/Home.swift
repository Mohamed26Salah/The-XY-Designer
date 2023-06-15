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
//            Color(hex: "#00FFCA")
//                .opacity(0.5)
//                .edgesIgnoringSafeArea(.all)
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
                            .foregroundColor(Color.black)
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(
                                        colors: [Color(hex: "#42C2FF"), Color(hex: "#00B4D8")]
                                    ),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: .gray, radius: 5, x: 2, y: 2)
                    }
                    .padding()
                    Spacer()

                    
                }else {
                    List {
                        ForEach(scenes) { scene in
                            Row(link: scene.link, id: scene.id, time: scene.time)
                                .disabled(scene.BeingOptimized)
                                .listRowBackground(Color.white)
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
                    .listStyle(PlainListStyle())// or InsetGroupedListStyle()
                    .background(Color.white)
                    .foregroundColor(Color.white)// Set the background color to clear
                    .padding(.top,70)
                }
            }
            if fetchScenes.showLoading {
                ProgressView()
                    .tint(.black)
                    .foregroundColor(.secondary)
                    .scaleEffect(3)
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


struct Home_Previews: PreviewProvider {
    @State static var bool = true
    @State static var selected = 0
    static var previews: some View {
        Home(isSignedIn: $bool, selectedTab: $selected)
    }
}

