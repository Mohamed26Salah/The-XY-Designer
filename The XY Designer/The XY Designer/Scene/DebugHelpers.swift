//
//  DebugHelpers.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 08/04/2023.
//

import SceneKit
import SwiftUI

extension SCNGeometry {
  static func line(from vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
    let indices: [Int32] = [0, 1]
    
    let source = SCNGeometrySource(vertices: [vector1, vector2])
    let element = SCNGeometryElement(indices: indices, primitiveType: .line)
    
    return SCNGeometry(sources: [source], elements: [element])
  }
}

extension UUID {
  static func short() -> String{
    return String(UUID().uuidString.prefix(6))
  }
}

