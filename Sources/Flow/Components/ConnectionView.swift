//
//  SwiftUIView.swift
//  
//
//  Created by nori on 2021/07/04.
//

import SwiftUI

public struct ConnectionView: View {

    var connection: Connection

    var start: CGPoint { connection.start }

    var end: CGPoint { connection.end }

    public init(_ connection: Connection) {
        self.connection = connection
    }

    public var body: some View {
        EdgeShape(start: start, end: end)
        .stroke(Color.black.opacity(0.2), lineWidth: 2)
    }
}
