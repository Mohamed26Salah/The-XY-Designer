import SwiftUI
import UIKit

struct ShareJSONView: UIViewRepresentable {
    let jsonData: Data

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if context.coordinator.documentInteractionController == nil {
            context.coordinator.documentInteractionController = UIDocumentInteractionController(url: writeJSONDataToFile())
            context.coordinator.documentInteractionController?.delegate = context.coordinator
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func writeJSONDataToFile() -> URL {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let fileURL = temporaryDirectory.appendingPathComponent("shared_json.json")
        do {
            try jsonData.write(to: fileURL)
        } catch {
            print("Failed to write JSON data to file: \(error.localizedDescription)")
        }
        return fileURL
    }

    class Coordinator: NSObject, UIDocumentInteractionControllerDelegate {
        var documentInteractionController: UIDocumentInteractionController?

        func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
            // Handle dismissal of the sharing menu, if needed
        }
    }
}
struct ContentView: View {
    let jsonData: Data // Your JSON data

    var body: some View {
        ShareJSONView(jsonData: jsonData)
            .edgesIgnoringSafeArea(.all)
    }
}
//    func calculatePlatformSize(fromWallPositions wallPositions: [SCNVector3]) -> SCNVector3 {
//        var minX = Float.greatestFiniteMagnitude
//        var maxX = -Float.greatestFiniteMagnitude
//        var minZ = Float.greatestFiniteMagnitude
//        var maxZ = -Float.greatestFiniteMagnitude
//
//        for position in wallPositions {
//            minX = min(minX, position.x)
//            maxX = max(maxX, position.x)
//            minZ = min(minZ, position.z)
//            maxZ = max(maxZ, position.z)
//        }
//
//        let width = maxX - minX
//        let length = maxZ - minZ
//
//        return SCNVector3(width, 0.1, length)
//    }
//    func createRoomPlane2(addPlanTo node: SCNNode){
//        for wall in room.walls {
//            let transform = wall.transform
//            let position = simd_float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
//            wallsPositionArray.append(SCNVector3(position))
//        }
//        let platFormPosition = calculatePlatformSize(fromWallPositions: wallsPositionArray)
//        let planeGeometry = SCNPlane(
//            width: CGFloat(platFormPosition.x)*1.5,
//            height: CGFloat(platFormPosition.z)*1.5)
//        planeGeometry.firstMaterial?.isDoubleSided = true
//        planeGeometry.firstMaterial?.diffuse.contents = Color.white.opacity(0.4)
//        //        planeGeometry.cornerRadius = 5
//        let stringUUID = String(6338)
//        let planeNode = MaterialNode(type: .platForm, id: stringUUID)
//        planeNode.geometry = planeGeometry
//        //        let planeNode = SCNNode(geometry: planeGeometry)
//        planeNode.geometry = planeGeometry
//        planeNode.position = SCNVector3(node.position.x, -1.5, node.position.z)
//        planeNode.eulerAngles = SCNVector3Make(Float.pi / 2, 0.5 ,0)
//        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//        node.addChildNode(planeNode)
//    }
  


/////////
//func retrieveImageFileURL(image: UIImage) -> URL? {
//    if let imageData = image.jpegData(compressionQuality: 1.0) {
//        let fileManager = FileManager.default
//        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//        let fileURL = documentsDirectory?.appendingPathComponent("image.jpg")
//        do {
//            try imageData.write(to: fileURL!)
//            return fileURL
//        } catch {
//            print("Error saving image to local file URL: \(error.localizedDescription)")
//        }
//    }
//    return nil
//}
//func createImageFromLocalFileURL(fileURL: URL) -> UIImage? {
//    return UIImage(contentsOfFile: fileURL.path)
//}
