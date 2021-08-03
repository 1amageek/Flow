//
//  ContentView.swift
//  ContentView
//
//  Created by nori on 2021/08/03.
//

import SwiftUI
import Flow

struct ContentView: View {

    @EnvironmentObject var document: FlowDocument

    var body: some View {
//        NavigationView {
//            List(selection: $document.selectedGraph) {
//                ForEach(document.flow.graphs) { graph in
//                    Text(graph.id)
//                        .tag(graph.id)
//                }
//            }
//            .onAppear {
//                print(document)
//            }
//
//            FlowCanvasView()
//        }
        FlowCanvasView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
