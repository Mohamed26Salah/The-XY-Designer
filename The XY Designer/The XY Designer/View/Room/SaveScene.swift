//
//  SaveScene.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 27/04/2023.
//

import SwiftUI

struct SaveScene: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var uploadScene: UploadScene
    var captureController: RoomCaptureController
    var body: some View {
        VStack {
            Text("Enter the Scene Name")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
                Text("The scene name must be unique.")
                    .foregroundColor(.red)
            }
            
            CustomTextField(customKeyboardChoice: .name, hint: "Room Name", text: $uploadScene.sceneName)
                .padding(.top,50)
                .padding(.horizontal,10)
            
            Button {
                let prepareRoom = PrepareRoomScanData(room: captureController.finalResult!, dominantRoomColors: captureController.roomColors)
                let stringRoomColors = prepareRoom.dominantRoomColors.mapValues { $0.map { $0.hexString } }
                uploadScene.uploadFile(scene: prepareRoom.scene, dominantColors: stringRoomColors, withOptimization: false, checkName: true)
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack(spacing: 15){
                    Text("Save Scene")
                        .fontWeight(.semibold)
                        .contentTransition(.identity)
                }
            }
            .foregroundColor(.primary)
            .padding(.horizontal,25)
            .padding(.vertical)
            .background{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(.secondary.opacity(0.3))
            }
            .padding(.top, 50)
            Image("XY_V02")
                .resizable()
                .scaledToFit()
        }
        .onAppear{
            uploadScene.sceneName = ""
        }
    }
}
    //struct SaveScene_Previews: PreviewProvider {
    //    @Binding var sceneName: String
    //    static var previews: some View {
    //        SaveScene(sceneName: $sceneName)
    //    }
    //}
