//
//  Dump.swift
//  CLI
//
//  Created by Jake Heiser on 9/6/17.
//

import Foundation
import IceKit
import SwiftCLI

class DumpCommand: Command {
    
    let name = "dump"
    let shortDescription = "Dumps the current package in JSON format"
    
    func execute() throws {
        let data = try SPM().dumpPackage()
        stdout.writeData(data)
    }
    
}
