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
class AddFurnitureViewModel: ObservableObject {
    let categoryOption = [
        "bathtub",
        "singleBed",
        "doubleBed",
        "chair",
        "dishwasher",
        "fireplace",
        "oven",
        "refrigerator",
        "sink",
        "sofa",
        "stairs",
        "storage",
        "wardrobe",
        "stove",
        "table",
        "television",
        "toilet",
        "washerDryer"
    ]
    @Published var xDimension: String = "1.0" {
        didSet {
            updateNodeDimensions()
        }
    }
    @Published var yDimension: String = "1.0" {
        didSet {
            updateNodeDimensions()
        }
    }
    @Published var zDimension: String = "1.0" {
        didSet {
            updateNodeDimensions()
        }
    }
    @Published var category: EntityType = .object
    @Published var subObjectCategory: CapturedRoom.Object.Category = .bathtub
    let node: SCNNode!
    var scene: SCNScene = SCNScene()
    var cameraNode = SCNNode()
    init() {
        node = SCNNode()
        node.position = SCNVector3(0,0,0)
        setupScene()
    }
    
    func setupScene() {
        furnitureNode(addTO: node)
        scene.rootNode.addChildNode(node)
        scene.background.contents = Color.white.opacity(0.3)
        prepareCamera()
    }
   
