//
//  SceneToJson.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/04/2023.
//

import Foundation
import RoomPlan
import simd
import SceneKit
import FirebaseAuth

// By Salah And Joex
class SceneToJson {
    var specialID: String = ""
    struct V3Model : Encodable {
        let x: Float
        let y: Float
        let z: Float
    }
    typealias MatrixModel = [Float]
    struct CurveModel : Encodable {
        let startAngle: Double
        let endAngle: Double
        let radius: Float
    }
    typealias EdgesModel = [Bool]
    
//    struct stringModel: Encodable {
//        let string: String
//    }
    class GenericSurfaceModel : Encodable {
        let category: String
        let id: String
        let confidence: String
        let scale: V3Model
        let transform: MatrixModel
        let curve: CurveModel?
        let edges: EdgesModel
        let texture: String?
        let a3dModel: String?
        let color: String?
        init(_ category: String, _ id: String, _ confidence: String,
             _ scale: V3Model, _ transform: MatrixModel, _ curve: CurveModel?,
             _ edges: EdgesModel, _ texture: String?, _ a3dModel: String?, _ color: String?) {
            self.category = category
            self.id = id
            self.confidence = confidence
            self.scale = scale
            self.transform = transform
            self.curve = curve
            self.edges = edges
            self.a3dModel = a3dModel
            self.texture = texture
            self.color = color
        }
    }
    class DoorModel : GenericSurfaceModel {
        
        let isOpen: Bool
        
        init(_ id: String, _ confidence: String,
             _ scale: V3Model, _ transform: MatrixModel, _ curve: CurveModel?,
             _ edges: EdgesModel, _ texture: String?, _ isOpen: Bool, _ a3dModel: String?, _ color: String?) {
            self.isOpen = isOpen
            super.init("door", id, confidence, scale, transform, curve, edges, texture, a3dModel ,color)
        }
        
        private enum CodingKeys : String, CodingKey {
            case isOpen
        }
        
