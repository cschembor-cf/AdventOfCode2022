//
//  File.swift
//  
//
//  Created by Connor Schembor on 12/6/22.
//

import Foundation

struct Day6 {

    /* Sample Input

     mjqjpqmgbljsphdztnvjfqwrcgsmlb

     => jpqm
     => (start index + count + 1) = (2 + 4 + 1)
     => 7

     */
    func part1() -> Int {
        let uniqueStrSize = 4
        return getStartOfMarker(for: getInputString(), uniqueCharCount: uniqueStrSize)
    }

    func part2() -> Int {
        let uniqueStrSize = 14
        return getStartOfMarker(for: getInputString(), uniqueCharCount: uniqueStrSize)
    }

    func getInputString() -> String {
        getInputLines(fileName: "day6_input").first ?? ""
    }

    func getStartOfMarker(for input: String, uniqueCharCount: Int) -> Int {
        var currSet = Set<Character>()
        var i = 0
        var j = i + 1
        currSet.insert(input[input.index(for: i)])
        while currSet.count < uniqueCharCount && j < input.count {
            guard !currSet.contains(input.char(at: j)) else {
                i += 1
                j = i + 1
                currSet.removeAll()
                currSet.insert(input.char(at: i))
                continue
            }

            currSet.insert(input[input.index(for: j)])
            j += 1
        }

        return j
    }
}

extension String {

    func char(at indexPos: Int) -> Character {
        self[self.index(for: indexPos)]
    }

    func index(for int: Int) -> String.Index {
        self.index(self.startIndex, offsetBy: int)
    }
}