    func prepareCamera() {
        // Setup camera
        cameraNode = SCNNode()
        cameraNode.name = "CameraHuyamera"
        cameraNode.camera = SCNCamera()
        cameraNode.eulerAngles = SCNVector3(Float.pi / -6, 0, 0)
        cameraNode.camera?.fieldOfView = 40
        cameraNode.camera?.automaticallyAdjustsZRange = true

        let fieldCenter = node.position
        cameraNode.position = SCNVector3(fieldCenter.x + 2, fieldCenter.y + 2, fieldCenter.z + 5) // Move camera away from object
        cameraNode.look(at: fieldCenter)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func furnitureNode(addTO node : SCNNode){
        let dimenstions = convertStringToFloat()
        let box = SCNBox(width: CGFloat(dimenstions.x), height: CGFloat(dimenstions.y), length: CGFloat(dimenstions.z), chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
        let stringUUID = UUID().uuidString
        let boxNode = MaterialNode(type: category, id: stringUUID, dimenstions: dimenstions, confidence: .high, subObjectCategory: subObjectCategory)
        boxNode.geometry = box
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.mass = 0
        boxNode.physicsBody?.restitution = 1
        boxNode.physicsBody?.categoryBitMask = EntityType.object.rawValue
        boxNode.physicsBody?.collisionBitMask = EntityType.wall.rawValue
        boxNode.physicsBody?.contactTestBitMask = EntityType.object.rawValue | EntityType.wall.rawValue
//        boxNode.scale = SCNVector3(dimenstions.x, dimenstions.y, dimenstions.z)
        boxNode.confidence = .high
        node.addChildNode(boxNode)
    }
    func convertStringToFloat() -> simd_float3{
        return simd_float3(Float(xDimension)!,Float(yDimension)!,Float(zDimension)!)
    }
    func getNewFurniture() -> MaterialNode{
        return node.childNodes.first as! MaterialNode
    }
    private func updateNodeDimensions() {
        // Convert the string dimensions to floats
        guard let x = Float(xDimension), let y = Float(yDimension), let z = Float(zDimension) else {
            return
        }
        
        // Update the node dimensions
        //        node.childNodes.first!.scale = SCNVector3(x, y, z)
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5 // Set the animation duration to 0.5 seconds
        if let cubeNode = node.childNodes.first as? MaterialNode{
           cubeNode.dimenstions = simd_float3(x, y, z)
           cubeNode.scale = SCNVector3(x, y, z)
        }
        SCNTransaction.commit()
        
        // Notify SwiftUI that the object has changed
        objectWillChange.send()
    }
    func returnSubCategoryObjects(subCategoryObject: String) -> CapturedRoom.Object.Category {
        switch subCategoryObject {
        case "bathtub":
            defaultDimenstion(x: "0.75", y: "0.52", z: "1.6")
            changeSubObjectCategory(category: .bathtub)
            return .bathtub
        case "singleBed":
            defaultDimenstion(x: "0.9", y: "0.5", z: "1.9")
            changeSubObjectCategory(category: .bed)
            return .bed
        case "doubleBed":
            defaultDimenstion(x: "1.35", y: "0.5", z: "1.9")
            changeSubObjectCategory(category: .bed)
            return .bed
        case "chair":
            defaultDimenstion(x: "0.52", y: "0.84", z: "0.51")
            changeSubObjectCategory(category: .chair)
            return .chair
        case "dishwasher":
            defaultDimenstion(x: "0.6", y: "0.82", z: "0.6")
            changeSubObjectCategory(category: .dishwasher)
            return .dishwasher
        case "fireplace":
            defaultDimenstion(x: "1.04", y: "1.06", z: "0.5")
            changeSubObjectCategory(category: .fireplace)
            return .fireplace
        case "oven":
            defaultDimenstion(x: "0.59", y: "0.59", z: "0.53")
            changeSubObjectCategory(category: .oven)
            return .oven
        case "refrigerator":
            defaultDimenstion(x: "0.92", y: "1.9", z: "0.85")
            changeSubObjectCategory(category: .refrigerator)
            return .refrigerator
        case "sink":
            defaultDimenstion(x: "0.75", y: "1.8", z: "0.75")
            changeSubObjectCategory(category: .sink)
            return .sink
        case "sofa":
            defaultDimenstion(x: "1.52", y: "0.84", z: "1.02")
            changeSubObjectCategory(category: .sofa)
            return .sofa
        case "stairs":
            defaultDimenstion(x: "1", y: "4", z: "3")
            changeSubObjectCategory(category: .stairs)
            return .stairs
        case "storage":
            defaultDimenstion(x: "0.44", y: "1.4", z: "0.33")
            changeSubObjectCategory(category: .storage)
            return .storage
        case "wardrobe":
            defaultDimenstion(x: "1.2", y: "1.91", z: "0.6")
            changeSubObjectCategory(category: .storage)
            return .storage
        case "stove":
            defaultDimenstion(x: "0.76", y: "0.91", z: "0.72")
            changeSubObjectCategory(category: .stove)
            return .stove
        case "table":
            defaultDimenstion(x: "0.67", y: "0.75", z: "1.1")
            changeSubObjectCategory(category: .table)
            return .table
        case "television":
            defaultDimenstion(x: "1.11", y: "0.71", z: "0.25")
            changeSubObjectCategory(category: .television)
            return .television
        case "toilet":
            defaultDimenstion(x: "0.5", y: "0.66", z: "0.73")
            changeSubObjectCategory(category: .toilet)
            return .toilet
        case "washerDryer":
            defaultDimenstion(x: "0.6", y: "0.85", z: "0.6")
            changeSubObjectCategory(category: .washerDryer)
            return .washerDryer
        default:
            //This Shouldnt happen in AnyCase, just to shut the error of the switchCase
            defaultDimenstion(x: "0.5", y: "0.66", z: "0.73")
            changeSubObjectCategory(category: .toilet)
            return .toilet
        }
    }
    func getRightImage(for category: String) -> String{
        if (category == "doubleBed"){
            return "bed.double.fill"
        }else if (category == "singleBed"){
            return "single-bed"
        }else if (category == "stairs"){
            return "\(category)"
        }else if (category == "storage"){
            return "archivebox.fill"
        }else if (category == "wardrobe"){
            return "cabinet.fill"
        }else if (category == "television"){
            return "tv.fill"
            //Try tv bs
        }
        else if (category == "table"){
            return "table.furniture.fill"
        }
        else if (category == "washerDryer"){
            return "washer.fill"
        }else {
           return "\(category).fill"
        }
    }
    func defaultDimenstion(x:String, y: String, z: String){
        xDimension = x
        yDimension = y
        zDimension = z
    }
    func changeSubObjectCategory(category: CapturedRoom.Object.Category){
        if let cubeNode = node.childNodes.first as? MaterialNode{
            cubeNode.subObjectCategory = category
        }
    }
    func returnNewFurniture() -> MaterialNode {
        let cubeNode = (node.childNodes.first as! MaterialNode)
        return cubeNode
    }
}
