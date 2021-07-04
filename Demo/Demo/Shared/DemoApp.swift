//
//  DemoApp.swift
//  Demo
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

@main
struct DemoApp: App {

    @StateObject private var model = Model()

    var body: some Scene {
        WindowGroup {

            FlowCanvasView()

//            ContentView()
//                .environmentObject(model)
        }
    }
}