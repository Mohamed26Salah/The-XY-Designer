//
//  DecodeScene.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 25/04/2023.
//

import Foundation
import RoomPlan
import simd
import SceneKit

// MARK: - DecodeScene
struct DecodeScene: Codable {
    var sceneCreatedModel: [SceneCreatedModel]
    var specialID: String
    var dominantColors: [String: [String]]
    var surfaces: [Object]
    var objects: [Object]

    enum CodingKeys: String, CodingKey {
        case sceneCreatedModel = "sceneCreatedModel"
        case specialID = "specialID"
        case dominantColors = "dominantColors"
        case surfaces = "surfaces"
        case objects = "objects"
    }
}

// MARK: - Object
struct Object: Codable {
    var category: String
    var color: String?
    var confidence: Confidence?
    var id: String
    var a3DModel: String?
    var texture: String?
    var transform: [Double]
    var scale: Scale
    var edges: [Bool]?
    var isOpen: Bool?

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case color = "color"
        case confidence = "confidence"
        case id = "id"
        case a3DModel = "a3dModel"
        case texture = "texture"
        case transform = "transform"
        case scale = "scale"
        case edges = "edges"
        case isOpen = "isOpen"
    }
}

enum Confidence: String, Codable {
    case high = "high"
    case medium = "medium"
    case low = "low"
}

// MARK: - Scale
struct Scale: Codable {
    var x: Double
    var y: Double
    var z: Double

    enum CodingKeys: String, CodingKey {
        case x = "x"
        case y = "y"
        case z = "z"
    }
}

// MARK: - SceneCreatedModel
struct SceneCreatedModel: Codable {
    var id: String
    var category: String
    var transform: [Double]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case category = "category"
        case transform = "transform"
    }
}
@propertyWrapper public struct NilOnFail<T: Codable>: Codable {
    
    public let wrappedValue: T?
    public init(from decoder: Decoder) throws {
        wrappedValue = try? T(from: decoder)
    }
    public init(_ wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
}
