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
enum ButtonState: String, CaseIterable{
    case ExtractedColors
    case choose3DOpjects
}
struct EditNode: View {
    //    var node: SCNNode
//    var roomDominantColors: [String:[Color]] = [
//        "bedroom": [.red, .blue, .green],
//        "living room": [.yellow, .purple, .orange],
//        "kitchen": [.white, .gray, .brown],
//        "bathroom": [.pink, .gray, .cyan]
//    ]
    @Environment(\.presentationMode) var presentationMode
    var editFurniture = EditFurniture()
    var node: SCNNode
    var roomDominantColors: [String:[UIColor]]
//    var room: CapturedRoom
    @State private var selectedColor: Color = .red
    @State private var selectedPage: ButtonState = .ExtractedColors
    //        init(node: SCNNode, choosedColor: Color) {
    //            self.node = node
    //        }
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Choose Object Color")){
                    ColorPicker(selection: $selectedColor){
                        Label("Color Pallete", systemImage: "paintpalette")
                            .symbolVariant(.fill)
                            .padding(.leading, 8)
                    }
                }
                
                Section(header: Text("Edit The object")){
                    Picker("Pages", selection: $selectedPage) {
                        ForEach(ButtonState.allCases,id: \.self) { page in
                            Text(page.rawValue.capitalized)
                        }
                    }
                }
                .pickerStyle(.segmented)
                if (selectedPage == .ExtractedColors){
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
                    HStack{
                        Spacer()
                        Button {
                            editFurniture.applyColor(to: node, color: selectedColor)
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

                }else{
                    
                }
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
