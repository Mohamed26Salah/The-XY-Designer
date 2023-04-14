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
        let url = Bundle.main.url(forResource: name, withExtension: extenstion)!
        guard let modelScene = try? SCNScene(url: url, options: nil) else {
            fatalError("failed to laod scene from url")
        }
        return modelScene
    }
    func extractPositionFromTransform(transform: simd_float4x4) -> simd_float3{
        let position = simd_float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
       return position
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
    func minMaxNode(node: SCNNode) -> (min: SCNVector3, max: SCNVector3){
        let (min, max) = node.boundingBox
        return (min,max)
    }
    func nodeScale(node: SCNNode,desiredDimenstions:simd_float3)->SCNVector3{
        let oDimenstion = minMaxNode(node: node)
        let modelOrignalDimensions = SCNVector3(oDimenstion.max.z - oDimenstion.min.z, oDimenstion.max.y - oDimenstion.min.y, oDimenstion.max.x - oDimenstion.min.x)
        let scale = SCNVector3(desiredDimenstions) / modelOrignalDimensions
        return scale
    }
    func newPivot(node: SCNNode)->SCNMatrix4{
        let oDimenstion = minMaxNode(node: node)
        let center = SCNVector3((oDimenstion.min.x + oDimenstion.max.x) / 2.0, (oDimenstion.min.y + oDimenstion.max.y) / 2.0, (oDimenstion.min.z + oDimenstion.max.z) / 2.0)
         let requiredCenter = SCNMatrix4MakeTranslation(center.x, center.y, center.z)
        return requiredCenter
    }
    func import3DModel(name:String,extenstion: String, desiredDimenstions: simd_float3, transform: simd_float4x4)->SCNNode{
        let modelScene = Model3dURL(name: name, extenstion: extenstion)
        let position = extractPositionFromTransform(transform: transform)
        let yAngle = extractRotationFromTransform(transform: transform)
        let nodaArray = modelScene.rootNode.childNodes
        let node = SCNNode()
        for childNode in nodaArray {
            node.addChildNode(childNode)
        }
        node.scale = nodeScale(node: node, desiredDimenstions: desiredDimenstions)
        node.pivot = newPivot(node: node)
        node.position = SCNVector3(position)
        node.rotation = SCNVector4(0, yAngle , 0, 4.2)
        return node
    }
    func addBed3DModel(materialNode: MaterialNode, desiredDimenstions: simd_float3, transform: simd_float4x4){
        let node = import3DModel(name: "Wooden_Bed", extenstion: "usdz", desiredDimenstions: desiredDimenstions, transform: transform)
        materialNode.addChildNode(node)


    }
    func addChair3DModel(materialNode: MaterialNode, desiredDimenstions: simd_float3, transform: simd_float4x4){
        let node = import3DModel(name: "Office_Chair", extenstion: "usdz", desiredDimenstions: desiredDimenstions, transform: transform)
        materialNode.addChildNode(node)
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

