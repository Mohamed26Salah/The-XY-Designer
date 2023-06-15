//
//  PrepareJsonToScene.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 25/04/2023.
//

import Foundation
import RoomPlan
import simd
import SceneKit
struct PrepareJsonToScene {
    let decodedScene: DecodeScene

//MARK: - Remember the curve for speed <3
    func specilaID() -> String{
        return decodedScene.specialID
    }
    func dominantColors() -> [String : [UIColor]] {
        let uIDominantRoomColors = decodedScene.dominantColors.mapValues { $0.compactMap { UIColor(hexString: $0) } }
        return uIDominantRoomColors
    }
    func sceneCreatedModel() -> [MaterialNode] {
        var arrayOfSceneCreatedNodes = [MaterialNode]()
        for nodeSceneCreated in decodedScene.sceneCreatedModel{
            let node = MaterialNode(type: returnNodeType(nodeType: nodeSceneCreated.category), id: nodeSceneCreated.id)
            node.transform =  convertToSCNMatrix4(from: nodeSceneCreated.transform) ?? createDefaultSCNMatrix4()
            arrayOfSceneCreatedNodes.append(node)
        }
        return arrayOfSceneCreatedNodes
    }
    func objectsModel() -> [MaterialNode] {
        var arrayOfObjectsNodes = [MaterialNode]()
        for nodeObject in decodedScene.objects {
            let node = MaterialNode(type: returnNodeType(nodeType: nodeObject.category),
                                    id: nodeObject.id,
                                    dimenstions: convertToSimdFloat3(from: nodeObject.scale),
                                    confidence: returnNodeConfidence(nodeConfidence: nodeObject.confidence),
                                    subObjectCategory: returnSubCategoryObjects(subCategoryObject: nodeObject.category)
            )
            checkColorTexture3DModel(node: node, color: nodeObject.color, texture: nodeObject.texture, a3dModel: nodeObject.a3DModel)
            node.transform = convertToSCNMatrix4(from: nodeObject.transform) ?? createDefaultSCNMatrix4()
            arrayOfObjectsNodes.append(node)
        }
        return arrayOfObjectsNodes

    }
    func surfacesModel() -> [MaterialNode] {
        var arrayOfSurfacesNodes = [MaterialNode]()
        for nodeSurface in decodedScene.surfaces {
            let node = MaterialNode(type: returnNodeType(nodeType: nodeSurface.category),
                                    id: nodeSurface.id,
                                    dimenstions: convertToSimdFloat3(from: nodeSurface.scale),
                                    confidence: returnNodeConfidence(nodeConfidence: nodeSurface.confidence)
            )
            checkColorTexture3DModel(node: node, color: nodeSurface.color, texture: nodeSurface.texture, a3dModel: nodeSurface.a3DModel)
            if let edges = nodeSurface.edges {
                node.completedEdges = convertBoolArrayToEdgeSet(boolArray: edges)
            }
            if (node.type == .door){
                if let doorCategory = nodeSurface.isOpen {
                    node.subSurfaceCategory = convertBoolToCategory(boolValue: doorCategory)
                }
            }
            node.transform = convertToSCNMatrix4(from: nodeSurface.transform) ?? createDefaultSCNMatrix4()
            arrayOfSurfacesNodes.append(node)
        }
        return arrayOfSurfacesNodes
    }
    func convertBoolToCategory(boolValue: Bool) -> CapturedRoom.Surface.Category {
        if boolValue {
            return .door(isOpen: true)
        } else {
            return .door(isOpen: false)
        }
    }
    func convertBoolArrayToEdgeSet(boolArray: [Bool]) -> Set<CapturedRoom.Surface.Edge> {
        var edgeSet = Set<CapturedRoom.Surface.Edge>()
        if boolArray.count == 4 {
            if boolArray[0] { edgeSet.insert(.top) }
            if boolArray[1] { edgeSet.insert(.right) }
            if boolArray[2] { edgeSet.insert(.bottom) }
            if boolArray[3] { edgeSet.insert(.left) }
        }
        return edgeSet
    }
    func checkColorTexture3DModel (node: MaterialNode ,color: String?, texture: String?, a3dModel: String?) {
        if let color = color {
            node.color = UIColor(hexString: color)
        }
        if let texture = texture {
            node.texture = texture
        }
        if let a3dModel = a3dModel {
            node.a3dModel = a3dModel
        }
    }
    func returnNodeConfidence(nodeConfidence: Confidence?) -> CapturedRoom.Confidence {
        switch nodeConfidence {
        case .high:
            return .high
        case .medium:
            return .medium
        case .low:
            return .low
        case .none:
            //This Shouldnt happen in AnyCase, just to shut the error of the switchCase
            return .medium
        }
    }
    func returnNodeType(nodeType: String) -> EntityType{
        switch nodeType {
        case "door":
            return EntityType.door
        case "window":
            return EntityType.window
        case "platform":
            return EntityType.platForm
        case "wall":
            return EntityType.wall
        default:
            return EntityType.object
        }
    }
    func returnSubCategoryObjects(subCategoryObject: String) -> CapturedRoom.Object.Category {
        switch subCategoryObject {
        case "bathtub":
            return .bathtub
        case "bed":
            return .bed
        case "chair":
            return .chair
        case "dishwasher":
            return .dishwasher
        case "fireplace":
            return .fireplace
        case "oven":
            return .oven
        case "refrigerator":
            return .refrigerator
        case "sink":
            return .sink
        case "sofa":
            return .sofa
        case "stairs":
            return .stairs
        case "storage":
            return .storage
        case "stove":
            return .stove
        case "table":
            return .table
        case "television":
            return .television
        case "toilet":
            return .toilet
        case "washerDryer":
            return .washerDryer
        default:
            //This Shouldnt happen in AnyCase, just to shut the error of the switchCase
            return .toilet
        }
    }
    func convertToSCNVector3(from scale: Scale) -> SCNVector3 {
        let floatX = Float(scale.x)
        let floatY = Float(scale.y)
        let floatZ = Float(scale.z)
        let simdFloat3 = simd_float3(floatX, floatY, floatZ)
        let scnVector3 = SCNVector3(simdFloat3)
        return scnVector3
    }

