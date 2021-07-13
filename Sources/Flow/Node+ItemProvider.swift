//
//  Node+ItemProvider.swift
//  
//
//  Created by nori on 2021/07/13.
//

import Foundation
import UniformTypeIdentifiers

extension Node {

    public static let draggableType = UTType(exportedAs: "inc.stamp.flow.node")

    public var itemProvider: NSItemProvider {
        let provider = NSItemProvider()
        provider.registerDataRepresentation(forTypeIdentifier: Self.draggableType.identifier, visibility: .all) {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(self)
                $0(data, nil)
            } catch {
                $0(nil, error)
            }
            return nil
        }
        return provider
    }

    static func fromItemProviders(_ itemProviders: [NSItemProvider], completion: @escaping ([Node]) -> Void) {
        let typeIdentifier = Self.draggableType.identifier
        let filteredProviders = itemProviders.filter {
            $0.hasItemConformingToTypeIdentifier(typeIdentifier)
        }

        let group = DispatchGroup()
        var result: [Int: Node] = [:]

        for (index, provider) in filteredProviders.enumerated() {
            group.enter()
            provider.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { (data, error) in
                defer { group.leave() }
                guard let data = data else { return }
                let decoder = JSONDecoder()
                guard let node = try? decoder.decode(Node.self, from: data)
                else { return }
                result[index] = node
            }
        }

        group.notify(queue: .global(qos: .userInitiated)) {
            let nodes = result.keys.sorted().compactMap { result[$0] }
            DispatchQueue.main.async {
                completion(nodes)
            }
        }
    }

}
