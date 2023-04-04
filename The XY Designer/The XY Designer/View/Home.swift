//
//  Home.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            Image(systemName: "house")
                .scaleEffect(3)
                .padding(30)
            Text("My home")
                .bold()
                .scaleEffect(2)
            
        }
        .navigationTitle("Salah")
        .toolbar(.hidden)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
