//
//  EditNodeNew.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/05/2023.
//

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
    @State private var uiImage: UIImage?
    let errorURL: URL = URL(string: "https://images.unsplash.com/photo-1623018035782-b269248df916?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80")!
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
            Color.white
                .ignoresSafeArea(.all)
            ZStack(alignment: .bottom) {
                VStack {
                    Text("Edit The object")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical, 15)
                        .foregroundColor(.black)
                    Picker("Pages", selection: $selectedPage) {
                        ForEach(EditState.allCases,id: \.self) { page in
                            Text(page.rawValue.capitalized)
                        }
                    }
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
                    sceneOfFurniture(furniture: editFurnitureVM)
                        .cornerRadius(15)
                        .padding(.horizontal, 15)
                        .frame(height: geometry.size.height / 3)
                        .background(Color(UIColor.white))
                    
                    Form{
                        if (selectedPage == .Scale) {
                            Section(header: Text("Change Object Dimenstions").background(Color.white).foregroundColor(.black)){
                                ShowDimenstions(furniture: editFurnitureVM, disabled: true, node: nodeToBeEdited)
                                
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
                                
                                .onChange(of: selectedColor) { newColor in
                                    //                                let node = editFurnitureVM.returnNewFurniture()
                                    editFurniture.applyColor(to: node, color: selectedColor)
                                }
                            }
                            .listRowBackground( LinearGradient(
                                gradient: Gradient(
                                    colors: [Color(hex: "#42C2FF"), Color(hex: "#00B4D8")]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .padding(.horizontal, 17)
                            //                        .onChange(of: selectedColor) { newColor in
                            //                            //                                let node = editFurnitureVM.returnNewFurniture()
                            //                            editFurniture.applyColor(to: node, color: selectedColor)
                            //                        }
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
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.white)
                            }
                            else {
                                Text("This object cant be changed.")
                                    .bold()
                                    .foregroundColor(.black)
                            }
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
                HStack{
                    Spacer()
                    Button {
        
                        if let editableNode = editFurnitureVM.node.childNodes.first as? MaterialNode {
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
                                print("First")
                                editFurniture.applyTexture(to: nodeToBeEdited, imageName: selectedImage)
    //                                editFurniture.applyTextureFromURL(to: nodeToBeEdited, imageURL: selectedImage)
                            }
                            if let imageFromGallery = uiImage {
                                editFurniture.applyTextureFromGallery(to: nodeToBeEdited, imageName: imageFromGallery)
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
                    .foregroundColor(.white)
                    Spacer()
                }
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
struct DeleteButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "trash")
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .clipShape(Circle())
        }
    }
}

//                HStack {
//                    Spacer()
//                    DismissButton {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    .padding()
//                }
