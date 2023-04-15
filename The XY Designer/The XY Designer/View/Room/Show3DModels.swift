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


struct Show3DModels: View {
    @State private var models: [String] = []
    var node: MaterialNode
    @Binding var selectedModel: String?
    @Environment(\.presentationMode) var presentationMode
    //Filter 3D Object depending on the selected Furniture
    var body: some View {
        VStack{
           HStack{
               Spacer()
               Button {
                   EditFurniture().reset3dModel(to: node, dimesntions: node.dimenstions, transform: node.transform)
                   presentationMode.wrappedValue.dismiss()
               } label: {
                   HStack(spacing: 15){
                       Text("Reset 3D Model")
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
            ScrollView (showsIndicators: true){
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(models, id: \.self) { model in
                        ModelView(modelName: model,isSelected: model == selectedModel){
                            selectedModel = model
                        }
                    }
                }
            }
            .frame(height: 800)
            .onAppear(perform: loadModels)
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
}
struct ModelView: View {
    let modelName: String
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        SceneView(
            scene: SCNScene(named: modelName),
            options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
        .frame(width: 180, height: 250)
        .border(Color.black, width: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.red : Color.clear, lineWidth: 3)
        )
        .onTapGesture(perform: action)
    }
}

//struct Show3DModels_Previews: PreviewProvider {
//    static var previews: some View {
//        Show3DModels()
//    }
//}
