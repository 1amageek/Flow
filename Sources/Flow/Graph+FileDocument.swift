//
//  Graph+FileDocument.swift
//  Graph+FileDocument
//
//  Created by nori on 2021/07/15.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension Graph: FileDocument {

    public static var readableContentTypes: [UTType] { [.graph] }

    public init(configuration: ReadConfiguration) throws {
        let data = configuration.file.regularFileContents!
        self = try JSONDecoder().decode(Self.self, from: data)
    }

    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
}
