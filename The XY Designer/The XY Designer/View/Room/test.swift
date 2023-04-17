////
////  test.swift
////  The XY Designer
////
////  Created by Mohamed Salah on 16/04/2023.
////
//
//import SwiftUI
//import ARKit
//import SceneKit
//
//struct ARView: UIViewRepresentable {
//    let scene: SCNScene
//
//    func makeUIView(context: Context) -> ARSCNView {
//        let arView = ARSCNView()
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal, .vertical]
//
//        let doorNode = scene.rootNode.childNode(withName: "Door", recursively: true)!
//        let doorPosition = doorNode.convertPosition(SCNVector3Zero, to: nil)
//        configuration.initialWorldMap = makeWorldMap(for: doorPosition)
//
//        arView.session.run(configuration)
//        return arView
//    }
//
//    func updateUIView(_ uiView: ARSCNView, context: Context) {}
//
//    typealias UIViewType = ARSCNView
//
//    private func makeWorldMap(for position: SCNVector3) -> ARWorldMap {
//        let session = ARSession()
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal, .vertical]
//
//        let anchor = ARAnchor(transform: simd_float4x4(translation: [position.x, position.y, position.z]))
//        session.add(anchor: anchor)
//
//        let worldMap = session.currentFrame!.worldMap
//        session.setWorldOrigin(relativeTransform: anchor.transform)
//        return worldMap
//    }
//}
//
//struct ContentView: View {
//    let scene: SCNScene
//
//    var body: some View {
//        ARView(scene: scene)
//            .edgesIgnoringSafeArea(.all)
//    }
//}
//
