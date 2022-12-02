import Foundation

///
/// Sample input:
///
/// A Y
/// B X
/// C Z
///
/// (2+6)
/// (1+0)
/// (3+3)
/// => 15
///
func day2Part1() -> Int {
    let inputLines = getInputLines(fileName: "day2_input.txt")
    return inputLines
        .map { inputLine in
            inputLine.components(separatedBy: CharacterSet.whitespaces).compactMap { Move.getMove(from: $0) }
        }
        .filter { $0.count == 2 }
        .map { $0[1].calculateScore(versus: $0[0]) }
        .reduce(0, +)
}

func getInputLines(fileName: String) -> [String] {

    guard let fileContents = try? String(contentsOfFile: fileName, encoding: .utf8) else { return [] }
    return fileContents.components(separatedBy: CharacterSet.newlines)
}

enum Move {
    case rock
    case paper
    case scissors

    var score: Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .scissors:
            return 3
        }
    }
}

extension Move {
    static func getMove(from string: String) -> Move? {
        switch string {
        case "A", "X":
            return .rock
        case "B", "Y":
            return .paper
        case "C", "Z":
            return .scissors
        default:
            return nil
        }
    }

    func calculateScore(versus move: Move) -> Int {
        switch self {
        case .rock:
            switch move {
            case .rock:
                return 1 + 3
            case .paper:
                return 1 + 0
            case .scissors:
                return 1 + 6
            }
        case .paper:
            switch move {
            case .rock:
                return 2 + 6
            case .paper:
                return 2 + 3
            case .scissors:
                return 2 + 0
            }

        case .scissors:
            switch move {
            case .rock:
                return 3 + 0
            case .paper:
                return 3 + 6
            case .scissors:
                return 3 + 3
            }
        }
    }
}

print(day2Part1())
