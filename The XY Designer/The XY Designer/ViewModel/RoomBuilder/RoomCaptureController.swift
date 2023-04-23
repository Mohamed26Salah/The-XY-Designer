//
//  RoomCaptureController.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 05/04/2023.
//


import Foundation
import RoomPlan
import UIKit
import MobileCoreServices
import CoreImage
import ColorKit
class RoomCaptureController : ObservableObject, RoomCaptureViewDelegate, RoomCaptureSessionDelegate
{
    static var instance = RoomCaptureController()
    
    @Published var roomCaptureView: RoomCaptureView
    @Published var showExportButton = false
    @Published var showShareSheet = false
    @Published var exportUrl: URL?
    @Published var roomIsReady = false
    var sessionConfig: RoomCaptureSession.Configuration
    var finalResult: CapturedRoom?
//    @Published var roomColors: [String: [UIColor]] = [:]
    var roomColors: [String: [UIColor]] = [:]

    var openingsCounter = 0
    var windowsCounter = 0
    var doorsCounter = 0
    var objectsCounter = 0
    var wallsCounter = 0
    
    init() {
        roomCaptureView = RoomCaptureView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        sessionConfig = RoomCaptureSession.Configuration()
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
    }
    
    func startSession() {
        roomCaptureView.captureSession.run(configuration: sessionConfig)
    }
    
    func stopSession() {
        roomCaptureView.captureSession.stop()
    }
    func captureSession(_ session: RoomCaptureSession, didAdd room: CapturedRoom) {
        guard let currentFrame = roomCaptureView.captureSession.arSession.currentFrame else { return }
        let ciImage = CIImage(cvPixelBuffer: currentFrame.capturedImage)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        let uiImage = UIImage(cgImage: cgImage)
        if(room.walls.count != wallsCounter){
            do {
                let dominantColors = try uiImage.dominantColors()
                if let wall = room.walls.last {
                    roomColors["Wall+\(wall.identifier.uuidString)"] = dominantColors
                    wallsCounter = room.walls.count
                }

            }catch {
                print("Failed To Get Colors of walls")
            }
        }
        if(room.objects.count != objectsCounter){
            do {
                let dominantColors = try uiImage.dominantColors()
                if let object = room.objects.last {
                    roomColors["Object+\(object.identifier.uuidString)"] = dominantColors
                    objectsCounter = room.objects.count
                }
            }catch {
                print("Failed To Get Colors of object")
            }
        }
        if(room.doors.count != doorsCounter){
            do {
                let dominantColors = try uiImage.dominantColors()
                if let door = room.doors.last {
                    roomColors["Door+\(door.identifier.uuidString)"] = dominantColors
                    doorsCounter = room.doors.count
                }
            }catch {
                print("Failed To Get Colors of doors")
            }
        }
        if(room.windows.count != windowsCounter){
            do {
                let dominantColors = try uiImage.dominantColors()
                if let window = room.windows.last {
                    roomColors["Window+\(window.identifier.uuidString)"] = dominantColors
                    windowsCounter = room.windows.count
                }
            }catch {
                print("Failed To Get Colors of windows")
            }
        }
        if(room.openings.count != openingsCounter){
            do {
                let dominantColors = try uiImage.dominantColors()
                if let opening = room.openings.last {
                    roomColors["Opening+\(opening.identifier.uuidString)"] = dominantColors
                    openingsCounter = room.openings.count
                }
            }catch {
                print("Failed To Get Colors of openings")
            }
        }
    }
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }
    
    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResult = processedResult
        roomIsReady = true
    }
    func export() {
        exportUrl = FileManager.default.temporaryDirectory.appending(path: "scan.usdz")
        do {
            try finalResult?.export(to: exportUrl!)
        } catch {
            print("Error exporting usdz scan.")
            return
        }
        showShareSheet = true
    }
    func saveRoomTemp(){
        var savedRoomModel = tempRoomStruct()
        let stringRoomColors = roomColors.mapValues { $0.map { $0.hexString } }
        savedRoomModel.saveRoomToUserDefaults(room: finalResult!,dominantRoomColors: stringRoomColors)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not needed.")
    }
    
    func encode(with coder: NSCoder) {
        fatalError("Not needed.")
    }
}

