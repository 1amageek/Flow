//
//  File.swift
//  File
//
//  Created by nori on 2021/07/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

final public class FlowDocument: ReferenceFileDocument {

    public typealias Snapshot = Flow

    @Published public var flow: Flow

    public static var readableContentTypes: [UTType] { [.flow] }

    public func snapshot(contentType: UTType) throws -> Flow { flow }

    public func fileWrapper(snapshot: Flow, configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(snapshot)
        return FileWrapper(regularFileWithContents: data)
    }

    public init(configuration: ReadConfiguration) throws {
        let data = configuration.file.regularFileContents!
        self.flow = try JSONDecoder().decode(Flow.self, from: data)
    }
}
