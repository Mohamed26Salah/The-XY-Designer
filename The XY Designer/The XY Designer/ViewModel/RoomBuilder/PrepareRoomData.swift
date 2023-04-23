//
//  PrepareRoomData.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/04/2023.
//

import SceneKit
import SwiftUI
import RoomPlan
import ColorKit
class PrepareRoomData{
    var scene: SCNScene = SCNScene()
    var room: CapturedRoom
    var dominantRoomColors: [String : [UIColor]]
    let node: SCNNode!
    init(
        room: CapturedRoom,
        dominantRoomColors: [String : [UIColor]]
    ) {
        node = SCNNode()
        node.position = SCNVector3(0,0,0)
        self.room = room
        self.dominantRoomColors = dominantRoomColors
        setupScene()
    }
    
}


// MARK: - Building Room

private extension PrepareRoomData {
    func setupScene() {
        addWalls(addWallsTO: node)
        addDoors(addDoorsTO: node)
        addWindows(addWindowsTO: node)
        addObjects(addObjectsTO: node)
        addOpennings(addOpenningsTO: node)
        createRoomPlane(addPlaneTO: node)
        scene.rootNode.addChildNode(node)
    }
    
    func createRoomPlane(addPlaneTO node : SCNNode){
        let planeGeometry = SCNPlane(
            width: 20,
            height: 20)
        planeGeometry.firstMaterial?.isDoubleSided = true
        planeGeometry.firstMaterial?.diffuse.contents = Color.white.opacity(0.4)
        planeGeometry.cornerRadius = 5
        let stringUUID = String(6338)
        let planeNode = MaterialNode(type: .platForm, id: stringUUID)
        planeNode.geometry = planeGeometry
        planeNode.geometry = planeGeometry
        planeNode.position = SCNVector3(node.position.x, -1.3, node.position.z)
        planeNode.eulerAngles = SCNVector3Make(Float.pi / 2, 0, 0)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        node.addChildNode(planeNode)
    }
    func addWalls(addWallsTO node : SCNNode){
        let walls = room.walls
        for wall in walls{
            let box = SCNBox(width: CGFloat(wall.dimensions.x), height: CGFloat(wall.dimensions.y), length: CGFloat(wall.dimensions.z), chamferRadius: 0)
            box.firstMaterial?.isDoubleSided = true
            if let colorsDictionary = dominantRoomColors["Wall+\(wall.identifier.uuidString)"]{
                let palette = ColorPalette(orderedColors: colorsDictionary, ignoreContrastRatio: true)
                box.firstMaterial?.diffuse.contents = palette?.background
            }else {
                box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
            }
            let stringUUID = wall.identifier.uuidString
            
            let boxNode = MaterialNode(type: .wall, id: stringUUID, dimenstions: wall.dimensions, confidence: wall.confidence, curve: wall.curve, completedEdges: wall.completedEdges)
            boxNode.geometry = box
            boxNode.simdTransform = wall.transform
            boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.addChildNode(boxNode)
        }
        
    }
    func addObjects(addObjectsTO node : SCNNode){
        let objects = room.objects
        for object in objects{
            let box = SCNBox(width: CGFloat(object.dimensions.x), height: CGFloat(object.dimensions.y), length: CGFloat(object.dimensions.z), chamferRadius: 0)
            box.firstMaterial?.isDoubleSided = true
            if let colorsDictionary = dominantRoomColors["Object+\(object.identifier.uuidString)"]{
                let palette = ColorPalette(orderedColors: colorsDictionary, ignoreContrastRatio: true)
                box.firstMaterial?.diffuse.contents = palette?.primary
            }else {
                box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
            }
            let stringUUID = object.identifier.uuidString
            let boxNode = MaterialNode(type: .object, id: stringUUID, dimenstions: object.dimensions, confidence: object.confidence, subObjectCategory: object.category)
            boxNode.geometry = box
            boxNode.simdTransform = object.transform
            boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.addChildNode(boxNode)
        }
        
    }
    func addDoors(addDoorsTO node : SCNNode){
        let doors = room.doors
        for door in doors{
            let box = SCNBox(width: CGFloat(door.dimensions.x), height: CGFloat(door.dimensions.y), length: CGFloat(door.dimensions.z)+0.01, chamferRadius: 0)
            box.firstMaterial?.isDoubleSided = true
            if let colorsDictionary = dominantRoomColors["Door+\(door.identifier.uuidString)"]{
                let palette = ColorPalette(orderedColors: colorsDictionary, ignoreContrastRatio: true)
                box.firstMaterial?.diffuse.contents = palette?.secondary
            }else {
                box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
            }
            let stringUUID = door.identifier.uuidString
            let boxNode = MaterialNode(type: .door, id: stringUUID, dimenstions: door.dimensions, confidence: door.confidence, subSurfaceCategory: door.category, curve: door.curve, completedEdges: door.completedEdges)
            boxNode.geometry = box
            boxNode.simdTransform = door.transform
            boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            node.addChildNode(boxNode)
        }
    }
    func addWindows(addWindowsTO node : SCNNode){
        let windows = room.windows
        for window in windows{
            let box = SCNBox(width: CGFloat(window.dimensions.x), height: CGFloat(window.dimensions.y), length: CGFloat(window.dimensions.z)+0.01, chamferRadius: 0)
            box.firstMaterial?.isDoubleSided = true
            if let colorsDictionary = dominantRoomColors["Window+\(window.identifier.uuidString)"]{
                let palette = ColorPalette(orderedColors: colorsDictionary, ignoreContrastRatio: true)
                box.firstMaterial?.diffuse.contents = palette?.secondary
            }else {
                box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
            }
            let stringUUID = window.identifier.uuidString
            let boxNode = MaterialNode(type: .window, id: stringUUID, dimenstions: window.dimensions, confidence: window.confidence, curve: window.curve, completedEdges: window.completedEdges)
            boxNode.geometry = box
            boxNode.simdTransform = window.transform
            boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            node.addChildNode(boxNode)
        }
        
    }
    func addOpennings(addOpenningsTO node : SCNNode){
        let openings = room.openings
        for opening in openings{
            let box = SCNBox(width: CGFloat(opening.dimensions.x), height: CGFloat(opening.dimensions.y), length: CGFloat(opening.dimensions.z), chamferRadius: 0)
            box.firstMaterial?.isDoubleSided = true
            if let colorsDictionary = dominantRoomColors["Opening+\(opening.identifier.uuidString)"]{
                let palette = ColorPalette(orderedColors: colorsDictionary, ignoreContrastRatio: true)
                box.firstMaterial?.diffuse.contents = palette?.primary
            }else {
                box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
            }
            let stringUUID = opening.identifier.uuidString
            let boxNode = MaterialNode(type: .opening, id: stringUUID, dimenstions: opening.dimensions, confidence: opening.confidence, curve: opening.curve, completedEdges: opening.completedEdges)
            boxNode.geometry = box
            boxNode.simdTransform = opening.transform
            boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            node.addChildNode(boxNode)
        }
        
    }
    
    
    
    
}





