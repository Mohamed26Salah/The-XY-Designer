//
//  ViewRoom.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 12/06/2023.
//

import SwiftUI
import _SceneKit_SwiftUI
import GameController
import RoomPlan
import SwiftUIJoystick
struct ViewRoom: View {
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
    @State var show = false
    //Gesture Properties...
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @State var getGestureOffset: CGFloat = 0
    init(link: String) {
        self._RoomModel = ObservedObject(wrappedValue: BuildMyRoom(link: link, sceneRD: sceneRendererDelegate))
        UISegmentedControl.appearance().selectedSegmentTintColor = .darkGray
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    var body: some View {
        ZStack {
            GeometryReader { proxy in
//                let frame = proxy.frame(in: .global)
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
                VStack {
                    HStack{
                        Button(action: {
                            withAnimation {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Image(systemName: "multiply")
                                .font(.system(size: 25))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 5)
                            //                            .padding(.vertical)
                                .background{
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .foregroundColor(.secondary.opacity(0.6))
                                        .frame(width: 55, height: 45)
                                    BlurView(style: .systemThinMaterialDark)
                                        .cornerRadius(15)
                                }
                        }
                        .padding()
                        
                        Section(){
                            Picker("UserChoice", selection: $RoomModel.userChoice) {
                                ForEach(UserChoices.allCases,id: \.self) { page in
                                    Text(page.rawValue.capitalized)
                                }
                            }
                            .padding(20)
                            .pickerStyle(.segmented)
                        }
                        
                        Button(action: {
                            withAnimation {
                                show.toggle()
                                offset = 0
                            }
                        }) {
                            
                            Image(systemName: "list.bullet")
                                .font(.system(size: 25))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 5)
                                .rotationEffect(.degrees(180))
                            //                            .padding(.vertical)
                                .background{
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .foregroundColor(.secondary.opacity(0.6))
                                            .frame(width: 55, height: 45)
                                        BlurView(style: .systemThinMaterialDark)
                                            .cornerRadius(15)
                                    }
                                }
                        }
                        .padding()
                        
                    }
                    Spacer()
                    if (RoomModel.selectedFurnitureCanMove){
                        Controls(typeOfMovement: $typeOfMovement, RoomModel: RoomModel, moniter: moniter, draggableDiameter: draggableDiameter, geometry: proxy)
                    }
                }
            }
            .blur(radius: getBlurRadius())
            //             Bottom Sheet....
            if show {
                MenuList(offset: $offset, getgestureOffset: $getGestureOffset, show: $show, isARPresented: $isARPresented, RoomModel: RoomModel, uploadScene: uploadScene)
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
        
        .alert(uploadScene.errorMessage, isPresented: $uploadScene.showError) {
        }
        .navigationBarHidden(true)
    }
    func getBlurRadius()->CGFloat{
        let progress = -offset / (UIScreen.main.bounds.height - 100)
        return progress * 30
    }
}
// MARK: - Managing Controls View

private extension ViewRoom {
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

//struct ViewRoom_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewRoom()
//    }
//}
