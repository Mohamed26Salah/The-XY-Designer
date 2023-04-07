//
//  tempRoomStruct.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 07/04/2023.
//

import Foundation
import RoomPlan
struct tempRoomStruct: Codable {
    var room: CapturedRoom?
    
    func saveRoomToUserDefaults(room:CapturedRoom) {
        let roomToSave = tempRoomStruct(room: room)
        let userDefaults = UserDefaults.standard
        do {
            try userDefaults.setObject(roomToSave, forKey: "roomToSave")
        } catch {
            print(error.localizedDescription)
        }
    }
    func retrieveRoomToUserDefaults()->tempRoomStruct? {
        let userDefaults = UserDefaults.standard
        do {
            return try userDefaults.getObject(forKey: "roomToSave", castTo: tempRoomStruct.self)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
}
