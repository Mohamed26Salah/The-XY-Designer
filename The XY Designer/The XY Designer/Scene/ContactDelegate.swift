//
//  ContactDelegate.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 09/04/2023.
//

import SceneKit

class ContactDelegate: NSObject, SCNPhysicsContactDelegate {
  var onBegin: ((SCNPhysicsContact) -> ())? = nil

  func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    onBegin?(contact)
  }
}
