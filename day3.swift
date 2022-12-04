import Foundation

func day3Part1() -> Int {
    getInputLines(fileName: "day3_input.txt")
        .map { halve(str: $0) }
        .compactMap { getCommonChar($0.0, $0.1) }
        .map { getPriorityVal(for: $0) }
        .reduce(0, +)
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

func getCommonChar(_ str1: String, _ str2: String) -> Character? {
    str1.filter { str2.contains($0) }.first
}

func getInputLines(fileName: String) -> [String] {
    guard let fileContents = try? String(contentsOfFile: fileName, encoding: .utf8) else { return [] }
    return fileContents.components(separatedBy: CharacterSet.newlines)
}

print(day3Part1())
