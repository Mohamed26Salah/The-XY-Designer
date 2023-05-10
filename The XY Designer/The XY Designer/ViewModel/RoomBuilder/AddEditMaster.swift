//
//  AddEditMaster.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/05/2023.
//

import SwiftUI
import SceneKit
import RoomPlan
class AddEditMaster: ObservableObject {
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
    var foundNode: MaterialNode?
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
    let node: SCNNode!
    var scene: SCNScene = SCNScene()
    var cameraNode = SCNNode()
    init() {
        node = SCNNode()
        node.position = SCNVector3(0,0,0)
        node.name = "Main"
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
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5  // Set the animation duration to 0.5 seconds
//        getTheMaterialNodeInTheScene(node: node)
//        if let cubeNode = node.childNodes.first as? MaterialNode {
//            cubeNode.scale = scaleWithoutA3dModel(node: cubeNode , x: x, y: y, z: z)
//            cubeNode.dimenstions = simd_float3(x, y, z)
//        }
//        if let cubeNode = foundNode {
////            applyScale(to: cubeNode, desiredDimenstions: simd_float3(x, y, z))
//
//        }
        if let cubeNode = node.childNodes.first as? MaterialNode{
            cubeNode.dimenstions = simd_float3(x, y, z)
            cubeNode.scale = SCNVector3(x, y, z)
        }
        SCNTransaction.commit()
        // Notify SwiftUI that the object has changed
        objectWillChange.send()
        //        print(convertStringToFloat())
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
    func applyScale(to node: MaterialNode, desiredDimenstions: simd_float3) {
        if(BuildRoom3DModels().checkIfXZAreSwapped(node: node)){
//            let scale = BuildRoom3DModels().nodeScaleZX(node: node, desiredDimenstions: desiredDimenstions)
//            if let child3dModel = node.childNodes.first {
//                child3dModel.scale = SCNVector3(scale.x,scale.y,scale.z)
//            }else {
               node.scale = BuildRoom3DModels().nodeScaleZX(node: node, desiredDimenstions: desiredDimenstions)
//            }
            
        }else{
//            let scale = BuildRoom3DModels().nodeScaleXZ(node: node, desiredDimenstions: desiredDimenstions)
//            if let child3dModel = node.childNodes.first {
//                child3dModel.scale = SCNVector3(scale.x,scale.y,scale.z)
//            }else {
                node.scale = BuildRoom3DModels().nodeScaleXZ(node: node, desiredDimenstions: desiredDimenstions)
//            }

        }
    }
    func scaleWithoutA3dModel(node: MaterialNode, x:Float, y: Float, z: Float) -> SCNVector3{
        let originalDimensions = node.boundingBox.max - node.boundingBox.min // Original dimensions
        let newDimensions = SCNVector3(x: x, y: y, z: z) // New dimensions

        let scale = SCNVector3(newDimensions.x / originalDimensions.x,
                               newDimensions.y / originalDimensions.y,
                               newDimensions.z / originalDimensions.z)

        return scale
    }
    

    func getParentIf3dModel(node: SCNNode) -> SCNNode? {
        var searchNode = node
        while searchNode.parent != nil && !(searchNode is MaterialNode) {
            searchNode = searchNode.parent!
        }
        if let materialNode = searchNode as? MaterialNode {
            return materialNode
        }
        return nil
    }
    func getTheMaterialNodeInTheScene(node: SCNNode){
        // Check if the node has a name of "materialNode"
        if let materialNode = node as? MaterialNode  {
            foundNode = materialNode
        }
        // Recursively call the function on all child nodes
        for childNode in node.childNodes {
            getTheMaterialNodeInTheScene(node: childNode)
        }
    }
}
