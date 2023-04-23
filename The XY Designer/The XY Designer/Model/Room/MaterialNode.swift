//
//  MaterialNode.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 08/04/2023.
//


import SwiftUI
import SceneKit
import RoomPlan
//completed Edges
class MaterialNode: SCNNode {
    var type: EntityType
    var UUID: String!
    var dimenstions: simd_float3!
    var color: UIColor!
    var texture: String!
    var a3dModel: String!
    var confidence: CapturedRoom.Confidence!
    var subObjectCategory: CapturedRoom.Object.Category!
    var subSurfaceCategory: CapturedRoom.Surface.Category!
    var curve: CapturedRoom.Surface.Curve!
    var completedEdges: Set<CapturedRoom.Surface.Edge>!
    init(type: EntityType,
         id: String? = nil,
         dimenstions: simd_float3? = nil,
         color: UIColor? = nil,
         texture: String? = nil,
         a3dModel: String? = nil,
         confidence: CapturedRoom.Confidence? = nil,
         subObjectCategory: CapturedRoom.Object.Category? = nil,
         subSurfaceCategory: CapturedRoom.Surface.Category? = nil,
         curve: CapturedRoom.Surface.Curve? = nil,
         completedEdges: Set<CapturedRoom.Surface.Edge>? = nil
    )
    {
        self.type = type
        if dimenstions != nil {
            self.dimenstions = dimenstions
        }
        if id != nil {
            self.UUID = id
        }
        if color != nil {
            self.color = color
        }
        if texture != nil {
            self.texture = texture
        }
        if a3dModel != nil {
            self.a3dModel = a3dModel
        }
        if confidence != nil {
            self.confidence = confidence
        }
        if subObjectCategory != nil {
            self.subObjectCategory = subObjectCategory
        }
        if subSurfaceCategory != nil {
            self.subSurfaceCategory = subSurfaceCategory
        }
        if curve != nil {
            self.curve = curve
        }
        if completedEdges != nil {
            self.completedEdges = completedEdges
        }
        
        super.init()
        name = "Material Node (\(type)\(self.UUID ?? ""))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
