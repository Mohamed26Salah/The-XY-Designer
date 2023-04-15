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
    var dimenstions: simd_float3!
    
    init(type: EntityType, id: String? = nil, dimenstions: simd_float3? = nil) {
        self.type = type
        if dimenstions != nil {
            self.dimenstions = dimenstions
        }
        if id != nil {
            self.UUID = id
        }
        
        super.init()
        name = "Material Node (\(type)\(self.UUID ?? ""))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
