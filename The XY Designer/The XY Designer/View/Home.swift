//
//  Home.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 23/03/2023.
//

import SwiftUI
import FirebaseAuth
struct Home: View {
    @State private var showingCredits = false
    @State private var selectedColor: Color = .red

    let heights = stride(from: 0.1, through: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }
    var body: some View {
        VStack {
            Text(Auth.auth().currentUser?.uid ?? "No User")
            Image(systemName: "house")
                .scaleEffect(3)
                .padding(30)
            Text("My home")
                .bold()
                .scaleEffect(2)
            Button("Show Credits") {
                showingCredits.toggle()
            }
            .sheet(isPresented: $showingCredits) {
                ColorPicker("Steam Sama Turkey md5n", selection: $selectedColor)
                    .labelsHidden()
                    .padding()
                ColorPicker(selection: $selectedColor){
                    Label("Color Pallete", systemImage: "paintpalette")
                        .symbolVariant(.fill)
                        .padding(.leading, 8)
                }
            }
            
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
