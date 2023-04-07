//
//  view3DRoomTemp.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/04/2023.
//

import SwiftUI
import _SceneKit_SwiftUI

struct view3DRoomTemp: View {
    var savedRoomModel = tempRoomStruct()
    var RoomModel: BuildMyRoom?
    @Environment(\.dismiss) var dismiss
    init() {

        if let savedRoom = savedRoomModel.retrieveRoomToUserDefaults(){
            if let room = savedRoom.room {
                RoomModel = BuildMyRoom(room: room)
            }
        }
    }
        var sceneRendererDelegate = SceneRendererDelegate()
        @State var lastCameraOffset = SCNVector3()
    
    var body: some View {
        ZStack (){
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
                    SceneView(scene: Room.scene, options: [.allowsCameraControl])
                        .gesture(drag)
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
        //Camera drag
              
    }
}


struct view3DRoomTemp_Previews: PreviewProvider {
    static var previews: some View {
        view3DRoomTemp()
    }
}
