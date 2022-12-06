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

///
/// Sample input:
/// A Y
/// B X
/// C Z
///
/// (1+3)
/// (1+0)
/// (1+6)
/// => 12
///
func day2Part2() -> Int {
    let inputLines = getInputLines(fileName: "day2_input.txt")
    let resultPairs = inputLines.map { $0.components(separatedBy: CharacterSet.whitespaces) }
        .filter { $0.count == 2 }
        .map { (theirMove: Move.getMove(from: $0[0])!, neededResult: GameResult(from: $0[1])) }

    return resultPairs
        .map { pair -> Int in
            let ourMove = getMoveNeeded(theirMove: pair.theirMove, gameResult: pair.neededResult!)
            return ourMove.calculateScore(versus: pair.theirMove)
        }
        .reduce(0, +)
}

enum GameResult {
    case lose
    case tie
    case win

    init?(from string: String) {
        switch string {
        case "X":
            self = .lose
        case "Y":
            self = .tie
        case "Z":
            self = .win
        default:
            return nil
        }
    }
}

func getMoveNeeded(theirMove: Move, gameResult: GameResult) -> Move {
    switch theirMove {
    case .rock:
        switch gameResult {
        case .lose:
            return .scissors
        case .tie:
            return .rock
        case .win:
            return .paper
        }
    case .paper:
        switch gameResult {
        case .lose:
            return .rock
        case .tie:
            return .paper
        case .win:
            return .scissors
        }
    case .scissors:
        switch gameResult {
        case .lose:
            return .paper
        case .tie:
            return .scissors
        case .win:
            return .rock
        }
    }
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
        case "A":
            return .rock
        case "B":
            return .paper
        case "C":
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
