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
        NavigationView {
            List(selection: $document.selectedGraph) {
                ForEach(document.cluster.graphs) { graph in
                    NavigationLink(tag: graph.id, selection: $document.selectedGraph, destination: {
                        FlowCanvasView()
                    }) {
                        Text(graph.id)
                    }
                }
            }
            Text("aaa")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
