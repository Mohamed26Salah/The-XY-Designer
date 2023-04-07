//
//  SceneRenderereDelegate.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/04/2023.
//

import SceneKit

// Hackest hack ever. And stupidest one!
// For handling touches in SceneView we need SCNSceneRenderer,
// but SwiftUI's SceneView don't provide it.
class SceneRendererDelegate: NSObject, SCNSceneRendererDelegate {
  var renderer: SCNSceneRenderer?
  var onEachFrame: (() -> ())? = nil

  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    if self.renderer == nil {
      self.renderer = renderer
      let type = type(of: renderer)

      print("HAHA GOT 'EM STUPID MACHINE! We got SceneRenderer: \(type)")
    }

    onEachFrame?()
  }
}
