//
//  File.swift
//  File
//
//  Created by nori on 2021/07/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension FlowDocument: ReferenceFileDocument {

    // MARK: - ReferenceFileDocument

    public typealias Snapshot = Cluster

    public static var readableContentTypes: [UTType] { [.cluster] }

    public func snapshot(contentType: UTType) throws -> Cluster { cluster }

    public func fileWrapper(snapshot: Cluster, configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(snapshot)
        return FileWrapper(regularFileWithContents: data)
    }

    public convenience init(configuration: ReadConfiguration) throws {
        let data = configuration.file.regularFileContents!
        let docoder = JSONDecoder()
        docoder.dateDecodingStrategy = .iso8601
        let cluster = try docoder.decode(Cluster.self, from: data)
        self.init(cluster: cluster, addtionalFunctions: [])
    }
}
