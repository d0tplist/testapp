// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

print("Hacking apple....")

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

func getCurrentBranch() -> String{
    return shell("git rev-parse --abbrev-ref HEAD")
        .replacingOccurrences(of: "\n", with: "")
}

func resolveRemote(url : String, _ spected : String, _ ifnot : String) -> String{
    
    let result = shell("git ls-remote -h \(url)")
    
    let branches = result.split(separator: "\n")
    
    for branch in branches {
        let split = branch.split(separator: "/")
        
        if String(split[split.count - 1]) == spected {
            return spected
        }
        
    }
    
    for branch in branches {
        let split = branch.split(separator: "/")
        
        if String(split[split.count - 1]) == ifnot {
            return ifnot
        }
    }
    
    print("branch not found returning main!")
    
    return "main"
}

let currentBranch = getCurrentBranch()
let liba = resolveRemote(url: "https://github.com/d0tplist/libraryb.git", currentBranch, "main")
let libb = resolveRemote(url: "https://github.com/d0tplist/librarya.git", currentBranch, "main")

print("")
print("----------------------------------------")
print("        Welcome to Mono 🐵 Swift!")
print("----------------------------------------")
print("Current branch: '\(currentBranch)'")
print("Branch for Lib A: \(liba)")
print("Branch for Lib B: \(libb)")
print("----------------------------------------")


let package = Package(
    name: "testapp",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/d0tplist/libraryb.git", .branch(liba)),
        .package(url: "https://github.com/d0tplist/librarya.git", .branch(libb))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "testapp",
            dependencies: []),
        .testTarget(
            name: "testappTests",
            dependencies: ["testapp"]),
    ]
)

