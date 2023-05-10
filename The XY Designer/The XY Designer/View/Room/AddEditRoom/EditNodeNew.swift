//
//  EditNodeNew.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/05/2023.
//


import SwiftUI
import SceneKit
import RoomPlan
import PhotosUI

enum EditState: String, CaseIterable{
    case Scale
    case Colors
    case Textures
    case _3D_
}
struct EditNodeNew: View {
    var nodeToBeEdited: MaterialNode
    var roomDominantColors: [String:[UIColor]]
    var editFurniture = EditFurniture()
    @ObservedObject var editFurnitureVM: EditFurnitureViewModel
    @State var selectedCategory: String?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedPage: EditState = .Scale
    @State private var selectedColor: Color = .red
    @State private var selectedImage: String?
    @State private var selectedModel: String?
    //    @State var data: Data?
    //    @State var selectedItems: [PhotosPickerItem] = []
    init(nodeToBeEdited: MaterialNode, dominantColors: [String:[UIColor]]) {
        self.nodeToBeEdited = nodeToBeEdited
        self._editFurnitureVM = ObservedObject(wrappedValue: EditFurnitureViewModel(node: nodeToBeEdited))
        self.roomDominantColors = dominantColors
    }
    var body: some View {
        let node = editFurnitureVM.returnNewFurniture()
        GeometryReader { geometry in
            VStack {
                Text("Edit The object")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.vertical, 15)
                Picker("Pages", selection: $selectedPage) {
                    ForEach(EditState.allCases,id: \.self) { page in
                        Text(page.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, -10)
                .padding(.horizontal, 15)
                Form{
                    sceneOfFurniture(furniture: editFurnitureVM)
                        .frame(height: geometry.size.height / 3)
                        .background(Color(UIColor.white))
                    if (selectedPage == .Scale) {
                        Section(header: Text("Change Object Dimenstions")){
//                            if let node = editFurnitureVM.node.childNodes.first as? MaterialNode{
//                                if (node.type != .object) {
//                                    Text("This Object dimenstions Can't Be Edited")
//                                        .foregroundColor(.red)
//                                        .bold()
//                                        .font(.system(.title3))
//                                } else if ((node.a3dModel) != nil) {
//                                    Text("You Need To Reset the Object, To Default, To change Dimenstions")
//                                        .foregroundColor(.red)
//                                        .bold()
//                                        .font(.system(.title3))
//                                }else {
//                                    ShowDimenstions(furniture: editFurnitureVM, disabled: true)
//                                }
                                ShowDimenstions(furniture: editFurnitureVM, disabled: true)

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
                            ShowGallery(nodeToBeEdited: node)
                        }
                        Section(header: Text("Choose Object Texture")){
                            ShowTextures(selectedImage: $selectedImage)
                                .onChange(of: selectedImage) { newTexture in
                                    editFurniture.applyTexture(to: node, imageName: newTexture ?? "XY_V02")
                                }
                        }
                    }else{
                        if(nodeToBeEdited.type == .door || nodeToBeEdited.type == .window || nodeToBeEdited.type == .object){
                            Section(header: Text("Choose 3D Model")){
                                Show3DModels(node: node, selectedModel: $selectedModel)
                                    .onChange(of: selectedModel) { new3dModel in
                                        if let dimenstion = node.dimenstions{
                                            if let selectedModel = new3dModel{
                                                editFurniture.apply3dModel(to: node, modelName: selectedModel, dimesntions: dimenstion , extenstion: "usdz")
                                            }
                                        }
                                    }
                                    
                            }
                        }
                        else {
                            Text("This object cant be changed.")
                                .bold()
                        }
                    }
                }
                
                HStack{
                    Spacer()
                    Button {
        
                        if let editableNode = editFurnitureVM.node.childNodes.first as? MaterialNode {
//                            if (nodeToBeEdited.dimenstions != editableNode.dimenstions){
////                                    editFurnitureVM.applyScale(to: nodeToBeEdited, desiredDimenstions: editableNode.dimenstions)
//                                let scale = editFurnitureVM.scaleWithoutA3dModel(node: nodeToBeEdited, x: editableNode.dimenstions.x, y: editableNode.dimenstions.y, z: editableNode.dimenstions.z)
//                                nodeToBeEdited.scale = scale
//                                nodeToBeEdited.dimenstions = editableNode.dimenstions
//                            }
                            if let isReseted = editableNode.a3dModel {
                                if let dimenstion = nodeToBeEdited.dimenstions{
//                                    if let selectedModel = selectedModel{
                                        editFurniture.apply3dModel(to: nodeToBeEdited, modelName: isReseted, dimesntions: dimenstion , extenstion: "usdz")
                                    }
//                                }
                            }else {
                                editFurniture.reset3dModel(to: nodeToBeEdited, dimesntions: editableNode.dimenstions, transform: nodeToBeEdited.transform)
                            }
                            if let color = editableNode.color {
                                editFurniture.applyColor(to: nodeToBeEdited, color: Color(color))
                            }
                            if let selectedImage = selectedImage {
                                editFurniture.applyTexture(to: nodeToBeEdited, imageName: selectedImage)
                            }
                        }
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
                            .foregroundColor(.secondary.opacity(0.3))
                    }
                    Spacer()
                }
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
//        .background(Color(UIColor.white))
    }
}

struct sceneOfFurniture: View {
    var furniture: EditFurnitureViewModel
    //    var sceneRendererDelegate = SceneRendererDelegate()
    //    ,delegate: sceneRendererDelegate
    var body: some View{
        SceneView(scene: furniture.scene, options: [.allowsCameraControl, .autoenablesDefaultLighting])
            .onTapGesture { location in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}
//
struct EditNodeNew_Previews: PreviewProvider {
    static var nodeToBeEdited = MaterialNode(type: .door)
    static var roomDominantColors = ["Me": [UIColor.red, UIColor.blue]]
    static var previews: some View {
        EditNodeNew(nodeToBeEdited: nodeToBeEdited, dominantColors: roomDominantColors)
    }
}
//                HStack {
//                    Spacer()
//                    DismissButton {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    .padding()
//                }
