//
//  File.swift
//  
//
//  Created by Connor Schembor on 12/7/22.
//

import Foundation
import RegexBuilder

@available(macOS 13.0, *)
struct Day7 {

    func part1() -> Int {
        let inputLines = getInputLines(fileName: "day7_input").filter { $0 != "$ cd /" }
        let dirIndices = getChangeDirIndices(inputLines: inputLines)
        let tree = constructHomeDir(inputLines: inputLines, dirIndices: dirIndices)

        return flattenSizes(dir: tree, input: []).filter { $0 < 100_000}.reduce(0, +)
    }

    func part2() -> Int {
        let inputLines = getInputLines(fileName: "day7_input").filter { $0 != "$ cd /" }
        let dirIndices = getChangeDirIndices(inputLines: inputLines)
        let tree = constructHomeDir(inputLines: inputLines, dirIndices: dirIndices)

        let usedSpace = tree.size
        let neededUnusedSpace = 30_000_000 - (70_000_000 - usedSpace)

        return flattenSizes(dir: tree, input: [])
            .filter { $0 >= neededUnusedSpace }
            .sorted()
            .first!
    }

    func getChangeDirIndices(inputLines: [String]) -> [Int] {
        inputLines.enumerated().reduce(into: []) {
            if $1.element.starts(with: "$ cd") {
                $0.append($1.offset)
            }
        }
    }

    func constructHomeDir(inputLines: [String], dirIndices: [Int]) -> Directory {
        let tree = Directory(name: "/", parent: nil)
        var currDir = tree

        for (index, line) in inputLines.enumerated() {
            if dirIndices.contains(index) {
                if line == "$ cd .." {
                    currDir = currDir.parentDirectory!
                } else {
                    currDir = currDir.childDirectories.first { $0.name == (line.split(separator: "$ cd ")[0]) }!
                }
            }

            if line.starts(with: "dir") {
                currDir.childDirectories.append(Directory(name: line.replacingOccurrences(of: "dir ", with: ""), parent: currDir))
            }

            if let match = line.firstMatch(of: self.filePattern) {
                currDir.files.append(File(name: line, size: match.output.1))
            }
        }

        return tree
    }

    func flattenSizes(dir: Directory, input: [Int]) -> [Int] {
        var newList: [Int] = [] + [dir.size]
        dir.childDirectories.forEach { dir in
            newList += flattenSizes(dir: dir, input: newList)
        }

        return newList
    }

    let filePattern = Regex {
        Anchor.startOfLine
        TryCapture {
            OneOrMore(.digit)
        } transform: { num in
            Int(num)
        }
    }

    class Directory {
        let name: String
        var childDirectories: [Directory] = []
        let parentDirectory: Directory?
        var files: [File] = []

        init(name: String, parent: Directory?) {
            self.name = name
            self.parentDirectory = parent
        }

        var description: String {
            """
Parent directory: \(self.parentDirectory?.description ?? "")\n\
Child Directories: \(self.childDirectories)\n\
Files: \(self.files)
"""
        }

        var size: Int {
            if childDirectories.count == 0 {
                return files.map { $0.size }.reduce(0, +)
            }

            return files.map { $0.size }.reduce(0, +) + childDirectories.map { $0.size }.reduce(0, +)
        }
    }

    struct File {
        let name: String
        let size: Int
    }
}
