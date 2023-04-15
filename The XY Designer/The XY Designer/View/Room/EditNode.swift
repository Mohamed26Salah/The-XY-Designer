//
//  EditNode.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 11/04/2023.
//

import Foundation
import SwiftUI
import SceneKit
import RoomPlan
import PhotosUI
enum ButtonState: String, CaseIterable{
    case ExtractedColors
    case Textures
    case Objects3D
}
struct EditNode: View {
    @State var selectedItems: [PhotosPickerItem] = []
    @State var data: Data?
    @State private var selectedImage: String?
    @Environment(\.presentationMode) var presentationMode
    var editFurniture = EditFurniture()
    var node: MaterialNode
    var roomDominantColors: [String:[UIColor]]
    @State private var selectedColor: Color = .red
    @State private var selectedPage: ButtonState = .ExtractedColors
    @State private var selectedModel: String?
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Edit The object")){
                    Picker("Pages", selection: $selectedPage) {
                        ForEach(ButtonState.allCases,id: \.self) { page in
                            Text(page.rawValue.capitalized)
                        }
                    }
                }
                .pickerStyle(.segmented)
                if (selectedPage == .ExtractedColors){
                    Section(header: Text("Choose Object Color")){
                        ColorPicker(selection: $selectedColor){
                            Label("Color Pallete", systemImage: "paintpalette")
                                .symbolVariant(.fill)
                                .padding(.leading, 8)
                        }
                    }
                    Section(header: Text("Choose From Room Extracted Colors")){
                        List {
                            ForEach(roomDominantColors.keys.sorted(), id: \.self) { room in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        let parts = room.components(separatedBy: "+")
                                        Text(parts.first ?? "Furniture")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Spacer()
                                        
                                        ForEach(roomDominantColors[room]!, id: \.self) { color in
                                            ColorCircle(color: Color(color),choosedColor: $selectedColor)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else if(selectedPage == .Textures){
                    Section(header: Text("Choose Object Texture")){
                        ShowTextures(selectedImage: $selectedImage)
                    }
                    
                }else{
                    if(node.type == .door || node.type == .window || node.type == .object){
                        Section(header: Text("Choose 3D Model")){
                            Show3DModels(node: node, selectedModel: $selectedModel)
                        }
                    }
                    else {
                        Text("This object cant be changed.")
                            .bold()
                    }
                }
                
                HStack{
                    Spacer()
                    Button {
                        if (selectedPage == .ExtractedColors){
                            editFurniture.applyColor(to: node, color: selectedColor)
                        } else if(selectedPage == .Textures){
                            if let selectedImage = selectedImage {
                                editFurniture.applyTexture(to: node, imageName: selectedImage)
                            }
                        }
                        else {
                            
                            if let dimenstion = node.dimenstions{
                                if let selectedModel = selectedModel{
                                    editFurniture.apply3dModel(to: node, modelName: selectedModel, dimesntions: dimenstion , transform: node.transform, extenstion: "usdz")
                                }
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
        }
        
        //Image Picker
        if (selectedPage == .Textures){
            HStack{
                Spacer()
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 1,
                    matching: .images
                ){
                    Text("Select From Gallary")
                        .fontWeight(.semibold)
                        .contentTransition(.identity)
                }
                .foregroundColor(.primary)
                .padding(.horizontal,25)
                .padding(.vertical)
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(.secondary.opacity(0.3))
                }
                .onChange(of: selectedItems) { newValue in
                    guard let item = selectedItems.first else{
                        return
                    }
                    item.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data{
                                self.data = data
                                if let uiImage = UIImage(data: data){
                                    editFurniture.applyTextureFromGallery(to: node, imageName: uiImage)
                                    presentationMode.wrappedValue.dismiss()
                                    
                                }
                            } else {
                                print("Data is nil")
                            }
                        case .failure(let failure):
                            fatalError("\(failure)")
                        }
                        
                    }
                }
                Spacer()
            }
        }
    }
    
}


//
//struct EditNode_Previews: PreviewProvider {
//    static var previews: some View {
//        EditNode()
//    }
//}
