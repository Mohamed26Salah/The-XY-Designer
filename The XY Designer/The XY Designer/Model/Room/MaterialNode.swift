//
//  MaterialNode.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 08/04/2023.
//


import SwiftUI
import SceneKit

class MaterialNode: SCNNode {
    var type: EntityType
    var UUID: String!
    
    init(type: EntityType, id: String? = nil) {
        self.type = type
        
        if id != nil {
            self.UUID = id
        }
        
        super.init()
        name = "Material Node (\(type)\(self.UUID ?? ""))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createMaterialNode(from node: SCNNode, type: EntityType, id: String) -> MaterialNode? {
        let materialNode = MaterialNode(type: type, id: id)
        materialNode.position = node.position
        materialNode.rotation = node.rotation
        materialNode.scale = node.scale
        materialNode.opacity = node.opacity
        
        // Copy over any child nodes
        for childNode in node.childNodes {
            if let childMaterialNode = createMaterialNode(from: childNode,type: type, id: id) {
                materialNode.addChildNode(childMaterialNode)
            } else {
                materialNode.addChildNode(childNode)
            }
        }
        
        return materialNode
    }
}
