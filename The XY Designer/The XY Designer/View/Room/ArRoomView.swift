//
//  ArRoomView.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 16/04/2023.
//

import ARKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
    let scene: SCNScene
    static var applySkyBoxAgain: [UIImage] = [  UIImage(named: "AnyConv.com__miramar_ft.png")!,
                                                UIImage(named: "AnyConv.com__miramar_bk.png")!,
                                                UIImage(named: "AnyConv.com__miramar_up.png")!,
                                                UIImage(named: "AnyConv.com__miramar_dn.png")!,
                                                UIImage(named: "AnyConv.com__miramar_rt.png")!,
                                                UIImage(named: "AnyConv.com__miramar_lf.png")!]
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        arView.scene = scene
        // Configure AR options here
        return arView
    }
    

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    static func dismantleUIView(_ uiView: ARSCNView, coordinator: ()) {
        uiView.scene.background.contents = applySkyBoxAgain
        uiView.session.pause()
    }
}
struct ArRoomView: View {
    let scene: SCNScene
    let applySkyBoxAgain: [UIImage]
    @Binding var isARPresented: Bool

    var body: some View {
        VStack{
            HStack{
                Button(action: { isARPresented = false }) {
                    Text("Dismiss")
                }
                .padding()
                Spacer()
            }
        }
        ARViewContainer(scene: scene)
            .edgesIgnoringSafeArea(.all)
    }
}

//struct ArRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArRoomView()
//    }
//}
