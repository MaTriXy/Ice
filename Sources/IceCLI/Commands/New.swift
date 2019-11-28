//
//  New.swift
//  Ice
//
//  Created by Jake Heiser on 7/21/17.
//

import IceKit
import PathKit
import SwiftCLI

class NewCommand: CreateProjectCommand, Command {

    let name = "new"
    let shortDescription = "Creates a new package in the given directory"
    
    @Param var projectName: String

    func execute() throws {
        let path = Path.current + projectName
        if path.exists {
            throw IceError(message: "\(projectName) already exists")
        }
        try path.mkdir()
        
        Path.current = path
        
        try createProject()
        
        stdout <<< ""
        stdout <<< "Run: ".blue.bold + "cd \(projectName) && ice build"
        stdout <<< ""
    }

}
