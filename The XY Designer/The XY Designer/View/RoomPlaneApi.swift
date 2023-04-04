//
//  RoomPlaneApi.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI

struct RoomPlaneApi: View {
    var body: some View {
        VStack {
            Image(systemName: "square.split.bottomrightquarter")
                .scaleEffect(3)
                .padding(30)
            Text("My Room")
                .bold()
                .scaleEffect(2)
        }
    }
}

struct RoomPlaneApi_Previews: PreviewProvider {
    static var previews: some View {
        RoomPlaneApi()
    }
}
