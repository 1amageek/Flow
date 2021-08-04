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

    @StateObject var store = FlowDocument.local()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(store)
        }

//        DocumentGroup(newDocument: { FlowDocument() }) { configuration -> ContentView in
//            return ContentView()
//        }

    }
}
