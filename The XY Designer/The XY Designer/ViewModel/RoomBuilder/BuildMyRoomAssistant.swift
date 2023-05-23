//
//  BuildMyRoomAssistant.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 25/04/2023.
//

import Foundation
import SceneKit
import SwiftUI
import RoomPlan
import GameController
import ColorKit

struct BuildMyRoomAssistant {
    func addPlatform(node: SCNNode, platFormModel: MaterialNode, wall: MaterialNode){
        let planeGeometry = SCNPlane(
            width: 50,
            height: 50)
        planeGeometry.firstMaterial?.isDoubleSided = true
        planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.4)
        planeGeometry.cornerRadius = 5
        platFormModel.geometry = planeGeometry
        platFormModel.eulerAngles = SCNVector3Make(Float.pi / 2, 0, 0)
        let wallHeight = wall.dimenstions.y
        platFormModel.position = SCNVector3(node.position.x, -2, node.position.z)
        platFormModel.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        node.addChildNode(platFormModel)
    }
    
    func addWalls(node: SCNNode, wallModel: MaterialNode) -> MaterialNode{
        let box = SCNBox(width: CGFloat(wallModel.dimenstions.x), height: CGFloat(wallModel.dimenstions.y), length: CGFloat(wallModel.dimenstions.z), chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        if let color = wallModel.color {
            box.firstMaterial?.diffuse.contents = color
        }else{
            box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
        }
        wallModel.geometry = box
        wallModel.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        wallModel.physicsBody?.mass = 0
        wallModel.physicsBody?.restitution = 0
        wallModel.physicsBody?.categoryBitMask = EntityType.wall.rawValue
        if wallModel.texture != nil {
            addTextures(node: wallModel)
        }
        node.addChildNode(wallModel)
        return wallModel
    }
    func addFloor(node: SCNNode, walls: [MaterialNode], color: UIColor = .white, cornerRadius: CGFloat = 0.0){
      
    }

    func addWindows(node: SCNNode, windowModel: MaterialNode){
        let box = SCNBox(width: CGFloat(windowModel.dimenstions.x), height: CGFloat(windowModel.dimenstions.y), length: CGFloat(windowModel.dimenstions.z)+0.01, chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        if let color = windowModel.color {
            box.firstMaterial?.diffuse.contents = color
        }else{
            box.firstMaterial?.diffuse.contents = Color.lightBlue
        }
        windowModel.geometry = box
        windowModel.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        if windowModel.texture != nil {
            addTextures(node: windowModel)
        }
        if windowModel.a3dModel != nil{
            set3dModel(node: windowModel)
        }
        node.addChildNode(windowModel)
    }
    func addDoors(node: SCNNode, doorModle: MaterialNode){
        let box = SCNBox(width: CGFloat(doorModle.dimenstions.x), height: CGFloat(doorModle.dimenstions.y), length: CGFloat(doorModle.dimenstions.z)+0.01, chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        if let color = doorModle.color {
            box.firstMaterial?.diffuse.contents = color
        }else{
            box.firstMaterial?.diffuse.contents = Color.lightGrayFancy
        }
        doorModle.geometry = box
        doorModle.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        if doorModle.texture != nil {
            addTextures(node: doorModle)
        }
        if doorModle.a3dModel != nil{
            set3dModel(node: doorModle)
        }
        node.addChildNode(doorModle)
    }
    func addOpenings(node: SCNNode, openingModle: MaterialNode){
        let box = SCNBox(width: CGFloat(openingModle.dimenstions.x), height: CGFloat(openingModle.dimenstions.y), length: CGFloat(openingModle.dimenstions.z), chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        if let color = openingModle.color {
            box.firstMaterial?.diffuse.contents = color
        }else{
            box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
        }
        openingModle.geometry = box
        openingModle.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        if openingModle.texture != nil {
            addTextures(node: openingModle)
        }
        node.addChildNode(openingModle)
    }
    func addObjects(node: SCNNode, objectModel: MaterialNode){
        let box = SCNBox(width: CGFloat(objectModel.dimenstions.x), height: CGFloat(objectModel.dimenstions.y), length: CGFloat(objectModel.dimenstions.z), chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        if let color = objectModel.color {
            box.firstMaterial?.diffuse.contents = color
        }else{
            box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
        }
        objectModel.geometry = box
        objectModel.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        objectModel.physicsBody?.mass = 0
        objectModel.physicsBody?.restitution = 1
        objectModel.physicsBody?.categoryBitMask = EntityType.object.rawValue
        objectModel.physicsBody?.collisionBitMask = EntityType.wall.rawValue
        objectModel.physicsBody?.contactTestBitMask = EntityType.object.rawValue | EntityType.wall.rawValue
        if objectModel.texture != nil {
            addTextures(node: objectModel)
        }
        if objectModel.a3dModel != nil{
            set3dModel(node: objectModel)
        }
        
        node.addChildNode(objectModel)
    }
    func addTextures(node: MaterialNode){
        let material = SCNMaterial()
        if let image = UIImage(named: node.texture){
            material.diffuse.contents = image
        }else{
            material.diffuse.contents = node.texture
        }
        node.geometry?.materials = [material]
    }
    func set3dModel(node: MaterialNode){
        var getOldPosition = SCNVector3(0,0,0)
        var getOldRotation: Float = 0.0
        let new3dModel = BuildRoom3DModels().add3DModelReturn(materialNode: node, desiredDimenstions: node.dimenstions, transform:   simd_float4x4(node.transform), modelName: node.a3dModel, extenstion: "usdz")
        if let firstChild = node.childNodes.first {
            getOldPosition = firstChild.position
        }
        for child in node.childNodes {
            print("ChildRotation Befor T3deel \(child.rotation)")
            child.removeFromParentNode()
            getOldRotation = child.eulerAngles.y  + .pi / 2
        }
        node.geometry = nil
        new3dModel.position = getOldPosition
        new3dModel.eulerAngles.y = getOldRotation
        node.addChildNode(new3dModel)
    }
    func addNewFurniture(addObjectsTO node : SCNNode, newFurniture: MaterialNode){
        let box = SCNBox(width: CGFloat(newFurniture.dimenstions.x), height: CGFloat(newFurniture.dimenstions.y), length: CGFloat(newFurniture.dimenstions.z), chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        if let color = newFurniture.color {
            box.firstMaterial?.diffuse.contents = color
        }else{
            box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
        }
        let stringUUID = newFurniture.UUID
        let boxNode = MaterialNode(type: newFurniture.type, id: stringUUID, dimenstions: newFurniture.dimenstions, confidence: newFurniture.confidence, subObjectCategory: newFurniture.subObjectCategory)
        boxNode.geometry = box
        //        boxNode.simdTransform = object.transform
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.mass = 0
        boxNode.physicsBody?.restitution = 1
        boxNode.physicsBody?.categoryBitMask = EntityType.object.rawValue
        boxNode.physicsBody?.collisionBitMask = EntityType.wall.rawValue
        boxNode.physicsBody?.contactTestBitMask = EntityType.object.rawValue | EntityType.wall.rawValue
        if newFurniture.texture != nil {
            boxNode.texture = newFurniture.texture
            addTextures(node: boxNode)
            //            clickedFeel(materialNode: boxNode)
        }
        if newFurniture.a3dModel != nil{
            boxNode.a3dModel = newFurniture.a3dModel
            set3dModel(node: boxNode)
            //            clickedFeel(materialNode: boxNode)
        }
        DispatchQueue.main.async {
            boxNode.highlight(with: .red, for: 5)
        }
        boxNode.simdPosition.y = node.childNodes.last?.simdPosition.y ?? 0
        node.addChildNode(boxNode)
    }
    func clickedFeel(materialNode: MaterialNode){
        let scaleDownAction = SCNAction.scale(to: 0.9, duration: 0.25)
        let scaleUpAction = SCNAction.scale(to: 1.0, duration: 0.25)
        let sequenceAction = SCNAction.sequence([scaleDownAction, scaleUpAction])
        materialNode.runAction(sequenceAction)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
}
