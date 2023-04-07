//
//  RoomCaptureController.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 05/04/2023.
//


import Foundation
import RoomPlan

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
  
  required init?(coder: NSCoder) {
    fatalError("Not needed.")
  }
  
  func encode(with coder: NSCoder) {
    fatalError("Not needed.")
  }
}

