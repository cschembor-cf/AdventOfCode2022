//
//  Day9.swift
//  
//
//  Created by Connor Schembor on 12/12/22.
//

import Foundation

class Day9 {

    /*
     Sample input:

     R 4
     U 4
     L 3
     D 1
     R 4
     D 1
     L 5
     R 2

     */

    private var visited = Set<Coord>()

    func part1() -> Int {

        let input = getInputLines(fileName: "day9_input")
        var head = Coord(x: 0, y: 0)
        var tail = Coord(x: 0, y: 0)

        input.map { Instruction(from: $0) }
            .forEach { instr in
                let (newHead, newTail) = move(head: head, tail: tail, instr: instr)
                head = newHead
                tail = newTail
            }

        return visited.count
    }

    private func move(head: Coord, tail: Coord, instr: Instruction) -> (newHead: Coord, newTail: Coord) {
        var currHead = head
        var currTail = tail
        for _ in 0..<instr.amount {
            (currHead, currTail) = test(head: currHead, tail: currTail, instruction: instr)
            self.visited.insert(currTail)
        }

        return (newHead: currHead, newTail: currTail)
    }

    private func test(head: Coord, tail: Coord, instruction: Instruction) -> (head: Coord, tail: Coord) {
        switch instruction.direction {
        case .left:
            let newHead = Coord(x: head.x-1, y: head.y)
            let newTail: Coord = {
                if !areAdjacent(newHead, tail) && newHead != tail {
                    return Coord(x: newHead.x+1, y: newHead.y)
                }
                return tail
            }()

            return (newHead, newTail)
        case .right:
            let newHead = Coord(x: head.x+1, y: head.y)
            let newTail: Coord = {
                if !areAdjacent(newHead, tail) && newHead != tail {
                    return Coord(x: newHead.x-1, y: newHead.y)
                }
                return tail
            }()

            return (newHead, newTail)

        case .up:
            let newHead = Coord(x: head.x, y: head.y+1)
            let newTail: Coord = {
                if !areAdjacent(newHead, tail) && newHead != tail {
                    return Coord(x: newHead.x, y: newHead.y-1)
                }
                return tail
            }()

            return (newHead, newTail)

        case .down:
            let newHead = Coord(x: head.x, y: head.y-1)
            let newTail: Coord = {
                if !areAdjacent(newHead, tail) && newHead != tail {
                    return Coord(x: newHead.x, y: newHead.y+1)
                }
                return tail
            }()

            return (newHead, newTail)

        }
    }

    private func areAdjacent(_ coord1: Coord, _ coord2: Coord) -> Bool {
        let yDiff = abs(coord2.y - coord1.y)
        let xDiff = abs(coord2.x - coord1.x)
        return (yDiff == 1 && xDiff == 0) ||
        (yDiff == 0 && xDiff == 1) ||
        (yDiff == 1 && xDiff == 1)
    }

    struct Coord: Equatable, Hashable {
        let x: Int
        let y: Int
    }

    struct Instruction {
        let direction: Direction
        let amount: Int

        init(from str: String) {
            let components = str.components(separatedBy: .whitespaces)
            self.direction = Direction(rawValue: components[0])!
            self.amount = Int(components[1])!
        }
    }

    enum Direction: String {
        case right = "R"
        case left = "L"
        case up = "U"
        case down = "D"
    }
}
