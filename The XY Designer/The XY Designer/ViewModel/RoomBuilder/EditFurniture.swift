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
}
