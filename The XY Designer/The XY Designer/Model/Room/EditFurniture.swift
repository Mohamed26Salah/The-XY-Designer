//
//  EditFurniture.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 12/04/2023.
//

import Foundation
import SceneKit
import SwiftUI
class EditFurniture{
    func applyColor(to node: SCNNode, color: Color) {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(color)
        node.geometry?.materials = [material]
    }
    func applyTexture(to node: SCNNode, imageName: String) {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: imageName)
        node.geometry?.materials = [material]
    }
    func applyTextureFromGallery(to node: SCNNode, imageName: UIImage) {
        let material = SCNMaterial()
        material.diffuse.contents = imageName
        node.geometry?.materials = [material]
    }
    func apply3dModel(to node: MaterialNode, modelName: String, dimesntions: simd_float3, transform: SCNMatrix4, extenstion: String){
        var getOldPosition = SCNVector3(0,0,0)
        var getOldRotation: Float = 0.0
        let simd_float4x4Matrix = simd_float4x4(transform)
        let new3dModel = BuildRoom3DModels().add3DModelReturn(materialNode: node, desiredDimenstions: dimesntions, transform: simd_float4x4Matrix, modelName: modelName, extenstion: extenstion)
        if let firstChild = node.childNodes.first {
            getOldPosition = firstChild.position
        }
        for child in node.childNodes {
            child.removeFromParentNode()
            getOldRotation = child.eulerAngles.y  + .pi / 2
            
        }
        node.geometry = nil
        new3dModel.position = getOldPosition
        new3dModel.eulerAngles.y = getOldRotation
        node.addChildNode(new3dModel)
        //MARK: Can be Enhanced More!
    }
    func reset3dModel(to node: MaterialNode,dimesntions: simd_float3, transform: SCNMatrix4){
        for child in node.childNodes {
            child.removeFromParentNode()
        }
        let box = SCNBox(width: CGFloat(dimesntions.x), height: CGFloat(dimesntions.y), length: CGFloat(dimesntions.z)+0.01, chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        box.firstMaterial?.diffuse.contents = Color.DarkTheme.Violet.fieldColor.cgColor
        node.geometry = box
    }

}
