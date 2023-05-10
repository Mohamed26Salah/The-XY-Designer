//
//  Router.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 10/05/2023.
//

import SwiftUI
class Router: ObservableObject{
    @Published var path = NavigationPath()
    func reset() {
        path = NavigationPath()
    }
}
