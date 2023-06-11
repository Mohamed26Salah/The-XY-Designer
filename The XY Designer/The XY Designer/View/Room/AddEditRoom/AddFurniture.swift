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
            VStack {
                Text("Add New Furniture")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.vertical, 15)
                Picker("Pages", selection: $selectedPage) {
                    ForEach(AddState.allCases,id: \.self) { page in
                        Text(page.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, -10)
                .padding(.horizontal, 15)
                Form{
                    sceneOfNewFurniture(newFurniture: newFurniture)
                        .frame(height: geometry.size.height / 3)
                        .background(Color(UIColor.white))
                    if (selectedPage == .Scale) {
                        Section(header: Text("Change Object Dimenstions")){
                            ShowDimenstions(furniture: newFurniture, disabled: false)
                            
                        }
                        //                        }
                    }else if (selectedPage == .Colors){
                        Section(header: Text("Choose Object Color")){
                            ColorPicker(selection: $selectedColor){
                                Label("Color Pallete", systemImage: "paintpalette")
                                    .symbolVariant(.fill)
                                    .padding(.leading, 8)
                            }
                            .onChange(of: selectedColor) { newColor in
                                //                                let node = editFurnitureVM.returnNewFurniture()
                                editFurniture.applyColor(to: node, color: selectedColor)
                            }
                        }
                        Section(header: Text("Choose From Room Extracted Colors")){
                            ShowDominantColors(roomDominantColors: roomDominantColors, selectedColor: $selectedColor)
                        }
                    }else if(selectedPage == .Textures){
                        //                        let node = editFurnitureVM.returnNewFurniture()
                        Section(header: Text("Choose Texture From Your Own Gallery")){
                            ShowGallery(nodeToBeEdited: node, uiImageGallery: $uiImage)
                        }
                        Section(header: Text("Choose Object Texture")){
                            ShowTextures(selectedImage: $selectedImage)
                                .onChange(of: selectedImage) { newTexture in
                                    editFurniture.applyTexture(to: node, imageName: newTexture ?? "XY_V02")
//                                    editFurniture.applyTextureFromURL(to: node, imageURL: selectedImage ?? errorURL)
                                }
                        }
                    }
                    //                    else{
                    //                            Section(header: Text("Choose 3D Model")){
                    //                                Show3DModels(node: node, selectedModel: $selectedModel)
                    //                                    .onChange(of: selectedModel) { new3dModel in
                    ////                                        if let dimenstion = node.dimenstions{
                    //                                            if let selectedModel = new3dModel{
                    ////                                                editFurniture.apply3dModel(to: node, modelName: selectedModel, dimesntions: dimenstion , extenstion: "usdz")
                    //                                                node.a3dModel = selectedModel
                    //                                                BuildMyRoomAssistant().set3dModel(node: node)
                    //                                            }
                    //                                        }
                    ////                                    }
                    //
                    //                            }
                    //                    }
                    //                }
                }
             SaveChangesButton(newFurniture: newFurniture, mainNode: mainN)
            }
            .background(
                Color(UIColor { traitCollection in
                    return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.systemBackground
                })
            )
            .foregroundColor(Color(UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
            }))
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
            }
        }
        .foregroundColor(.primary)
        .padding(.horizontal,25)
        .padding(.vertical)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.grayFancy)
        }
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
