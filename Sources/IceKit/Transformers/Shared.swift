//
//  Extensions.swift
//  Transformers
//
//  Created by Jake Heiser on 9/12/17.
//

import Foundation
import PathKit
import Rainbow
import SwiftCLI

// MARK: - Extensions

extension String {
    var beautifyPath: String {
        let workingDirPrefix = FileManager.default.currentDirectoryPath
        if hasPrefix(workingDirPrefix) {
            return "." + String(self[index(startIndex, offsetBy: workingDirPrefix.count)...])
        }
        return self
    }
}

// MARK: - JSON

enum JSON {
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    static let decoder = JSONDecoder()
}

// MARK: - Codable

extension Decodable {
    
    static func load(from path: Path) -> Self? {
        if let data = try? path.read() {
            return try? JSON.decoder.decode(self, from: data)
        }
        return nil
    }
    
}

// MARK: - Lines

final class InternalErrorLine: Matcher, Matchable {
    static let regex = Regex("error: (.*)$")
    var message: String { return captures[0] }
    
    func print(to out: WritableStream) {
        out <<< ""
        out <<< "Error: ".bold.red + message
        out <<< ""
    }
}

final class InternalWarningLine: Matcher, Matchable {
    static let regex = Regex("warning: (.*)$")
    var message: String { return captures[0] }
    
    func print(to out: WritableStream) {
        out <<< ""
        out <<< "Warning: ".bold.yellow + message
        out <<< ""
    }
}

final class InternalNoteLine: Matcher, Matchable {
    static let regex = Regex("^note: (.*)$")
    var message: String { return captures[0] }
}

final class DependencyActionLine: Matcher, Matchable {
    enum Action: String, Capturable {
        case fetch = "Fetching"
        case update = "Updating"
        case clone = "Cloning"
    }
    static let regex = Regex("(Fetching|Updating|Cloning) ([^ ]+)$")
    var action: Action { return captures[0] }
    var url: String { return captures[1] }
    
    func print(to out: WritableStream) {
        out <<< String(describing: action).capitalized.dim + " " + url
    }
}

final class ResolveLine: Matcher, Matchable {
    static let regex = Regex("Resolving ([^ ]+) at (.*)$")
    var url: String { return captures[0] }
    var version: String { return captures[1] }
    
    func print(to out: WritableStream) {
        out <<< "Resolve ".dim + "\(url) at \(version)"
    }
}
