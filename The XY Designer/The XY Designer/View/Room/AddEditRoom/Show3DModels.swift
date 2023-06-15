//
//  Show3DModels.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 15/04/2023.
//

import SwiftUI
import SceneKit
import Combine
import _SceneKit_SwiftUI
import RoomPlan

struct Show3DModels: View {
    @State private var models: [String] = []
    var node: MaterialNode
    @Binding var selectedModel: String?
    @Environment(\.presentationMode) var presentationMode
    var category: String {
        if (node.type == .object){
            return returnSubCategoryObjectString(subCategoryObject: node.subObjectCategory)
        }else {
            if(node.type == .door){
                return "door"
            }else{
                return "window"
            }
        }
    }
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button {
                    EditFurniture().reset3dModel(to: node, dimesntions: node.dimenstions, transform: node.transform)
                    //                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack(spacing: 15){
                        Text("Reset 3D Model")
                            .fontWeight(.semibold)
                            .contentTransition(.identity)
                            .foregroundColor(.white)
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
                Spacer()
            }
            ScrollView (showsIndicators: true){
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                    ForEach(models, id: \.self) { model in
                            SceneView(
                                scene: SCNScene(named: model),
                                options: [.allowsCameraControl, .autoenablesDefaultLighting]
                            )
                            .frame(width: 180, height: 250)
                            .border(Color.black, width: 5)
                            .shadow(radius: 20)
                            .border(selectedModel == model ? Color.yellow : Color.clear, width: 10)
                            .onTapGesture {
                                selectedModel = model
                            }
                    }
                }
            }
            .frame(height: 800)
            .border(Color.black, width: 2)
            .onAppear{
//                loadModels()
                loadModels(withName: category)
            }
        }
    }
    private func returnSubCategoryObjectString(subCategoryObject: CapturedRoom.Object.Category) -> String {
        switch subCategoryObject {
        case .bathtub:
            return "bathtub"
        case .bed:
            return "bed"
        case .chair:
            return "chair"
        case .dishwasher:
            return "dishwasher"
        case .fireplace:
            return "fireplace"
        case .oven:
            return "oven"
        case .refrigerator:
            return "refrigerator"
        case .sink:
            return "sink"
        case .sofa:
            return "sofa"
        case .stairs:
            return "stairs"
        case .storage:
            return "storage"
        case .stove:
            return "stove"
        case .table:
            return "table"
        case .television:
            return "monitor"
        case .toilet:
            return "toilet"
        case .washerDryer:
            return "washerDryer"
        @unknown default:
            return "bed"
        }
    }
    private func loadModels() {
        DispatchQueue.global(qos: .userInitiated).async {
            let fileManager = FileManager.default
            let bundleURL = Bundle.main.bundleURL
            let assetURLs = try! fileManager.contentsOfDirectory(at: bundleURL,
                                                                 includingPropertiesForKeys: nil,
                                                                 options: .skipsHiddenFiles)
            let modelNames = assetURLs.filter { $0.pathExtension == "usdz" }.map { $0.lastPathComponent }
            
            DispatchQueue.main.async {
                self.models = modelNames
            }
        }
    }
    private func loadModels(withName name: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fileManager = FileManager.default
            let bundleURL = Bundle.main.bundleURL
            
            do {
                let assetURLs = try fileManager.contentsOfDirectory(at: bundleURL,
                                                                    includingPropertiesForKeys: nil,
                                                                    options: .skipsHiddenFiles)
                
                let modelNames = assetURLs.filter { $0.pathExtension == "usdz" }.map { $0.lastPathComponent }
                
                // Filter models based on the provided name
                let filteredModelNames = modelNames.filter { $0.lowercased().contains(name.lowercased()) }
                
                DispatchQueue.main.async {
                    self.models = filteredModelNames
                }
            } catch {
                // Handle error
            }
        }
    }
    
}

//struct ModelView: View {
//    let modelName: String
//    var isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        SceneView(
//            scene: SCNScene(named: modelName),
//            options: [.allowsCameraControl, .autoenablesDefaultLighting]
//        )
//        .frame(width: 180, height: 250)
//        .border(Color.black, width: 5)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(isSelected ? Color.red : Color.clear, lineWidth: 3)
//        )
//        .onTapGesture(perform: action)
//    }
//}
//struct Show3DModels_Previews: PreviewProvider {
//    static var previews: some View {
//        Show3DModels()
//    }
//}
