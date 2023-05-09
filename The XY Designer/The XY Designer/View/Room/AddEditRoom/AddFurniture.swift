//
//  AddFurniture.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 04/05/2023.
//

import SwiftUI
import SceneKit
import RoomPlan

struct AddFurniture: View {
    var mainN: SCNNode
    @ObservedObject var newFurniture = AddFurnitureViewModel()
    @State var selectedCategory: String?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    init(mainNode: SCNNode) {
        mainN = mainNode
        //        self._newFurniture = ObservedObject(wrappedValue: AddFurnitureViewModel(mainN: mainNode))
    }
    var body: some View {
        GeometryReader { geometry in
            VStack {
//                Spacer()
                HStack{
                    Spacer()
                    DismissButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                }
                sceneOfNewFurniture(newFurniture: newFurniture)
                    .frame(width: geometry.size.width, height: geometry.size.height / 2)
                    .background(Color(UIColor.white)) // Add background modifier here
                
                Spacer()
                ShowDimenstions(furniture: newFurniture)
                SaveChangesButton(newFurniture: newFurniture, mainNode: mainN)
            }
            .background(Color(UIColor.white))
            .ignoresSafeArea()
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
    static var previews: some View {
        AddFurniture(mainNode: node)
    }
}
