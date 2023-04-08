//
//  View3DRoom.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/04/2023.
//

import SwiftUI
import RoomPlan
import SceneKit

struct View3DRoom: View {
    var room: CapturedRoom
    var RoomModel: BuildMyRoom
    var savedRoomModel: tempRoomStruct
    @Environment(\.dismiss) var dismiss
    init(room: CapturedRoom) {
        print("da5l elinit")
        self.room = room
        print("3da elroom")
//        self._RoomModel = StateObject(wrappedValue: BuildMyRoom(room: room))
        RoomModel = BuildMyRoom(room: room)
        savedRoomModel = tempRoomStruct(room: room)
        savedRoomModel.saveRoomToUserDefaults(room: room)
        
    }
//    var sceneRendererDelegate = SceneRendererDelegate()
//    @State var lastCameraOffset = SCNVector3()

    var body: some View {
        ZStack (){
            VStack (alignment: .leading){
                Button {
                    dismiss()
                } label: {
                    Image("x.circle.fill")
                        .font(.title3)
                }

                
                SceneView(scene: RoomModel.scene, options: [.allowsCameraControl,.autoenablesDefaultLighting])
                    .frame(width: UIScreen.main.bounds.width*0.75, height: UIScreen.main.bounds.height/3)
            }
        }
        
         //Camera drag
//        let drag = DragGesture()
//          .onChanged({ gesture in
//            if let camera = sceneRendererDelegate.renderer?.pointOfView {
//              let translation = gesture.translation
//              let translationVector = SCNVector3(translation.width * 0.05,
//                                                 0,
//                                                 translation.height * 0.05)
//              let dVector = lastCameraOffset - translationVector
//
//              let action = SCNAction.move(by: dVector, duration: 0.1)
//              camera.runAction(action)
//
//              lastCameraOffset = translationVector
//            }
//          })
//          .onEnded { gesture in
//            lastCameraOffset = SCNVector3()
//          }

//        ZStack {
//            Rectangle().foregroundColor(.red)
//            SceneView(
//                scene: SCNScene(named:  "Earth.usdz"),
//                options: [
//                    .temporalAntialiasingEnabled
//                ],
//                delegate: sceneRendererDelegate)
////            .onTapGesture { location in
////                pick(atPoint: location)
////            }
////            .gesture(drag)
//            // Make sure ignoresSafeArea is after touch handlers
//            // Otherwise, location will be wrong
//            .ignoresSafeArea()
//        }
    }
}










//
//struct View3DRoom_Previews: PreviewProvider {
//    static var previews: some View {
//        View3DRoom()
//    }
//}
