//
//  BuildMyRoom2.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 06/04/2023.
//

import SceneKit
import SwiftUI
import RoomPlan
import GameController
import ColorKit
struct FurnitureConstants {
    static let cameraHeight: Float = 15
    static let furnitureSpeed: Float = 0.05
}

class BuildMyRoom2: ObservableObject {
    var scene: SCNScene = SCNScene()
    private let cameraHeight: Float = 15
    var room: CapturedRoom
    var dominantRoomColors: [String : [UIColor]]
    let node: SCNNode!
    var selectedFurniture: MaterialNode?
    var selectedFurniturePosition: SCNVector3?
    var selectedFurnitureRotation: SCNVector4?
    var oldFurniturePosition: SCNVector3?
    var furnitureSpeed: Float = 0.05
    let contactDelegate = ContactDelegate()
    var cameraNode = SCNNode()
    var wallsPositionArray = [SCNVector3]()
    @Published var angelRotation: String = "45"
    @Published var selectedFurnitureCanMove: Bool = false
    @Published var cameraRotation: CGFloat?
    @Published var userChoice: UserChoices = .Movement
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

// MARK: - Preparing Scene
extension BuildMyRoom2 {
    func spotLight(){
        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.light?.type = SCNLight.LightType.spot
        spotLight.light?.intensity = 200
        spotLight.position = node.position
        spotLight.light?.spotInnerAngle = 120
        spotLight.light?.spotOuterAngle = 120
        spotLight.light?.color = UIColor.white
        spotLight.light?.castsShadow = true
        spotLight.light?.automaticallyAdjustsShadowProjection = true
        spotLight.light?.shadowSampleCount = 32
        spotLight.light?.shadowRadius = 8
        spotLight.light?.shadowMode = .deferred
        spotLight.light?.shadowMapSize = CGSize(width: 2048, height: 2048)
        spotLight.light?.shadowColor = UIColor.black.withAlphaComponent(1)
        spotLight.position = SCNVector3(x: 0, y: 5, z: 0)
        spotLight.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        spotLight.name = "spotLight"
        scene.rootNode.addChildNode(spotLight)
        let ambientLightNode = defaultLightNode(mode: .ambient)
        ambientLightNode.name = "defaultLight"
        scene.rootNode.addChildNode(ambientLightNode)
    }
    func ambientLight(){
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        lightNode.name = "ambientLight"
        scene.rootNode.addChildNode(lightNode)
    }
    
}
// MARK: - Building Room Private
private extension BuildMyRoom2 {
    func prepareCamera() {
        // Setup camera
        cameraNode = SCNNode()
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

private extension BuildMyRoom2 {
    func setupScene() {
        addWalls(addWallsTO: node)
        addDoors(addDoorsTO: node)
        addWindows(addWindowsTO: node)
        addObjects(addObjectsTO: node)
        addOpennings(addOpenningsTO: node)
        createRoomPlane(addPlaneTO: node)
        //        createRoomPlane2(addPlanTo: node)
        scene.rootNode.addChildNode(node)
        scene.background.contents = Color.DarkTheme.Violet.background.cgColor
        scene.physicsWorld.contactDelegate = contactDelegate
        contactDelegate.onBegin = onContactBegin(contact:)
        scene.background.contents = lightSkyBox()
        prepareCamera()
        spotLight()
//                prepareLight3()

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
            boxNode.physicsBody?.mass = 0
            boxNode.physicsBody?.restitution = 0
            boxNode.physicsBody?.categoryBitMask = EntityType.wall.rawValue
            //            boxNode.physicsBody?.collisionBitMask = EntityType.wall.rawValue | EntityType.object.rawValue
            //            boxNode.physicsBody?.contactTestBitMask = EntityType.wall.rawValue | EntityType.object.rawValue
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
            boxNode.physicsBody?.mass = 0
            boxNode.physicsBody?.restitution = 1
            boxNode.physicsBody?.categoryBitMask = EntityType.object.rawValue
            boxNode.physicsBody?.collisionBitMask = EntityType.wall.rawValue
            boxNode.physicsBody?.contactTestBitMask = EntityType.object.rawValue | EntityType.wall.rawValue
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
// MARK: - Touch / Pick node / Controls
extension BuildMyRoom2 {
    //    func getSphereNode(from materialNode: MaterialNode) -> SCNNode? {
    //        for child in materialNode.childNodes {
    //            if let sphere = child as? MaterialNode {
    //                if (sphere.type == .sphere){
    //                    return child
    //                }
    //            }
    //        }
    //        return nil
    //    }
    func pick(_ furnitureNode: MaterialNode) {
        switch furnitureNode.type {
        case .object:
            furnitureNode.highlight(with: .red, for: 0.5)
            selectedFurniture = furnitureNode
            selectedFurniturePosition = selectedFurniture?.position ?? SCNVector3(x: 0, y: 0, z: 0)
            selectedFurnitureCanMove = true
            break;
        case .wall:
            selectedFurnitureCanMove = false
            furnitureNode.highlight(with: .red, for: 0.5)
            selectedFurniture = furnitureNode
            selectedFurniturePosition = selectedFurniture?.position ?? SCNVector3(x: 0, y: 0, z: 0)
            break;
        case .door:
            selectedFurnitureCanMove = true
            furnitureNode.highlight(with: .red, for: 0.5)
            selectedFurniture = furnitureNode
            selectedFurniturePosition = selectedFurniture?.position ?? SCNVector3(x: 0, y: 0, z: 0)
            break;
        case .opening:
            selectedFurnitureCanMove = false
            furnitureNode.highlight(with: .red, for: 0.5)
            selectedFurniture = furnitureNode
            selectedFurniturePosition = selectedFurniture?.position ?? SCNVector3(x: 0, y: 0, z: 0)
            break;
        case .window:
            selectedFurnitureCanMove = true
            furnitureNode.highlight(with: .red, for: 0.5)
            selectedFurniture = furnitureNode
            selectedFurniturePosition = selectedFurniture?.position ?? SCNVector3(x: 0, y: 0, z: 0)
            break;
        case .platForm:
            selectedFurnitureCanMove = false
            break;

        }
    }
    
    func handleRightPad(dPad: GCControllerDirectionPad, xAxis: Float, yAxis: Float) {
        oldFurniturePosition = selectedFurniture?.position
        
        if xAxis == yAxis, xAxis == 0 {
            if let selectedFurniture = selectedFurniture {
                selectedFurniture.position = selectedFurniturePosition ?? SCNVector3(x: 0, y: 0, z: 0)
                return
            }
            
        }else {
            if (xAxis != 0){
                if let selectedFurniture = selectedFurniture {
                    let movementPosition = SCNVector3(xAxis, 0, -yAxis) * furnitureSpeed
                    if selectedFurnitureCanMove {
                        selectedFurniture.position += movementPosition
                        selectedFurniturePosition = selectedFurniture.position
                    }
                }
            }
        }
    }
    func leftRotation() {
        var rotation = 0.0
        if let myDouble = Double(angelRotation) {
            let myCGFloat = CGFloat(myDouble)
            rotation = myCGFloat
        } else {
            print("Cannot convert string to CGFloat")
        }
        let rotationAngleRadians = rotation * .pi / 180
        if let selectedFurniture = selectedFurniture {
            if selectedFurnitureCanMove {
                let rotateAction = SCNAction.rotate(by: rotationAngleRadians, around: SCNVector3(0, 1, 0), duration: 0.5)
                if let nodeChild = selectedFurniture.childNodes.first{
                    nodeChild.runAction(rotateAction)
                    selectedFurniture.transform = nodeChild.transform
                    //Place of Error here becasue we cahnge the main Node inside MaterialNode
                }else{
                    selectedFurniture.runAction(rotateAction)
                    selectedFurniture.transform = selectedFurniture.transform
                }
                
            }
        }
    }

    func rightRotation() {
        var rotation = 0.0
        if let myDouble = Double(angelRotation) {
            let myCGFloat = CGFloat(myDouble)
            rotation = myCGFloat
        } else {
            print("Cannot convert string to CGFloat")
        }
        let rotationAngleRadians = rotation * .pi / 180
        if let selectedFurniture = selectedFurniture {
            if selectedFurnitureCanMove {
                let rotateAction = SCNAction.rotate(by: -rotationAngleRadians, around: SCNVector3(0, 1, 0), duration: 0.5)
                if let nodeChild = selectedFurniture.childNodes.first{
                    nodeChild.runAction(rotateAction)
                    selectedFurniture.transform = nodeChild.transform
                }else{
                    selectedFurniture.runAction(rotateAction)
                    selectedFurniture.transform = selectedFurniture.transform
                }
            }
        }
    }
    
}
// MARK: - SCNPhysicsContact

private extension BuildMyRoom2 {
    
    func onContactBegin(contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA as! MaterialNode
        let nodeB = contact.nodeB as! MaterialNode
        
        if (nodeA.type == .object){
            DispatchQueue.main.async { [weak self] in
                if nodeA.childNodes.isEmpty {
                    if nodeB.childNodes.isEmpty{
                        nodeB.highlight(with: .red, for: 0.01)
                        nodeA.highlight(with: .green, for: 0.05)
                    }
                }
                //                nodeA.position.x = oldPosition.x / 1.1
                //                nodeA.position.z = oldPosition.z / 1.1
            }
            return
            
        }
        if(nodeB.type == .object) {
            DispatchQueue.main.async { [weak self] in
                if nodeA.childNodes.isEmpty {
                    if nodeB.childNodes.isEmpty{
                        nodeB.highlight(with: .red, for: 0.01)
                        nodeA.highlight(with: .green, for: 0.05)
                    }
                }
                //                nodeB.position.x = oldPosition.x / 1.1
                //                nodeB.position.z = oldPosition.z / 1.1
            }
            return
        }
        
        
    }
}
//MARK: - Update On Each Frame

extension BuildMyRoom2 {
    func onEachFrame(){
        //        print("Inside Frame")
//        DispatchQueue.main.async { [self] in
            //Collison wa baz
            // Rotation also baz
//        }
    }
}


//MARK: - Quality Of Life

extension BuildMyRoom2 {
    func lightSkyBox() -> [UIImage] {
        var imageArray = [UIImage]()
        imageArray.append(UIImage(named: "AnyConv.com__miramar_ft.png")!)
        imageArray.append(UIImage(named: "AnyConv.com__miramar_bk.png")!)
        imageArray.append(UIImage(named: "AnyConv.com__miramar_up.png")!)
        imageArray.append(UIImage(named: "AnyConv.com__miramar_dn.png")!)
        imageArray.append(UIImage(named: "AnyConv.com__miramar_rt.png")!)
        imageArray.append(UIImage(named: "AnyConv.com__miramar_lf.png")!)
        
        return imageArray
    }
    func Model3dURL(name: String, extenstion: String) -> SCNScene{
        let url = Bundle.main.url(forResource: name, withExtension: extenstion)!
        guard let modelScene = try? SCNScene(url: url, options: nil) else {
            fatalError("failed to laod scene from url")
        }
        return modelScene
    }
}



