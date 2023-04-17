//
//  tempRoomStruct.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/04/2023.
//

import Foundation
import RoomPlan
import UIKit
struct tempRoomStruct: Codable {
    var room: CapturedRoom?
    var dominantRoomColors: [String: [String]] = [:]
    func saveRoomToUserDefaults(room:CapturedRoom,dominantRoomColors: [String: [String]]) {
        let roomToSave = tempRoomStruct(room: room,dominantRoomColors: dominantRoomColors)
        let userDefaults = UserDefaults.standard
        do {
            try userDefaults.setObject(roomToSave, forKey: "roomToSaveColors")
        } catch {
            print(error.localizedDescription)
        }
    }
    func retrieveRoomToUserDefaults()->tempRoomStruct? {
        let userDefaults = UserDefaults.standard
        do {
            return try userDefaults.getObject(forKey: "roomToSaveColors", castTo: tempRoomStruct.self)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
}
//CurrentNames
//roomToSave
//roomToSaveColors
//ScanToDoctor