        override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(isOpen, forKey: .isOpen)
        }
        
    }
    class GenericObjectModel : Encodable {
        
        let id: String
        let category: String
        let confidence: String
        let scale: V3Model
        let transform: MatrixModel
        let texture: String?
        let a3dModel: String?
        let color: String?
        init(_ id: String, _ category: String, _ confidence: String,
             _ scale: V3Model, _ transform: MatrixModel, _ texture: String?, _ a3dModel: String?, _ color: String?) {
            self.id = id
            self.category = category
            self.confidence = confidence
            self.scale = scale
            self.transform = transform
            self.texture = texture
            self.a3dModel = a3dModel
            self.color = color
        }
        
    }
    class GenericSceneCreatedModel : Encodable {
        
        let id: String
        let category: String
        let transform: MatrixModel
        init(_ id: String, _ category: String, _ transform: MatrixModel) {
            self.id = id
            self.category = category
            self.transform = transform
        }
    }
    struct SceneModel : Encodable {
        let surfaces: [GenericSurfaceModel]
        let objects: [GenericObjectModel]
        let sceneCreatedModel: [GenericSceneCreatedModel]
        let dominantColors: [String : [String]]
        let specialID: String
    }
    func toModel(_ confidence: CapturedRoom.Confidence) -> String {
        switch confidence {
        case .high: return "high"
        case .medium: return "medium"
        case .low: return "low"
        default: return "unknown"
        }
    }
    func toModel (_ v3: simd_float3) -> V3Model {
        V3Model(x: v3.x, y: v3.y, z: v3.z)
    }
    func toModel (_ v3: SCNVector3) -> V3Model {
        V3Model(x: v3.x, y: v3.y, z: v3.z)
    }
    func toModel (_ matrix4: SCNMatrix4) -> MatrixModel {
        let matrix = simd_float4x4(matrix4)
        let (c1, c2, c3, c4) = matrix.columns
        return [
            c1.x, c1.y, c1.z, c1.w,
            c2.x, c2.y, c2.z, c2.w,
            c3.x, c3.y, c3.z, c3.w,
            c4.x, c4.y, c4.z, c4.w
        ]
    }
    func toModel (_ curve: CapturedRoom.Surface.Curve) -> CurveModel {
        CurveModel(startAngle: curve.startAngle.value,
                   endAngle: curve.endAngle.value,
                   radius: curve.radius)
    }
    
    func toModel (_ edges: Set<CapturedRoom.Surface.Edge>) -> EdgesModel {
        [
            edges.contains(.top),
            edges.contains(.right),
            edges.contains(.bottom),
            edges.contains(.left)
        ]
    }
    fileprivate func toModel(_ surface: MaterialNode) -> GenericSurfaceModel {
        let id = surface.UUID
        let confidence = toModel(surface.confidence)
        let scale = toModel(surface.dimenstions)
        let transform = toModel(surface.transform)
        let curve = surface.curve != nil ? toModel(surface.curve!) : nil
        let edges = toModel(surface.completedEdges)
        var doorType: Bool {
            if (surface.subSurfaceCategory == .door(isOpen: true)){
                return true
            }else{
                return false
            }
                
        }
        var texture: String? {
            if let text = surface.texture {
                return text
            }else{
                return nil
            }
        }
        var colorAplied: String? {
            if let color = surface.color {
                return color.hexString
            }else{
                return nil
            }
        }
        var a3dModel: String? {
            if let model = surface.a3dModel {
                return model
            }else{
                return nil
            }
        }
        func makeGeneric(of category: String) -> GenericSurfaceModel {
            specialID = Auth.auth().currentUser!.uid
            specialID += surface.UUID

           return GenericSurfaceModel(
                category,
                id ?? "00",
                confidence,
                scale,
                transform,
                curve,
                edges,
                texture,
                a3dModel,
                colorAplied)
        }
        
        func makeDoor(isOpen: Bool) -> DoorModel {
            DoorModel(
                id ?? "00",
                confidence,
                scale,
                transform,
                curve,
                edges,
                texture,
                doorType,
                a3dModel,
                colorAplied)
        }
            switch surface.type {
        case .door:
            return makeDoor(isOpen: doorType)
        case .opening:
            return makeGeneric(of: "opening")
        case .wall:
            return makeGeneric(of: "wall")
        case .window:
            return makeGeneric(of: "window")
        default:
            return makeGeneric(of: "unknown")
        }
    }
    func toModle (_ obj: MaterialNode) -> GenericObjectModel {
        
        let id = obj.UUID
        var confidence: String {
            if let conf = obj.confidence {
                return toModel(conf)
            }else{
                return "None"
            }
        }
        var scale: V3Model {
            if let sca = obj.dimenstions {
                return toModel(sca)
            }else{
                return toModel([0,0,0])
            }
        }
        let transform = toModel(obj.transform)
        var color: Any {
            if let surfaceColor = obj.color {
                return surfaceColor.hexString
            } else {
                return ""// Replace with your desired UIColor
            }
        }
        var a3dModel: String? {
            if let model = obj.a3dModel {
                return model
            }else{
                return nil
            }
        }
        var texture: String? {
            if let text = obj.texture {
                return text
            }else{
                return nil
            }
        }
        var colorAplied: String? {
            if let color = obj.color {
                return color.hexString
            }else{
                return nil
            }
        }
    
        func makeGeneric(of category: String) -> GenericObjectModel {
           GenericObjectModel(id ?? "00",
                               category,
                               confidence,
                               scale,
                               transform,
                               texture,
                               a3dModel,
                              colorAplied)
        }
        
        switch obj.subObjectCategory {
        case .bathtub: return makeGeneric(of: "bathtub")
        case .bed: return makeGeneric(of: "bed")
        case .chair: return makeGeneric(of: "chair")
        case .dishwasher: return makeGeneric(of: "dishwasher")
        case .fireplace: return makeGeneric(of: "fireplace")
        case .oven: return makeGeneric(of: "oven")
        case .refrigerator: return makeGeneric(of: "refrigirator")
        case .sink: return makeGeneric(of: "sink")
        case .sofa: return makeGeneric(of: "sofa")
        case .stairs: return makeGeneric(of: "stairs")
        case .storage: return makeGeneric(of: "storage")
        case .stove: return makeGeneric(of: "stove")
        case .table: return makeGeneric(of: "table")
        case .television: return makeGeneric(of: "television")
        case .toilet: return makeGeneric(of: "toilet")
        case .washerDryer: return makeGeneric(of: "washer/dryer")
        default: return makeGeneric(of: "unknown")
        }
        
    }
    func toModle (_ sceneCreatedModel: MaterialNode) -> GenericSceneCreatedModel {
        
        let id = sceneCreatedModel.UUID
        let transform = toModel(sceneCreatedModel.transform)
    
        func makeSceneCreatedModel(of category: String) -> GenericSceneCreatedModel {
            GenericSceneCreatedModel(id ?? "00", category, transform)
        }
        
        switch sceneCreatedModel.type {
        case .platForm: return makeSceneCreatedModel(of: "platform")
        default: return makeSceneCreatedModel(of: "unknownSceneCreatedModel")
        }
        
    }
    var surfaceNodesList: [MaterialNode] = []
    var objectNodesList: [MaterialNode] = []
    var sceneCreatedNodesList: [MaterialNode] = []
   

     func traverseSceneNodes(node: SCNNode) {
        // Check if the node has a name of "materialNode"
        if let materialNode = node as? MaterialNode  {
            // Append the node to the list
            if (materialNode.type == .wall || materialNode.type == .door || materialNode.type == .opening || materialNode.type == .window){
                surfaceNodesList.append(materialNode)
            }else if (materialNode.type == .platForm){
                sceneCreatedNodesList.append(materialNode)
            }else{
                objectNodesList.append(materialNode)
            }
            return
        }
        
        // Recursively call the function on all child nodes
        for childNode in node.childNodes {
            traverseSceneNodes(node: childNode)
        }
    }
    func toModel(_ scene: SCNScene, dominantColors : [String : [String]]) -> SceneModel {
        traverseSceneNodes(node: scene.rootNode)
       return SceneModel(surfaces: surfaceNodesList.map(toModel),
                        objects: objectNodesList.map(toModle),
                         sceneCreatedModel: sceneCreatedNodesList.map(toModle),
                         dominantColors: dominantColors,
                         specialID: specialID
       )
   }

     func encodeToJson(scene: SCNScene, dominantColors : [String : [String]]) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let model = toModel(scene, dominantColors: dominantColors)

        return try? encoder.encode(model)
    }
    func exportJson(to url: URL, scene: SCNScene, dominantColors : [String : [String]]) throws {
        if let json = self.encodeToJson(scene: scene, dominantColors: dominantColors) {
         try json.write(to: url)
        }
    }
    func shareFile(scene: SCNScene, dominantColors : [String : [String]]) {
        
        // Save the JSON data to a file in the app's documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("scene.json")
        try! exportJson(to: fileURL, scene: scene, dominantColors: dominantColors)
        
        // Present a share sheet to share the file
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
 
    func uploadFile(scene: SCNScene, dominantColors : [String : [String]], uploadScene: UploadScene) {
        
        // Save the JSON data to a file in the app's documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("scene.json")
        try! exportJson(to: fileURL, scene: scene, dominantColors: dominantColors)
//        UploadScene().uploadJSONAndAppendToArray(fileData: fileURL.dataRepresentation)
        if let fileData = try? Data(contentsOf: fileURL) {
            uploadScene.uploadJSONAndAppendToArray(fileData: fileData, id: specialID)
        } else {
            print("Error reading data from file at URL: \(fileURL)")
        }
        
    }

}



