//
//  AddFurniture.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 04/05/2023.
//

import SwiftUI
import SceneKit
import RoomPlan
enum AddState: String, CaseIterable{
    case Scale
    case Colors
    case Textures
}

struct AddFurniture: View {
    var mainN: SCNNode
    var roomDominantColors: [String:[UIColor]]
    var editFurniture = EditFurniture()
    @ObservedObject var newFurniture = AddFurnitureViewModel()
    @State var selectedCategory: String?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedPage: AddState = .Scale
    @State private var selectedColor: Color = .red
    @State private var selectedImage: String?
    @State private var selectedModel: String?
    @State private var uiImage: UIImage?
    let errorURL: URL = URL(string: "https://images.unsplash.com/photo-1623018035782-b269248df916?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80")!
    init(mainNode: SCNNode, dominantColors: [String:[UIColor]]) {
        mainN = mainNode
        self.roomDominantColors = dominantColors
    }
    var body: some View {
        let node = newFurniture.returnNewFurniture()
        GeometryReader { geometry in
            //            PortraitOnlyView()
            Color.white
                .ignoresSafeArea(.all)
            ZStack(alignment: .bottom){
                VStack {
                    Text("Add New Furniture")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical, 15)
                        .foregroundColor(.black)
                    Picker("Pages", selection: $selectedPage) {
                        ForEach(AddState.allCases,id: \.self) { page in
                            Text(page.rawValue.capitalized)
                        }
                    }
                    //                    .foregroundColor(.opacity(0.4))
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
                    .pickerStyle(.segmented)
                    .padding(.top, -10)
                    .padding(.horizontal, 15)
                   
                        sceneOfNewFurniture(newFurniture: newFurniture)
                            .cornerRadius(15)
                            .padding(.horizontal, 15)
                            .frame(height: geometry.size.height / 3)
                            .background(Color(UIColor.white))
                    Form{
                        if (selectedPage == .Scale) {
                            Section(header: Text("Change Object Dimenstions").background(Color.white).foregroundColor(.black)){
                                ShowDimenstions(furniture: newFurniture, disabled: false)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.white)
                            .background(
                                Color.white
                            )
                            .cornerRadius(15)
                            .padding(.horizontal, 15)
                        }else if (selectedPage == .Colors){
                            Section(header: Text("Choose Object Color")){
                                ColorPicker(selection: $selectedColor){
                                    Label("Color Pallete", systemImage: "paintpalette")
                                        .symbolVariant(.fill)
                                        .padding(.leading, 8)
                                        .foregroundColor(Color.white)
                                }
                                .listRowInsets(EdgeInsets())
                                .frame(height: 30)
                                .padding(.horizontal,10)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(
                                            colors: [Color(hex: "#42C2FF"), Color(hex: "#00B4D8")]
                                        ),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(10)
                                
                            }
                            .listRowBackground( LinearGradient(
                                gradient: Gradient(
                                    colors: [Color(hex: "#42C2FF"), Color(hex: "#00B4D8")]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .padding(.horizontal, 17)
                            .onChange(of: selectedColor) { newColor in
                                //                                let node = editFurnitureVM.returnNewFurniture()
                                editFurniture.applyColor(to: node, color: selectedColor)
                            }
                            //                            }
                            Section(header: Text("Choose From Room Extracted Colors")){
                                ShowDominantColors(roomDominantColors: roomDominantColors, selectedColor: $selectedColor)
                                    .padding(.horizontal, 17)
                                    .cornerRadius(15)
                            }
                            .listRowBackground(Color.white)
                            .listRowInsets(EdgeInsets())
                            
                            
                        }else if(selectedPage == .Textures){
                                Section(header: Text("Choose Texture From Your Own Gallery")){
                                    HStack {
                                        Spacer()
                                        ShowGallery(nodeToBeEdited: node, uiImageGallery: $uiImage)
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
                                        Spacer()
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.white)
                               
                                Section(header: Text("Choose Object Texture")){
                                    ShowTextures(selectedImage: $selectedImage)
                                        .onChange(of: selectedImage) { newTexture in
                                            editFurniture.applyTexture(to: node, imageName: newTexture ?? "XY_V02")
                                        }
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.white)
                            }
                    }
                    .foregroundColor(.black)
                    .tint(LinearGradient(
                        gradient: Gradient(
                            colors: [Color(hex: "#42C2FF"), Color(hex: "#00B4D8")]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .scrollContentBackground(.hidden)
                }
                SaveChangesButton(newFurniture: newFurniture, mainNode: mainN)
            }
        }
        .onAppear{
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear{
            AppDelegate.orientationLock = .all
        }
        
        
    }
}
struct SaveChangesButton: View {
    var newFurniture: AddFurnitureViewModel
    var mainNode: SCNNode
    @Environment(\.presentationMode) var presentationMode
    var body: some View{
        Button {
            //            newFurniture.addToTheMainScene()
            let node = newFurniture.returnNewFurniture()
            BuildMyRoomAssistant().addNewFurniture(addObjectsTO: mainNode, newFurniture: node)
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack(spacing: 15){
                Text("Apply Changes")
                    .fontWeight(.semibold)
                    .contentTransition(.identity)
                    .foregroundColor(.white)
            }
        }
        .foregroundColor(.primary)
        .padding(.horizontal,25)
        .padding(.vertical)
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
        .padding(.vertical,25)
    }
}

struct sceneOfNewFurniture: View {
    var newFurniture: AddFurnitureViewModel
    var body: some View{
        SceneView(scene: newFurniture.scene, options: [.allowsCameraControl, .autoenablesDefaultLighting])
            .onTapGesture { location in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

struct AddFurniture_Previews: PreviewProvider {
    static var node = SCNNode()
    static var roomDominantColors = ["Me": [UIColor.red, UIColor.blue]]
    static var previews: some View {
        AddFurniture(mainNode: node, dominantColors: roomDominantColors)
    }
}
