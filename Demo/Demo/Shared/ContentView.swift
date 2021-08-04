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

    @Environment(\.undoManager) var undoManager

    var body: some View {
        NavigationView {
            List(selection: $document.selectedGraph) {
                ForEach(document.cluster.graphs) { graph in
                    NavigationLink(tag: graph.id, selection: $document.selectedGraph, destination: {
                        FlowCanvasView()
                            .environmentObject(document)
                    }) {
                        HStack {
                            Text(graph.id)
                            Spacer()
                        }

                    }
                }
            }
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    document.add(graph: Graph(), undoManager: undoManager)
                }, label: {
                    Image(systemName: "plus")
                })
                Button(action: {
                    document.save()
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                })
            })

            Text("Empty ..")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
