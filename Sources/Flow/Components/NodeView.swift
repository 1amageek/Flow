//
//  NodeView.swift
//
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public struct NodeView: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    var node: Node

    var cornerRadius: CGFloat = 12

    var position: CGPoint { context.nodes[node.id]?.position ?? .zero  }

    var offset: CGSize { context.nodes[node.id]?.offset ?? .zero  }

    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                context.nodes[node.id]?.offset = value.translation
            }
            .onEnded { value in
                let position = context.nodes[node.id]?.position ?? .zero
                context.nodes[node.id]?.offset = .zero
                context.nodes[node.id]?.position = CGPoint(
                    x: position.x + value.translation.width,
                    y: position.y + value.translation.height
                )
            }
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text(node.title)
                .padding(8)
            HStack(spacing: 8) {
                VStack {
                    ForEach(node.inputs) { port in
                        InputPortView(node: node, port: port, value: "\(0)")
                    }
                }
                VStack {
                    ForEach(node.outputs) { port in
                        OutputPortView(node: node, port: port, value: "\(0)")
                    }
                }
            }.padding(8)
        }
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.black, lineWidth: 4)
        )
        .overlay(
            context.focusNode?.id == node.id ?
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.blue, lineWidth: 4) : nil
        )
        .background(GeometryReader { proxy in
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
                .onAppear {
                    let frame = proxy.frame(in: .named(canvasCoordinateSpace))
                    context.nodes[node.id]?.size = proxy.size
                }
        })
        .frame(width: 260, alignment: .center)
        .coordinateSpace(name: node.id)
        .onTapGesture {
            self.context.focusNode = node
        }
        .position(position)
        .offset(offset)
        .gesture(gesture)
        .padding(12)

    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(node: Node(id: "0", title: "Function", position: .zero))
            .environmentObject(CanvasContext())
    }
}
