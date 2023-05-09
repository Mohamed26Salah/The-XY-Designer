//
//  EditFurniture.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 12/04/2023.
//

import Foundation
import SceneKit
import SwiftUI
import UIKit
class EditFurniture{
    func applyColor(to node: MaterialNode, color: Color) {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(color)
        node.geometry?.materials = [material]
        //For The Json
        node.texture = nil
        node.color = UIColor(color)
    }
    func applyTexture(to node: MaterialNode, imageName: String) {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: imageName)
        node.geometry?.materials = [material]
        //For The Json
        node.texture = imageName
        node.color = nil
    }
    func applyTextureFromGallery(to node: MaterialNode, imageName: UIImage) {
        let material = SCNMaterial()
        material.diffuse.contents = imageName
        node.geometry?.materials = [material]
        //For The Json
        if let imageLocation = imageName.retrieveImageFileURL() {
            node.texture = imageLocation.toString()
            node.color = nil
        }
        
    }
    func apply3dModel(to node: MaterialNode, modelName: String, dimesntions: simd_float3, extenstion: String){
        var getOldPosition = SCNVector3(0,0,0)
        var getOldRotation: Float = 0.0
        let simd_float4x4Matrix = simd_float4x4(node.transform)
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
        //For The Json
        node.a3dModel = modelName
        node.texture = nil
        node.color = nil
        //MARK: Can be Enhanced More!
    }
    func reset3dModel(to node: MaterialNode,dimesntions: simd_float3, transform: SCNMatrix4){
        for child in node.childNodes {
            child.removeFromParentNode()
        }
        let box = SCNBox(width: CGFloat(dimesntions.x), height: CGFloat(dimesntions.y), length: CGFloat(dimesntions.z)+0.01, chamferRadius: 0)
        box.firstMaterial?.isDoubleSided = true
        box.firstMaterial?.diffuse.contents = Color.white
        node.geometry = box
        //For The Json
        node.a3dModel = nil
    }

}
