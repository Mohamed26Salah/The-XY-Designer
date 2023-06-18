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
    @Binding var selectedTab: Int
    var body: some View {
        VStack(alignment: .center) {
            Image("XY_V02")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 100)
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
                selectedTab = 0
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack(spacing: 15){
                    Text("Save Scene")
                        .fontWeight(.semibold)
                        .contentTransition(.identity)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal,25)
            .padding(.vertical)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color(hex: "#42C2FF"), Color(hex: "#00B4D8")]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(15)
            .padding(.top, 50)
//            Image("XY_V02")
//                .resizable()
//                .scaledToFit()
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
