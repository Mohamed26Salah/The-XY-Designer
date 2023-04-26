//
//  RoomPlaneApi.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI
import RoomPlan

struct RoomCaptureViewRep : UIViewRepresentable
{
    func makeUIView(context: Context) -> some UIView {
        RoomCaptureController.instance.roomCaptureView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct ActivityViewControllerRep: UIViewControllerRepresentable {
    var items: [Any]
    var activities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewControllerRep>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: activities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewControllerRep>) {}
}

struct ScanningView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var captureController = RoomCaptureController.instance
    @EnvironmentObject var coordinator: Coordinator
    @ObservedObject var uploadScene: UploadScene = UploadScene()
    let data = ["key": "value"]
    
    var body: some View {
            ZStack(alignment: .bottom) {
                RoomCaptureViewRep()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: Button("Cancel") {
                        captureController.stopSession()
                        dismiss()
                    })
                    .navigationBarItems(trailing: Button("Done") {
                        captureController.stopSession()
                        captureController.showExportButton = true
                    }.opacity(captureController.showExportButton ? 0 : 1)).onAppear() {
                        captureController.showExportButton = false
                        captureController.startSession()
                    }
                VStack{
                    //                if let room = captureController.finalResult{
                    if captureController.roomIsReady{
                        Button {
                            let prepareRoom = PrepareRoomScanData(room: captureController.finalResult!, dominantRoomColors: captureController.roomColors)
                            let stringRoomColors = prepareRoom.dominantRoomColors.mapValues { $0.map { $0.hexString } }
                            SceneToJson().shareFile(scene: prepareRoom.scene, dominantColors: stringRoomColors)
                            SceneToJson().uploadFile(scene: prepareRoom.scene, dominantColors: stringRoomColors, uploadScene: uploadScene)
                        } label: {
                            Text("Save").font(.title2)
                        }
                        .buttonStyle(.borderedProminent).cornerRadius(40).opacity(1)
                        .padding()
                        
                    }
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
        //        Button(action: {
        //            captureController.export()
        //            dismiss()
        //        }, label: {
        //            Text("Export").font(.title2)
        //        }).buttonStyle(.borderedProminent).cornerRadius(40).opacity(captureController.showExportButton ? 1 : 0).padding().sheet(isPresented: $captureController.showShareSheet, content:{
        //            ActivityViewControllerRep(items: [captureController.exportUrl!])
        //        })
//    }
    
}
//}
//}
struct RoomPlaneApi: View {
    var body: some View {
        VStack {
            Image(systemName: "camera.metering.matrix")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Roomscanner").font(.title)
            Spacer().frame(height: 40)
            Text("Scan the room by pointing the camera at all surfaces. Model export supports usdz and obj format.")
            Spacer().frame(height: 40)
            //                ScanningView()
            NavigationLink(destination: ScanningView(), label: {Text("Start Scan")}).buttonStyle(.borderedProminent).cornerRadius(40).font(.title2)
        }
    }
}

struct RoomPlaneApi_Previews: PreviewProvider {
    static var previews: some View {
        RoomPlaneApi()
    }
}
