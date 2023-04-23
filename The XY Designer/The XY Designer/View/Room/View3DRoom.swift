//
//  view3DRoomTemp.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/04/2023.
//

import SwiftUI
import _SceneKit_SwiftUI
import GameController
import RoomPlan

struct view3DRoom: View {
    var savedRoomModel = tempRoomStruct()
    @ObservedObject var RoomModel: BuildMyRoom
    var room: CapturedRoom
    var dominantRoomColors: [String:[UIColor]]
    @Environment(\.dismiss) var dismiss
    var sceneRendererDelegate = SceneRendererDelegate()
    @State var lastCameraOffset = SCNVector3()
    @State private var selectedColor: Color = .red
    @State private var showingCredits = false
    @State private var isARPresented = false
    var superController = SuperController(elements: [GCInputRightThumbstick])
    init(room: CapturedRoom, dominantRoomColors: [String:[UIColor]]) {
        self.room = room
        self.dominantRoomColors = dominantRoomColors
//        let dominantRoomColorsUIColors = dominantRoomColors.mapValues { colors in
//            colors.toColorArray()
//        }
        self._RoomModel = ObservedObject(wrappedValue: BuildMyRoom(room: room,dominantRoomColors: dominantRoomColors))
        let stringRoomColors = dominantRoomColors.mapValues { $0.map { $0.hexString } }
//        savedRoomModel = tempRoomStruct(room: room,dominantRoomColors: stringRoomColors)
        savedRoomModel.saveRoomToUserDefaults(room: room,dominantRoomColors: stringRoomColors)
//        let roomColors = stringRoomColors.mapValues { $0.compactMap { UIColor(hexString: $0) } }
//        print("ROOM UIColors\(dominantRoomColors)")
//        print("ROOM StringColors\(stringRoomColors)")
//        print("ROOM BackToUIColor\(roomColors)")

    }
    var body: some View {
        let drag = DragGesture()
            .onChanged({ gesture in
                if let camera = sceneRendererDelegate.renderer?.pointOfView {
                    let translation = gesture.translation
                    let translationVector = SCNVector3(translation.width * 0.05,
                                                       0,
                                                       translation.height * 0.05)
                    let dVector = lastCameraOffset - translationVector
                    
                    let action = SCNAction.move(by: dVector, duration: 0.1)
                    camera.runAction(action)
                    
                    lastCameraOffset = translationVector
                }
            })
            .onEnded { gesture in
                lastCameraOffset = SCNVector3()
            }
        ZStack(alignment: .leading) {
            SceneView(scene: RoomModel.scene, options: [.allowsCameraControl],delegate: sceneRendererDelegate)
                .gesture(drag)
                .onTapGesture { location in
                    print(location)
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
                        Button("Spot Light", action: {
                            if let ambientLight = RoomModel.scene.rootNode.childNode(withName: "ambientLight", recursively: true) {
                                ambientLight.removeFromParentNode()
                               
                                RoomModel.spotLight()
                            }
                        })
                        Button("Ambient Light", action: {
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
                            .foregroundColor(.secondary.opacity(0.3))
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
                                    .foregroundColor(.secondary.opacity(0.3))
                            }
                    }
                    .padding()
                }
                Spacer()
                if (RoomModel.selectedFurnitureCanMove){
                    VStack(alignment: .center){
                        CustomTextField(customKeyboardChoice: .num, hint: "Degree", text: $RoomModel.angelRotation)
                            .background(Color.black)
                            .cornerRadius(10)
                        HStack(){
                            Button {
                                withAnimation {
                                    RoomModel.leftRotation()
                                }
                            } label: {
                                Image(systemName: "rotate.left")
                                    .font(.title3)
                            }
                            .foregroundColor(.primary)
                            .padding(.horizontal,25)
                            .padding(.vertical)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .foregroundColor(.secondary.opacity(0.3))
                            }
                            Button {
                                withAnimation {
                                    RoomModel.rightRotation()
                                }
                            } label: {
                                Image(systemName: "rotate.right")
                                    .font(.title3)
                            }
                            .foregroundColor(.primary)
                            .padding(.horizontal,25)
                            .padding(.vertical)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .foregroundColor(.secondary.opacity(0.3))
                            }
                        }
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.leading,20)
                    }
                    .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 4)
//                    .position(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height * 3 / 4)
                    .padding()
                   
                    
                }
            }
            
        }
        .onDisappear(perform: {
            superController.disconnect()
            sceneRendererDelegate.onEachFrame = nil
        })
        .onAppear(perform: {
            superController.connect()
            superController.handleRightPad = RoomModel.handleRightPad
            sceneRendererDelegate.onEachFrame = RoomModel.onEachFrame
        })
        .sheet(isPresented: $showingCredits) {
            if let selectedFurniture = RoomModel.selectedFurniture{
                EditNode(node: selectedFurniture, roomDominantColors: RoomModel.dominantRoomColors)
            }
        }
        .fullScreenCover(isPresented: $isARPresented) {
            ArRoomView(scene: RoomModel.scene, applySkyBoxAgain: RoomModel.lightSkyBox(), isARPresented: $isARPresented)
        }
        
        
    }
  
}

// MARK: - Managing Controls View

private extension view3DRoom {
    func clickedFeel(materialNode: MaterialNode){
        let scaleDownAction = SCNAction.scale(to: 0.9, duration: 0.25)
        let scaleUpAction = SCNAction.scale(to: 1.0, duration: 0.25)
        let sequenceAction = SCNAction.sequence([scaleDownAction, scaleUpAction])
        materialNode.runAction(sequenceAction)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    func pick(atPoint point: CGPoint) {
        // Find closest node
        if let firstNode = findParentNode(atPoint: point) {
            if let materialNode = firstNode as? MaterialNode  {
                if (materialNode.type == .platForm || materialNode.type == .opening){
                    return
                }
               clickedFeel(materialNode: materialNode)
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
struct view3DRoom_Previews: PreviewProvider {
    static var previews: some View {
        view3DRoomTemp()
    }
}


