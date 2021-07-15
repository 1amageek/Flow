//
//  DemoApp.swift
//  Demo
//
//  Created by nori on 2021/06/21.
//

import SwiftUI
import Flow

@main
struct DemoApp: App {
    
    var body: some Scene {
//                WindowGroup {
//                    FlowCanvasView()
//                }
        DocumentGroup(newDocument: Graph()) { file in
            FlowCanvasView(file.$document)
        }
//        DocumentGroup(newDocument: TextFile()) { file in
//            ContentView(document: file.$document)
//        }
    }
}
