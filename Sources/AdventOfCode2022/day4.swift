import Foundation

@available(macOS 13.0, *)
func part1() -> Int {
    getInputLines(fileName: "day4_input.txt")
        .map { getPairs(from: $0) }
        .filter { $0.0.contains($0.1) || $0.1.contains($0.0) }
        .count
}

func part2() -> Int {
    getInputLines(fileName: "day4_input.txt")
        .map { getPairs(from: $0) }
        .filter { $0.0.overlaps($0.1) || $0.1.overlaps($0.0) }
        .count
}

func getPairs(from str: String) -> (ClosedRange<Int>, ClosedRange<Int>) {
    let strPair = str.components(separatedBy: ",")
    let (first, second) = (strPair[0], strPair[1])
    let firstRangeComponents = first.components(separatedBy: "-")
    let firstRange = Int(firstRangeComponents[0])!...Int(firstRangeComponents[1])!
    let secondRangeComponents = second.components(separatedBy: "-")
    let secondRange = Int(secondRangeComponents[0])!...Int(secondRangeComponents[1])!

    return (firstRange, secondRange)
}

func getInputLines(fileName: String) -> [String] {
    guard let path = Bundle.module.path(forResource: fileName, ofType: "txt") else { return [] }
    guard let fileContents = try? String(contentsOfFile: path, encoding: .utf8) else { return [] }

    return fileContents.components(separatedBy: CharacterSet.newlines).dropLast()
 }
