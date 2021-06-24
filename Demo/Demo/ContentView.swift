//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2021/06/21.
//

import SwiftUI
import Flow

struct ContentView: View {
    var body: some View {
        CanvasView()
//            .frame(width: 400, height: 400, alignment: .center)
            .background(Color.white)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
