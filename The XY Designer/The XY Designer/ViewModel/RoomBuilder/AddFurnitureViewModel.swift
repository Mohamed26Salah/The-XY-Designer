//
//  AddFurnitureViewModel.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 04/05/2023.
//

import Foundation
import SwiftUI
import RoomPlan
import SceneKit
class AddFurnitureViewModel: AddEditMaster {
    
    @Published var category: EntityType = .object
    @Published var subObjectCategory: CapturedRoom.Object.Category = .bathtub
    override init(){
        super.init()
        setupScene()
    }
    func setupScene() {
        furnitureNode(addTO: node)
        scene.rootNode.addChildNode(node)
        scene.background.contents = Color.white.opacity(0.3)
        prepareCamera()
    }
    func furnitureNode(addTO node : SCNNode){
        let dimenstions = convertStringToFloat()
        let box = SCNBox(width: CGFloat(dimenstions.x), height: CGFloat(dimenstions.y), length: CGFloat(dimenstions.z), chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
        let stringUUID = UUID().uuidString
        let boxNode = MaterialNode(type: category, id: stringUUID, dimenstions: dimenstions, confidence: .high, subObjectCategory: subObjectCategory)
        boxNode.geometry = box
        boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        boxNode.confidence = .high
        node.addChildNode(boxNode)
    }
    
}
