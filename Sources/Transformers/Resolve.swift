//
//  Resolve.swift
//  Transformers
//
//  Created by Jake Heiser on 9/12/17.
//

import Exec
import Regex
import Rainbow
import SwiftCLI

public extension TransformerPair {
    static var resolve: TransformerPair { return TransformerPair(out: Resolve(), err: nil) }
}

class Resolve: BaseTransformer {
    func go(stream: PipeStream) {
        if let action = stream.match(DependencyActionLine.self) {
            stdout <<< String(describing: action.action).capitalized.dim + " " + action.url
        } else if let resolve = stream.match(ResolveLine.self) {
            stdout <<< "Resolve ".dim + "\(resolve.url) at \(resolve.version)"
        } else {
            stream.consume()
        }
    }
}

// MARK: - Lines

final class DependencyActionLine: Matcher, Matchable {
    enum Action: String, Capturable {
        case fetch = "Fetching"
        case update = "Updating"
        case clone = "Cloning"
    }
    static let regex = Regex("(Fetching|Updating|Cloning) ([^ ]+)$")
    var action: Action { return captures[0] }
    var url: String { return captures[1] }
}

final class ResolveLine: Matcher, Matchable {
    static let regex = Regex("Resolving ([^ ]+) at (.*)$")
    var url: String { return captures[0] }
    var version: String { return captures[1] }
}
