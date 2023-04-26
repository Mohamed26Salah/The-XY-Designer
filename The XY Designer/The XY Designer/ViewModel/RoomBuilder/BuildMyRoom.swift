//
//  BuildMyRoom.swift
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
import SwiftUIJoystick

struct BuildMyRoomConstants{
    static let cameraHeight: Float = 15
    static let furnitureSpeed: Float = 0.0005
    
}
class BuildMyRoom: ObservableObject {
    var room: PrepareJsonToScene?
    let link: String
    let node: SCNNode!
    var scene: SCNScene = SCNScene()
    var selectedFurniture: MaterialNode?
    var selectedFurniturePosition: SCNVector3?
    var oldFurniturePosition: SCNVector3?
    let contactDelegate = ContactDelegate()
    var cameraNode = SCNNode()
    @Published var angelRotation: String = "45"
    @Published var selectedFurnitureCanMove: Bool = false
    @Published var cameraRotation: CGFloat?
    @Published var userChoice: UserChoices = .Movement
    init(link: String) {
        node = SCNNode()
        self.link = link
        node.position = SCNVector3(0,0,0)
        JsonToScene().getJsonFile(url: link) { [weak self] returnedRoom, error in
            if let error = error {
                print(error.localizedDescription)
                // Handle error case, if needed
                return
            }
            if let returned = returnedRoom {
                self?.room = returned
                if (self?.room) != nil {
                    self?.setupScene()
                }
            } else {
                    // Handle error case, if needed
                }
        }
    }
    
}
// MARK: - Preparing Scene
extension BuildMyRoom {
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
        cameraNode.position = fieldCenter + SCNVector3(0, BuildMyRoomConstants.cameraHeight, BuildMyRoomConstants.cameraHeight / 2)
        cameraNode.look(at: fieldCenter)
        
        //    let centerConstraint = SCNLookAtConstraint(target: field.centerCell().node)
        //    cameraNode.constraints = [centerConstraint]
        
        scene.rootNode.addChildNode(cameraNode)
    }
    func center() -> SCNVector3 {
        return node.position
    }
}
private extension BuildMyRoom {
    func setupScene() {
        addSceneCreatedModels(addTO: node)
        addSurfaceModels(addTO: node)
        addObjectModels(addTO: node)
        scene.rootNode.addChildNode(node)
        scene.background.contents = Color.DarkTheme.Violet.background.cgColor
        scene.physicsWorld.contactDelegate = contactDelegate
        contactDelegate.onBegin = onContactBegin(contact:)
        scene.background.contents = lightSkyBox()
        prepareCamera()
        spotLight()
    }
    func addSceneCreatedModels(addTO node : SCNNode){
        if let room = room {
            for sceneCreatedModel in room.sceneCreatedModel(){
                if (sceneCreatedModel.type == .platForm) {
                    BuildMyRoomAssistant().addPlatform(node: node, platFormModel: sceneCreatedModel)
                }
            }
        }
    }
    func addSurfaceModels(addTO node : SCNNode){
        if let room = room {
            for surfaceModel in room.surfacesModel() {
                if (surfaceModel.type == .wall){
                    BuildMyRoomAssistant().addWalls(node: node, wallModel: surfaceModel)
                } else if(surfaceModel.type == .window){
                    BuildMyRoomAssistant().addWindows(node: node, windowModel: surfaceModel)
                } else if(surfaceModel.type == .door){
                    BuildMyRoomAssistant().addDoors(node: node, doorModle: surfaceModel)
                } else if(surfaceModel.type == .opening) {
                    BuildMyRoomAssistant().addOpenings(node: node, openingModle: surfaceModel)
                }
            }
        }
    }
    func addObjectModels(addTO node : SCNNode){
        if let room = room {
            for objectModel in room.objectsModel() {
                BuildMyRoomAssistant().addObjects(node: node, objectModel: objectModel)
            }
        }
    }
}
// MARK: - Touch / Pick node / Controls
extension BuildMyRoom {
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
                    let movementPosition = SCNVector3(xAxis, 0, -yAxis) * BuildMyRoomConstants.furnitureSpeed
                    if selectedFurnitureCanMove {
                        selectedFurniture.position += movementPosition
                        selectedFurniturePosition = selectedFurniture.position
                    }
                }
            }
        }
    }
    func handleJoyStick(xy: CGPoint) {
        if xy.x == xy.y, xy.x == 0 {
            if let selectedFurniture = selectedFurniture {
                selectedFurniture.position = selectedFurniturePosition ?? SCNVector3(x: 0, y: 0, z: 0)
                return
            }
            
        }else {
            if (xy.x != 0){
                if let selectedFurniture = selectedFurniture {
                    let movementPosition = SCNVector3(xy.x, 0, xy.y) * BuildMyRoomConstants.furnitureSpeed
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
                selectedFurniture.runAction(rotateAction)
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
                selectedFurniture.runAction(rotateAction)
            }
        }
    }
    
}
// MARK: - SCNPhysicsContact

private extension BuildMyRoom {
    func onContactBegin(contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA as! MaterialNode
        let nodeB = contact.nodeB as! MaterialNode
        
        if (nodeA.type == .object){
            DispatchQueue.main.async { [weak self] in
                if nodeA.childNodes.isEmpty {
                    if nodeB.childNodes.isEmpty{
                        if (nodeA.type != .platForm){
                            nodeA.highlight(with: .green, for: 0.05)
                        }
                        if (nodeB.type != .platForm){
                            nodeB.highlight(with: .red, for: 0.01)
                        }
                    }
                }
            }
            return
            
        }
        if(nodeB.type == .object) {
            DispatchQueue.main.async { [weak self] in
                if nodeA.childNodes.isEmpty {
                    if nodeB.childNodes.isEmpty{
                        if (nodeA.type != .platForm){
                            nodeA.highlight(with: .green, for: 0.05)
                        }
                        if (nodeB.type != .platForm){
                            nodeB.highlight(with: .red, for: 0.01)
                        }
                    }
                }
            }
            return
        }
        
        
    }
}
//MARK: - Update On Each Frame

extension BuildMyRoom {
    func onEachFrame(){
        //        print("Inside Frame")
        //        DispatchQueue.main.async { [self] in
        //Collison wa baz
        // Rotation also baz
        //        }
    }
}


//MARK: - Quality Of Life

extension BuildMyRoom {
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
//                if let nodeChild = selectedFurniture.childNodes.first{
//                    nodeChild.runAction(rotateAction)
//                }else{
//                    selectedFurniture.runAction(rotateAction)
//                }
