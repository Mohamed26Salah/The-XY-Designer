//
//  SCNVector3+Extenstions.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/04/2023.
//

import SceneKit

extension SCNVector3 {
  static func distanceBetween(vector1: SCNVector3, vector2: SCNVector3) -> Double {
    let vectorBetween = vector1 - vector2
    let length = vectorBetween.length()
    return length
  }

  /**
   * Returns the length (magnitude) of the vector described by the SCNVector3
   */
  func length() -> Double {
    return Double(sqrt(x * x + y * y + z * z))
  }
}

/**
 * Adds two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

/**
 * Increments a SCNVector3 with the value of another.
 */
func += ( left: inout SCNVector3, right: SCNVector3) {
  left = left + right
}

/**
 * Subtracts two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

/**
 * Decrements a SCNVector3 with the value of another.
 */
func -= ( left: inout SCNVector3, right: SCNVector3) {
  left = left - right
}

/**
 * Multiplies two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

/**
 * Multiplies a SCNVector3 with another.
 */
func *= ( left: inout SCNVector3, right: SCNVector3) {
  left = left * right
}

/**
 * Multiplies the x, y and z fields of a SCNVector3 with the same scalar value and
 * returns the result as a new SCNVector3.
 */
func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
  return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}

/**
 * Multiplies the x and y fields of a SCNVector3 with the same scalar value.
 */
func *= ( vector: inout SCNVector3, scalar: Float) {
  vector = vector * scalar
}

/**
 * Divides two SCNVector3 vectors abd returns the result as a new SCNVector3
 */
func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 * Divides a SCNVector3 by another.
 */
func /= ( left: inout SCNVector3, right: SCNVector3) {
  left = left / right
}

/**
 * Divides the x, y and z fields of a SCNVector3 by the same scalar value and
 * returns the result as a new SCNVector3.
 */
func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
  return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}

/**
 * Divides the x, y and z of a SCNVector3 by the same scalar value.
 */
func /= ( vector: inout SCNVector3, scalar: Float) {
  vector = vector / scalar
}
