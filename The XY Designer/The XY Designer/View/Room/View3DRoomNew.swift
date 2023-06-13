//
//  View3DRoomNew.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 26/04/2023.
//

import SwiftUI
import _SceneKit_SwiftUI
import GameController
import RoomPlan
import SwiftUIJoystick
struct View3DRoomNew: View {
    @ObservedObject var RoomModel: BuildMyRoom
    @ObservedObject var uploadScene: UploadScene = UploadScene()
    @Environment(\.dismiss) var dismiss
    var sceneRendererDelegate = SceneRendererDelegate()
    @State var lastCameraOffset = SCNVector3()
    @State private var selectedColor: Color = .red
    @State private var showingCredits = false
    @State private var showingAddFurniture = false
    @State private var isARPresented = false
    @State private var typeOfMovement = true
//    @State private var rotationAngel: Float = 0.0
    var moniter = JoystickMonitor()
    private let draggableDiameter: CGFloat = 150
    @Environment(\.presentationMode) var presentationMode
    //    var superController = SuperController(elements: [GCInputRightThumbstick])
    init(link: String) {
        self._RoomModel = ObservedObject(wrappedValue: BuildMyRoom(link: link, sceneRD: sceneRendererDelegate))
    }
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .leading) {
                SceneView(scene: RoomModel.scene, options: [.allowsCameraControl,.autoenablesDefaultLighting],delegate: sceneRendererDelegate)
//                                .gesture(drag)
                    .onTapGesture { location in
                        //                    print(location)
                        pick(atPoint: location)
                        if (RoomModel.userChoice == .Customize){
                            if let selectedFurniture = RoomModel.selectedFurniture {
                                if (selectedFurniture.type != .platForm || selectedFurniture.type != .opening){
                                    showingCredits.toggle()
                                }
                            }
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                        
                    }
                    .ignoresSafeArea()
                VStack (alignment: .leading){
                    Section(){
                        Picker("UserChoice", selection: $RoomModel.userChoice) {
                            ForEach(UserChoices.allCases,id: \.self) { page in
                                Text(page.rawValue.capitalized)
                            }
                        }
                    }
                    .padding(20)
                    .pickerStyle(.segmented)
                    HStack{
                        Menu("Light") {
                            Button("Default Light", action: {
                                if let ambientLight = RoomModel.scene.rootNode.childNode(withName: "ambientLight", recursively: true) {
                                    ambientLight.removeFromParentNode()
                                }
                                if let spotLight = RoomModel.scene.rootNode.childNode(withName: "spotLight", recursively: true) {
                                    spotLight.removeFromParentNode()
                                    if let defaultLight = RoomModel.scene.rootNode.childNode(withName: "defaultLight", recursively: true){
                                        defaultLight.removeFromParentNode()
                                    }
                                }
                            })
                            Button("Spot Light", action: {
                                if (RoomModel.checkAllLight()){
                                    RoomModel.spotLight()
                                    return
                                }
                                if let ambientLight = RoomModel.scene.rootNode.childNode(withName: "ambientLight", recursively: true) {
                                    ambientLight.removeFromParentNode()
                                    RoomModel.spotLight()
                                }
                            })
                            Button("Ambient Light", action: {
                                if (RoomModel.checkAllLight()){
                                    RoomModel.ambientLight()
                                    return
                                }
                                if let spotLight = RoomModel.scene.rootNode.childNode(withName: "spotLight", recursively: true) {
                                    spotLight.removeFromParentNode()
                                    if let defaultLight = RoomModel.scene.rootNode.childNode(withName: "defaultLight", recursively: true){
                                        defaultLight.removeFromParentNode()
                                        RoomModel.ambientLight()
                                    }
                                }
                            })
                        }
                        .bold()
                        .foregroundColor(.primary)
                        .padding(.horizontal,18)
                        .padding(.vertical)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(.secondary.opacity(0.6))
                        }
                        .padding()
                        Spacer()
                        Button(action: { isARPresented = true }) {
                            Text("AR")
                                .bold()
                                .foregroundColor(.primary)
                                .padding(.horizontal,25)
                                .padding(.vertical)
                                .background{
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                        }
                        .padding()
                    }
                    HStack{
                        Button(action: {
                            if let room = RoomModel.room {
                                let stringRoomColors = room.dominantColors().mapValues { $0.map { $0.hexString } }
                                uploadScene.uploadFile(scene: RoomModel.scene,getSceneID: room.specilaID() ,dominantColors: stringRoomColors, withOptimization: true, checkName: false)
                                //                            presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("Optimize")
                                .bold()
                                .foregroundColor(.primary)
                                .padding(.horizontal,4)
                                .padding(.vertical)
                                .background{
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                        }
                        .padding()
                        Spacer()
                        Button(action: {
                            if let room = RoomModel.room {
                                let stringRoomColors = room.dominantColors().mapValues { $0.map { $0.hexString } }
                                //                            SceneToJson().shareFile(scene: RoomModel.scene, dominantColors: stringRoomColors)
                                //                            SceneToJson().uploadFile(scene: RoomModel.scene, dominantColors: stringRoomColors, uploadScene: uploadScene)
                                uploadScene.uploadFile(scene: RoomModel.scene,getSceneID: room.specilaID() ,dominantColors: stringRoomColors, withOptimization: false, checkName: false)
                            }
                        }) {
                            Text("Save")
                                .bold()
                                .foregroundColor(.primary)
                                .padding(.horizontal,17)
                                .padding(.vertical)
                                .background{
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                        }
                        .padding()
                    }
                    Spacer()
                    if (RoomModel.selectedFurnitureCanMove){
                        Controls(typeOfMovement: $typeOfMovement, RoomModel: RoomModel, moniter: moniter, draggableDiameter: draggableDiameter, geometry: geometry)
                    }
                }
                .alert(uploadScene.errorMessage, isPresented: $uploadScene.showError) {
                }
                HStack{
                    Spacer()
                    if uploadScene.showLoading {
                        ProgressView()
                            .tint(.primary)
                            .foregroundColor(.secondary)
                            .scaleEffect(3)
                        
                    }
                    Spacer()
                }
            }
            .sheet(isPresented: $showingCredits) {
                if let selectedFurniture = RoomModel.selectedFurniture{
                    if let selectedRoom = RoomModel.room {
//                        EditNode(node: selectedFurniture, roomDominantColors: selectedRoom.dominantColors())
                        EditNodeNew(nodeToBeEdited: selectedFurniture, dominantColors: selectedRoom.dominantColors())
                    }
                }
            }
            .sheet(isPresented: $showingAddFurniture) {
                if let selectedRoom = RoomModel.room {
                    AddFurniture(mainNode: RoomModel.node, dominantColors: selectedRoom.dominantColors())
                }
            }
            .fullScreenCover(isPresented: $isARPresented) {
                ArRoomView(scene: RoomModel.scene, applySkyBoxAgain: RoomModel.lightSkyBox(), isARPresented: $isARPresented)
            }
            .onAppear(perform: {
                //            superController.connect()
                //            superController.handleRightPad = RoomModel.handleRightPad
                sceneRendererDelegate.onEachFrame = RoomModel.onEachFrame
            })
            .onDisappear(perform: {
                //            superController.disconnect()
                sceneRendererDelegate.onEachFrame = nil
            })
            .toolbar {
                Button(action: {
                    showingAddFurniture.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                }
            }
            
        }
    }
    
    
}

// MARK: - Managing Controls View

private extension View3DRoomNew {
//    func clickedFeel(materialNode: MaterialNode){
//        let scaleDownAction = SCNAction.scale(to: 0.9, duration: 0.25)
//        let scaleUpAction = SCNAction.scale(to: 1.0, duration: 0.25)
//        let sequenceAction = SCNAction.sequence([scaleDownAction, scaleUpAction])
//        materialNode.runAction(sequenceAction)
//        UIImpactFeedbackGenerator(style: .light).impactOccurred()
//    }
    func pick(atPoint point: CGPoint) {
        // Find closest node
        if let firstNode = findParentNode(atPoint: point) {
            if let materialNode = firstNode as? MaterialNode  {
                if (materialNode.type == .platForm || materialNode.type == .opening){
                    return
                }
                BuildMyRoomAssistant().clickedFeel(materialNode: materialNode)
                
                withAnimation {
                    RoomModel.pick(materialNode)
                }
            } else {
                print("Touched node is not material:", firstNode.name ?? "<NO NAME>")
                return
            }
        }
    }
    func findFirstNode(atPoint point: CGPoint) -> SCNNode? {
        guard let sceneRenderer = sceneRendererDelegate.renderer else {
            print("There is no SceneRenderer!")
            return nil
        }
        
        let hitResults = sceneRenderer.hitTest(point, options: [:])
        
        if hitResults.count == 0 {
            // check that we clicked on at least one object
            return nil
        }
        
        // retrieved the first clicked object
        let hitResult = hitResults[0]
        
        return hitResult.node
    }
    func findParentNode(atPoint point: CGPoint) -> SCNNode? {
        guard let sceneRenderer = sceneRendererDelegate.renderer else {
            print("There is no SceneRenderer!")
            return nil
        }
        let hitResults = sceneRenderer.hitTest(point, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]
            var node = result.node
            while node.parent != nil && !(node is MaterialNode) {
                node = node.parent!
            }
            if let materialNode = node as? MaterialNode {
                return materialNode
            }
        }
        return nil
    }
    func findFirstTouchableNode(atPoint point: CGPoint) -> SCNNode? {
        guard let sceneRenderer = sceneRendererDelegate.renderer else {
            print("There is no SceneRenderer!")
            return nil
        }
        
        let options: [SCNHitTestOption : Any] = [SCNHitTestOption.searchMode: SCNHitTestSearchMode.all.rawValue]
        let hitResults = sceneRenderer.hitTest(point, options: options)
        
        if hitResults.count == 0 {
            // check that we clicked on at least one object
            return nil
        }
        
        // retrieved the first clicked object
        let hitResult = hitResults.first { $0.node.physicsBody != nil }
        
        return hitResult?.node
    }
    
}

//struct View3DRoomNew_Previews: PreviewProvider {
//    static var previews: some View {
//        View3DRoomNew()
//    }
//}
