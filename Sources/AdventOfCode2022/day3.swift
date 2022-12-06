import Foundation

func day3Part1() -> Int {
    getInputLines(fileName: "day3_input.txt")
        .map { halve(str: $0) }
        .compactMap { getCommonChar($0.0, $0.1) }
        .map { getPriorityVal(for: $0) }
        .reduce(0, +)
}

func day3Part2() -> Int {
    let lines = getInputLines(fileName: "day3_input.txt")
    var currIndex = 0
    var prioritiesSum = 0
    while currIndex < lines.count - 1 {
        let grouping = Array(lines[currIndex..<(currIndex + 3)])
        let commonChar = getCommonChar(grouping[0], grouping[1], grouping[2])
        prioritiesSum += getPriorityVal(for: commonChar!)
        currIndex += 3
    }

    return prioritiesSum
}

func getPriorityVal(for char: Character) -> Int {
    let charSet = CharacterSet(charactersIn: "\(char)")
    if charSet.isSubset(of: .uppercaseLetters) {
        return Int(char.asciiValue!) - 38
    }

    return Int(char.asciiValue!) - 96
}

func halve(str: String) -> (String, String) {
    let size = str.count
    return (String(str.prefix(size / 2)), String(str.suffix(size / 2)))
}

func getCommonChar(_ str1: String, _ str2: String, _ str3: String? = nil) -> Character? {
    guard let str3 else {
        return str1.filter { str2.contains($0) }.first
    }

    return str1.filter { str2.contains($0) && str3.contains($0) }.first
}
