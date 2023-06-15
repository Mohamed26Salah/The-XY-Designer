//
//  EditFurnitureViewModel.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/05/2023.
//

import Foundation
import SceneKit
import SwiftUI
import RoomPlan
class EditFurnitureViewModel: AddEditMaster {
    var nodeToBeEdited: MaterialNode
    init(node: MaterialNode) {
        nodeToBeEdited = node
        super.init()
        xDimension = String(nodeToBeEdited.dimenstions.x)
        yDimension = String(nodeToBeEdited.dimenstions.y)
        zDimension = String(nodeToBeEdited.dimenstions.z)
        setupScene()
    }
    func setupScene() {
        furnitureNode(addTO: node)
        scene.rootNode.addChildNode(node)
        scene.background.contents = Color.DarkTheme.Violet.background.cgColor
        prepareCamera()
    }
    func furnitureNode(addTO node : SCNNode){
        let dimenstions = convertStringToFloat()
        let box = SCNBox(width: CGFloat(nodeToBeEdited.dimenstions.x), height: CGFloat(nodeToBeEdited.dimenstions.y), length: CGFloat(nodeToBeEdited.dimenstions.z), chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        let boxNode = MaterialNode(type: nodeToBeEdited.type, dimenstions: dimenstions, subObjectCategory: nodeToBeEdited.subObjectCategory)
        if let color = nodeToBeEdited.color {
            boxNode.color = color
            box.firstMaterial?.diffuse.contents = color
        }else{
            box.firstMaterial?.diffuse.contents = Color.white
        }
        if let texture = nodeToBeEdited.texture {
            boxNode.texture = texture
        }
        if let a3dModel = nodeToBeEdited.a3dModel {
            boxNode.a3dModel = a3dModel
        }
        boxNode.geometry = box
        boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        if boxNode.texture != nil {
            BuildMyRoomAssistant().addTextures(node: boxNode)
//            BuildMyRoomAssistant().addTexturesFromURL(node: boxNode)
        }
        if boxNode.a3dModel != nil{
            BuildMyRoomAssistant().set3dModel(node: boxNode)
        }
        node.addChildNode(boxNode)
    }

}
