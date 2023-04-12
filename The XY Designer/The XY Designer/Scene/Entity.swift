//
//  Entity.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 08/04/2023.
//

import Foundation

protocol Entity {
  var gameID: String { get }
  
  var node: MaterialNode { get }
}

enum EntityType: Int {
  case object = 1
  case wall
  case door
  case opening
  case window
  case platForm
}

enum UserChoices: String, CaseIterable{
    case Movement
    case Customize
}
