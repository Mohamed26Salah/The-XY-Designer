//
//  view3DRoomTemp.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/04/2023.
//

import SwiftUI
import _SceneKit_SwiftUI
import GameController
struct view3DRoomTemp: View {
    var savedRoomModel = tempRoomStruct()
    var RoomModel: BuildMyRoom?
    @Environment(\.dismiss) var dismiss
    var sceneRendererDelegate = SceneRendererDelegate()
    @State var lastCameraOffset = SCNVector3()
    var superController = SuperController(elements: [GCInputRightThumbstick])
    init() {

        if let savedRoom = savedRoomModel.retrieveRoomToUserDefaults(){
            if let room = savedRoom.room {
                RoomModel = BuildMyRoom(room: room)
            }
        }
    }

    
    var body: some View {
        ZStack {
            VStack (alignment: .leading){
                Button {
                    dismiss()
                } label: {
                    Image("x.circle.fill")
                        .font(.title3)
                }
                
                
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
                if let Room = RoomModel {
                    SceneView(scene: Room.scene, options: [.allowsCameraControl],delegate: sceneRendererDelegate)
                        .gesture(drag)
                        .onTapGesture { location in
                          pick(atPoint: location)
                        }
                        .ignoresSafeArea()
                    
                    
                    //                    if let Room = RoomModel {
                    //                        SceneView(
                    //                            scene: Room.scene,
                    //                            options: [
                    //                                .temporalAntialiasingEnabled
                    //                            ],
                    //                            delegate: sceneRendererDelegate)
                    //                        //            .onTapGesture { location in
                    //                        //                pick(atPoint: location)
                    //                        //            }
                    //                        .gesture(drag)
                    //                        // Make sure ignoresSafeArea is after touch handlers
                    //                        // Otherwise, location will be wrong
                    //                        .ignoresSafeArea()
                    //                    }
                }
            }
        }
        .onDisappear(perform: {
          superController.disconnect()
//          sceneRendererDelegate.onEachFrame = nil
        })
        .onAppear(perform: {
          superController.connect()
            superController.handleRightPad = RoomModel?.handleRightPad
//          sceneRendererDelegate.onEachFrame = game.onEachFrame
        })
              
    }
}

// MARK: - Managing Controls View

private extension view3DRoomTemp {
    func pick(atPoint point: CGPoint) {
      print("Pick requested for point: \(point)")
      
      // Find closest node
      if let firstNode = findFirstTouchableNode(atPoint: point) {
          if let materialNode = firstNode as? MaterialNode  {
          withAnimation {
              RoomModel?.pick(materialNode)
          }
          print("Selected Furniture is \(String(describing: RoomModel?.selectedFurniture))")
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
struct view3DRoomTemp_Previews: PreviewProvider {
    static var previews: some View {
        view3DRoomTemp()
    }
}