    func convertToSimdFloat3(from scale: Scale) -> simd_float3 {
        let floatX = Float(scale.x)
        let floatY = Float(scale.y)
        let floatZ = Float(scale.z)
        let simdFloat3 = simd_float3(floatX, floatY, floatZ)
        return simdFloat3
    }
    func convertToSCNMatrix4(from array: [Double]) -> SCNMatrix4? {
        guard array.count == 16 else {
            // The input array must contain exactly 16 values for a 4x4 matrix
            return nil
        }
        
        // Extract the values from the array
        let m11 = Float(array[0])
        let m12 = Float(array[1])
        let m13 = Float(array[2])
        let m14 = Float(array[3])
        let m21 = Float(array[4])
        let m22 = Float(array[5])
        let m23 = Float(array[6])
        let m24 = Float(array[7])
        let m31 = Float(array[8])
        let m32 = Float(array[9])
        let m33 = Float(array[10])
        let m34 = Float(array[11])
        let m41 = Float(array[12])
        let m42 = Float(array[13])
        let m43 = Float(array[14])
        let m44 = Float(array[15])
        
        // Create a SCNMatrix4 from the extracted values
        let matrix = SCNMatrix4(
            m11: m11, m12: m12, m13: m13, m14: m14,
            m21: m21, m22: m22, m23: m23, m24: m24,
            m31: m31, m32: m32, m33: m33, m34: m34,
            m41: m41, m42: m42, m43: m43, m44: m44
        )
        
        return matrix
    }
    func createDefaultSCNMatrix4() -> SCNMatrix4 {
        // Create a default SCNMatrix4
        let matrix = SCNMatrix4(
            m11: 1.0, m12: 0.0, m13: 0.0, m14: 0.0,
            m21: 0.0, m22: 1.0, m23: 0.0, m24: 0.0,
            m31: 0.0, m32: 0.0, m33: 1.0, m34: 0.0,
            m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0
        )
        
        return matrix
    }

    
}
