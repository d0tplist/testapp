//
//  File.swift
//  
//
//  Created by alex on 21/06/21.
//

import Foundation
import XCTest
import class Foundation.Bundle

class gitTest : XCTestCase {
    
    let command = "git branch -av"
    
    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    func testGit(){
        let path = FileManager.default.currentDirectoryPath
        print(path)
        print(shell(command))
    }
    

}

// MARK: - Branch
struct Branch: Codable {
    let name: String
    let commit: Commit
    let protected: Bool
}

// MARK: - Commit
struct Commit: Codable {
    let sha: String
    let url: String
}

typealias Branches = [Branch]
