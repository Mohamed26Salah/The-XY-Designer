//
//  BuildMyRoom.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 06/04/2023.
//

import SceneKit
import SwiftUI
import RoomPlan
import GameController

class BuildMyRoom {
    var scene: SCNScene = SCNScene()
    private let cameraHeight: Float = 15
    var room: CapturedRoom
    let node: SCNNode!
    var pressedOnFurniture: Bool = false
    var selectedFurniture: MaterialNode?
    var furnitureSpeed: Float = 5
    init(
        room: CapturedRoom
    ) {
        node = SCNNode()
        self.room = room
        setupScene()
    }
    
}


// MARK: - Preparing Scene
private extension BuildMyRoom {
    func prepareLight() {
        let fieldCenter = node.position
        let spotlight = defaultLightNode(mode: .spot)
        spotlight.position = fieldCenter + SCNVector3(0, cameraHeight, 0)
        spotlight.look(at: fieldCenter)
        spotlight.light?.shadowRadius = 5
        //        spotlight.light?.castsShadow = false
        scene.rootNode.addChildNode(spotlight)
        scene.rootNode.addChildNode(defaultLightNode(mode: .ambient))
    }
    func prepareCamera() {
        // Setup camera
        let cameraNode = SCNNode()
        cameraNode.name = "CameraHuyamera"
        cameraNode.camera = SCNCamera()
        cameraNode.eulerAngles = SCNVector3(Float.pi / -3, 0, 0)
        cameraNode.camera?.fieldOfView = 40
        cameraNode.camera?.automaticallyAdjustsZRange = true
        
        // Place camera
        let fieldCenter = node.position
        cameraNode.position = fieldCenter + SCNVector3(0, cameraHeight, cameraHeight / 2)
        cameraNode.look(at: fieldCenter)
        
        //    let centerConstraint = SCNLookAtConstraint(target: field.centerCell().node)
        //    cameraNode.constraints = [centerConstraint]
        
        scene.rootNode.addChildNode(cameraNode)
    }
    func center() -> SCNVector3 {
        return node.position
    }
}
// MARK: - Building Room

private extension BuildMyRoom {
    func setupScene() {
        addWalls(addWallsTO: node)
        addDoors(addDoorsTO: node)
        addWindows(addWindowsTO: node)
        addObjects(addObjectsTO: node)
        addOpennings(addOpenningsTO: node)
        createRoomPlane(addPlaneTO: node)
        scene.rootNode.addChildNode(node)
        scene.background.contents = Color.DarkTheme.Violet.background.cgColor
        
        prepareCamera()
        prepareLight()
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
        //        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.geometry = planeGeometry
        planeNode.position = SCNVector3(node.position.x, -1.26, node.position.y)
        planeNode.eulerAngles = SCNVector3Make(Float.pi / 2, 0, 0)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        node.addChildNode(planeNode)
    }
    func addWalls(addWallsTO node : SCNNode){
        let walls = room.walls
        for wall in walls{
            let box = SCNBox(width: CGFloat(wall.dimensions.x), height: CGFloat(wall.dimensions.y), length: CGFloat(wall.dimensions.z), chamferRadius: 0)
            box.firstMaterial?.isDoubleSided = true
            box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.primary.cgColor
            let stringUUID = wall.identifier.uuidString
            let boxNode = MaterialNode(type: .wall, id: stringUUID)
            boxNode.geometry = box
            //                let boxNode = SCNNode(geometry: box)
            boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            boxNode.simdTransform = wall.transform
            node.addChildNode(boxNode)
        }
        
    }
    func addObjects(addObjectsTO node : SCNNode){
        let objects = room.objects
        for object in objects{
            let box = SCNBox(width: CGFloat(object.dimensions.x), height: CGFloat(object.dimensions.y), length: CGFloat(object.dimensions.z), chamferRadius: 0)
            box.firstMaterial?.isDoubleSided = true
            box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
            let stringUUID = object.identifier.uuidString
            let boxNode = MaterialNode(type: .object, id: stringUUID)
            boxNode.geometry = box
            //                let boxNode = SCNNode(geometry: box)
            boxNode.simdTransform = object.transform
            boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            node.addChildNode(boxNode)
        }
        
    }
    func addDoors(addDoorsTO node : SCNNode){
        let doors = room.doors
        for door in doors{
            let box = SCNBox(width: CGFloat(door.dimensions.x), height: CGFloat(door.dimensions.y), length: CGFloat(door.dimensions.z)+0.01, chamferRadius: 0)
            box.firstMaterial?.isDoubleSided = true
            box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
            let stringUUID = door.identifier.uuidString
            let boxNode = MaterialNode(type: .door, id: stringUUID)
            boxNode.geometry = box
            //                let boxNode = SCNNode(geometry: box)
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
            box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
            let stringUUID = window.identifier.uuidString
            let boxNode = MaterialNode(type: .window, id: stringUUID)
            boxNode.geometry = box
            //                let boxNode = SCNNode(geometry: box)
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
            box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
            let stringUUID = opening.identifier.uuidString
            let boxNode = MaterialNode(type: .opening, id: stringUUID)
            boxNode.geometry = box
            //                let boxNode = SCNNode(geometry: box)
            boxNode.simdTransform = opening.transform
            boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            node.addChildNode(boxNode)
        }
        
    }
    
    
    
}
// MARK: - Touch / Pick node / Controls
extension BuildMyRoom {
    func pick(_ furnitureNode: MaterialNode) {
        //    if let inCurrentTeamHero = game.currentTeam?.heroes.first(where: { $0 == hero }) {
        //      // Pressed hero is in current team
        //      game.currentHero = hero
        //      hero.node.highlight()
        //    } else {
        //      // Hero is not allowed to be picked, it's another team's turn
        //      hero.node.highlight(with: .red, for: 0.1)
        //    }
        print(furnitureNode.type)
        switch furnitureNode.type {
        case .object:
            furnitureNode.highlight(with: .red, for: 0.5)
            selectedFurniture = furnitureNode
            pressedOnFurniture = true
            break;
        case .wall:
            pressedOnFurniture = false
            break;
        case .door:
            pressedOnFurniture = false
            break;
        case .opening:
            pressedOnFurniture = false
            break;
        case .window:
            pressedOnFurniture = false
            break;
        case .platForm:
            pressedOnFurniture = false
            break;
        }
        
        
    }
    func handleRightPad(dPad: GCControllerDirectionPad, xAxis: Float, yAxis: Float) {
        if xAxis == yAxis, xAxis == 0 {
            selectedFurniture?.physicsBody?.velocity = SCNVector3()
            selectedFurniture?.physicsBody?.mass = 0
            //        hero.node.physicsBody?.angularVelocity = SCNVector4()
            return
        }
        
        let velocity = SCNVector3(xAxis, 0, -yAxis) * furnitureSpeed
        if pressedOnFurniture {
            print("da5l hna")
            selectedFurniture!.physicsBody?.velocity = velocity
            selectedFurniture!.physicsBody?.mass = 1
        }
       
    }
}







