import Collections
import Foundation
import RegexBuilder

/** Sample input:

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2

*/
@available(macOS 13.0, *)
struct Day5 {
    func part1() -> String {
        let inputLines = getInputLines(fileName: "day5_input")
        let separator = inputLines.firstIndex(of: "")!
        var puzzleStacksInput = inputLines[..<separator].filter { $0 != "" }
        puzzleStacksInput.removeLast()
        var stacks = populateStacks(using: puzzleStacksInput)
        let instructions = inputLines[separator...].filter { $0 != "" }
        instructions.map { parseInstruction($0) }
            .forEach { instruction in
                for _ in 0..<instruction.numToMove {
                    let removed = stacks[instruction.fromStack - 1].popFirst()
                    stacks[instruction.toStack - 1].prepend(removed!)
                }
            }

        return String(stacks.compactMap { $0.first })
    }

    /*
     [D]
     [N] [C]
     [Z] [M] [P]
     1   2   3
     */
    func populateStacks(using stacksInput: [String]) -> [Deque<Character>] {
        var deques: [Deque<Character>] = [
            .init(), .init(), .init(), .init(), .init(), .init(), .init(), .init(), .init()
        ]

        stacksInput.forEach { line in
            for i in stride(from: 1, to: stacksInput.first?.count ?? 0, by: 4) {
                let index = line.index(line.startIndex, offsetBy: i)
                let charStr = String(line[index])
                guard charStr != " " else { continue }
                let dequeIndex = (i-1) / 4
                deques[dequeIndex].append(contentsOf: charStr)
            }
        }

        return deques
    }

    // regex is wrong - only 1-digit numbers are being matched
    func parseInstruction(_ instruction: String) -> Instruction {
        let regex = Regex {
            "move "
            TryCapture {
                OneOrMore(.digit)
            } transform: { num in
                Int(num)
            }
            " from "
            TryCapture {
                OneOrMore(.digit)
            } transform: { num in
                Int(num)
            }
            " to "
            TryCapture {
                OneOrMore(.digit)
            } transform: { num in
                Int(num)
            }
        }

        if let match = instruction.firstMatch(of: regex) {
            let (_, numToMove, fromStack, toStack) = match.output
            return Instruction(numToMove: numToMove, fromStack: fromStack, toStack: toStack)
        }

        return Instruction(numToMove: 0, fromStack: 0, toStack: 0)
    }

    struct Instruction {
        let numToMove: Int
        let fromStack: Int
        let toStack: Int
    }
}
