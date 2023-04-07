//
//  BuildMyRoom.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 06/04/2023.
//

import SceneKit
import SwiftUI
import RoomPlan

class BuildMyRoom {
    var scene: SCNScene = SCNScene()
    private let cameraHeight: Float = 15
    var room: CapturedRoom
    let node: SCNNode!
//    let roomParts = ConsturctTheRoom(Room: room)
//    var constructTheRoom: ConstructTheRoom

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
        let planeNode = SCNNode(geometry: planeGeometry)
        
        planeNode.geometry = planeGeometry
        planeNode.position = SCNVector3(node.position.x, -1.26, node.position.y)
        planeNode.eulerAngles = SCNVector3Make(Float.pi / 2, 0, 0)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        node.addChildNode(planeNode)
        
//        node.pivot = SCNMatrix4MakeTranslation(0, 0, 0);
//
//        cells.append(FieldCell(gameID: stringIndex, node: cell))
//        node.addChildNode(cell)

    }
    func addWalls(addWallsTO node : SCNNode){
         let walls = room.walls
            for wall in walls{
                let box = SCNBox(width: CGFloat(wall.dimensions.x), height: CGFloat(wall.dimensions.y), length: CGFloat(wall.dimensions.z), chamferRadius: 0)
                box.firstMaterial?.isDoubleSided = true
                box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.primary.cgColor
                let boxNode = SCNNode(geometry: box)
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
                let boxNode = SCNNode(geometry: box)
                boxNode.simdTransform = object.transform
                node.addChildNode(boxNode)
            }

    }
    func addDoors(addDoorsTO node : SCNNode){
         let doors = room.doors
            for door in doors{
                let box = SCNBox(width: CGFloat(door.dimensions.x), height: CGFloat(door.dimensions.y), length: CGFloat(door.dimensions.z)+0.01, chamferRadius: 0)
                box.firstMaterial?.isDoubleSided = true
                box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
                let boxNode = SCNNode(geometry: box)
                boxNode.simdTransform = door.transform
                node.addChildNode(boxNode)
            }

    }
    func addWindows(addWindowsTO node : SCNNode){
         let windows = room.windows
            for window in windows{
                let box = SCNBox(width: CGFloat(window.dimensions.x), height: CGFloat(window.dimensions.y), length: CGFloat(window.dimensions.z)+0.01, chamferRadius: 0)
                box.firstMaterial?.isDoubleSided = true
                box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
                let boxNode = SCNNode(geometry: box)
                boxNode.simdTransform = window.transform
                node.addChildNode(boxNode)
            }

    }
    func addOpennings(addOpenningsTO node : SCNNode){
         let openings = room.openings
            for opening in openings{
                let box = SCNBox(width: CGFloat(opening.dimensions.x), height: CGFloat(opening.dimensions.y), length: CGFloat(opening.dimensions.z), chamferRadius: 0)
                box.firstMaterial?.isDoubleSided = true
                box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
                let boxNode = SCNNode(geometry: box)
                boxNode.simdTransform = opening.transform
                node.addChildNode(boxNode)
            }

    }
    
    
    
}




