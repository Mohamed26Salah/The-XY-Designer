//
//  BuildRoom3DModels.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 13/04/2023.
//

import Foundation
import SceneKit
import SwiftUI

class BuildRoom3DModels {
    func Model3dURL(name: String, extenstion: String) -> SCNScene{
        let subName = String(name.dropLast(5))
        guard let url = Bundle.main.url(forResource: subName, withExtension: extenstion) else {
            fatalError("failed to laod scene from url")
           
        }
        guard let modelScene = try? SCNScene(url: url, options: nil) else {
            fatalError("failed to laod scene from url")
        }
        return modelScene
    }
    func extractPositionFromTransform(transform: simd_float4x4, farFromWall: Bool) -> simd_float3{
        if (farFromWall){
            let position = simd_float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            return position
        }else{
            let position = simd_float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            return position
        }
    }
    func extractRotationFromTransform(transform: simd_float4x4) -> Float{
        let rotation = simd_float3x3(
            simd_float3(transform[0, 0], transform[0, 1], transform[0, 2]),
            simd_float3(transform[1, 0], transform[1, 1], transform[1, 2]),
            simd_float3(transform[2, 0], transform[2, 1], transform[2, 2])
        )
        let yAngle = atan2(rotation[2, 0], rotation[2, 2])
       return yAngle
    }
    func extractRotationFromTransform2(transform: simd_float4x4) -> Float {
        let rotationY = asin(transform[2][0])
        return rotationY
    }
    func minMaxNode(node: SCNNode) -> (min: SCNVector3, max: SCNVector3){
        let (min, max) = node.boundingBox
        return (min,max)
    }
    func nodeScaleZX(node: SCNNode,desiredDimenstions:simd_float3)->SCNVector3{
        let oDimenstion = minMaxNode(node: node)
        let modelOrignalDimensions = SCNVector3(oDimenstion.max.z - oDimenstion.min.z, oDimenstion.max.y - oDimenstion.min.y, oDimenstion.max.x - oDimenstion.min.x)
        let scale = SCNVector3(desiredDimenstions) / modelOrignalDimensions
        return scale
    }
    func nodeScaleXZ(node: SCNNode,desiredDimenstions:simd_float3)->SCNVector3{
        let oDimenstion = minMaxNode(node: node)
        let modelOrignalDimensions = SCNVector3(oDimenstion.max.x - oDimenstion.min.x, oDimenstion.max.y - oDimenstion.min.y, oDimenstion.max.z - oDimenstion.min.z)
        var thickerObjectDimenstion = simd_float3(x: 0, y: 0, z: 0)
        thickerObjectDimenstion.x = desiredDimenstions.x
        thickerObjectDimenstion.y = desiredDimenstions.y
        thickerObjectDimenstion.z = desiredDimenstions.z + 0.05

        let scale = SCNVector3(thickerObjectDimenstion) / modelOrignalDimensions
        return scale
    }
    func checkIfXZAreSwapped(node:SCNNode)->Bool{
        if node.boundingBox.max.x < node.boundingBox.max.z {
            // The X and Z dimensions are swapped
            print("Swapped")
            print(node.boundingBox.max.x)
            print(node.boundingBox.max.z)
            return true
        }else{
            print("Not Swapped")
            print(node.boundingBox.max.x)
            print(node.boundingBox.max.z)
            return false
        }
    }
    func newPivot(node: SCNNode)->SCNMatrix4{
        let oDimenstion = minMaxNode(node: node)
        let center = SCNVector3((oDimenstion.min.x + oDimenstion.max.x) / 2.0, (oDimenstion.min.y + oDimenstion.max.y) / 2.0, (oDimenstion.min.z + oDimenstion.max.z) / 2.0)
         let requiredCenter = SCNMatrix4MakeTranslation(center.x, center.y, center.z)
        return requiredCenter
    }
    func calculateNewBoundingBox(node: SCNNode, desiredDimensions: simd_float3){
        let scale = nodeScaleZX(node: node, desiredDimenstions: desiredDimensions)
        let boundingBox = node.boundingBox
        let scaledMin = SCNVector3(boundingBox.min.x * scale.x, boundingBox.min.y * scale.y, boundingBox.min.z * scale.z)
        let scaledMax = SCNVector3(boundingBox.max.x * scale.x, boundingBox.max.y * scale.y, boundingBox.max.z * scale.z)
        let scaledBoundingBox = (min: scaledMin, max: scaledMax)
        node.boundingBox = scaledBoundingBox
    }
    func import3DModel(name:String,extenstion: String, desiredDimenstions: simd_float3, transform: simd_float4x4, farFromWall: Bool, matNode: MaterialNode)->SCNNode{
        let modelScene = Model3dURL(name: name, extenstion: extenstion)
        let position = extractPositionFromTransform(transform: transform,farFromWall: farFromWall)
        let yAngle = extractRotationFromTransform(transform: transform)
        let nodaArray = modelScene.rootNode.childNodes
        let node = SCNNode()
//        node.simdTransform = transform

        for childNode in nodaArray {
            node.addChildNode(childNode)
        }
        node.rotation = SCNVector4(0, 0, 0, 1)
//        if(checkIfXZAreSwapped(node: node)){
//            node.scale = nodeScaleZX(node: node, desiredDimenstions: desiredDimenstions)
//        }else{
//            node.scale = nodeScaleXZ(node: node, desiredDimenstions: desiredDimenstions)
//        }
        if(matNode.subObjectCategory == .bed){
            node.scale = nodeScaleZX(node: node, desiredDimenstions: desiredDimenstions)
        }else{
            node.scale = nodeScaleXZ(node: node, desiredDimenstions: desiredDimenstions)
        }
        node.pivot = newPivot(node: node)
        calculateNewBoundingBox(node: node, desiredDimensions: desiredDimenstions)
        node.position = SCNVector3(position)
        node.rotation = SCNVector4(0, yAngle , 0, 4.2)
        return node
    }

    func add3DModel(materialNode: MaterialNode, desiredDimenstions: simd_float3, transform: simd_float4x4, modelName: String, extenstion: String){
        let node = import3DModel(name: modelName, extenstion: extenstion, desiredDimenstions: desiredDimenstions, transform: transform, farFromWall: false, matNode: materialNode)
        materialNode.addChildNode(node)
    }
    func add3DModelReturn(materialNode: MaterialNode, desiredDimenstions: simd_float3, transform: simd_float4x4, modelName: String, extenstion: String)->SCNNode{
        let node = import3DModel(name: modelName, extenstion: extenstion, desiredDimenstions: desiredDimenstions, transform: transform, farFromWall: false, matNode: materialNode)
        return node
    }
   
    func addBed3DModelScene(materialNode: MaterialNode, dimenstions: simd_float3){
        if let scene = SCNScene(named: "Wooden_Bed.scn"){
            let rootNode = scene.rootNode
            for childNode in rootNode.childNodes {
                materialNode.addChildNode(childNode)
            }
            materialNode.scale = SCNVector3(dimenstions.x, dimenstions.y, dimenstions.z)
        }else {
            print("Coudnt Find the Scene")
        }
      
    }
}

//    func addSphereTOModels(node: SCNNode) -> SCNNode{
//        let sphere = SCNSphere(radius: 0.2)
//        sphere.firstMaterial?.isDoubleSided = true
//        sphere.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
////        let sphereNode = SCNNode(geometry: sphere)
//        let sphereNode = MaterialNode(type: .sphere)
//        sphereNode.geometry = sphere
//        sphereNode.position = SCNVector3(node.simdPosition.x, node.simdPosition.y + 1, node.simdPosition.z)
//        return sphereNode
//    }
