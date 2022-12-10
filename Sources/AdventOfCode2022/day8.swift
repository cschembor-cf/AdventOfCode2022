//
//  Day8.swift
//  
//
//  Created by Connor Schembor on 12/10/22.
//

import Foundation

struct Day8 {

    private let input: [[Int]]

    init() {
        self.input = getInputLines(fileName: "day8_input")
            .map { line -> [Int] in
                line.map { Int("\($0)")! }
            }
    }

    func part1() -> Int {
        var count = 0
        for y in 1..<input.count-1 {
            for x in 1..<input.first!.count-1 {
                if isVisible(coord: (x: x, y: y)) {
                    count += 1
                }
            }
        }

        return (2 * input.count) + (2 * (input.first!.count - 2)) + count
    }

    func part2() -> Int {
        self.input.enumerated()
            .flatMap { (y, line) in
                line.enumerated()
                    .map { (x, _) in
                        return calculateScenicScore(coord: (x: x, y: y))
                    }
            }
            .sorted(by: >)
            .first ?? 0
    }

    private func calculateScenicScore(coord: (x: Int, y: Int)) -> Int {
        let up = getVisible(for: (x: coord.x, y: coord.y), from: .up)
        let down = getVisible(for: (x: coord.x, y: coord.y), from: .down)
        let left = getVisible(for: (x: coord.x, y: coord.y), from: .left)
        let right = getVisible(for: (x: coord.x, y: coord.y), from: .right)

        return up * down * left * right
    }

    private func getVisible(for coord: (x: Int, y: Int), from dir: Direction) -> Int {

        let height = self.input[coord.y][coord.x]
        var numTreesVisible = 0
        var stopped = false

        switch dir {
        case .up:
            var currY = coord.y - 1
            while currY >= 0 && !stopped {
                if self.input[currY][coord.x] >= height {
                    stopped = true
                } else {
                    currY -= 1
                }
                numTreesVisible += 1
            }
        case .down:
            var currY = coord.y + 1
            while currY < self.input.count && !stopped {
                if self.input[currY][coord.x] >= height {
                    stopped = true
                } else {
                    currY += 1
                }
                numTreesVisible += 1
            }
        case .left:
            var currX = coord.x - 1
            while currX >= 0 && !stopped {
                if self.input[coord.y][currX] >= height {
                    stopped = true
                } else {
                    currX -= 1
                }
                numTreesVisible += 1
            }
        case .right:
            var currX = coord.x + 1
            while currX < self.input.first!.count && !stopped {
                if self.input[coord.y][currX] >= height {
                    stopped = true
                } else {
                    currX += 1
                }
                numTreesVisible += 1
            }
        }

        return numTreesVisible
    }

    enum Direction {
        case up
        case down
        case left
        case right
    }

    private func isVisible(coord: (x: Int, y: Int)) -> Bool {

        let currTreeHeight = self.input[coord.y][coord.x]

        // (x: 2, y: 3)

        // top
        // - [2, 2], [2, 1], [2, 0]
        var isVisibleFromTop = true
        for i in stride(from: coord.y - 1, through: 0, by: -1) {
            let height = self.input[i][coord.x]
            if height >= currTreeHeight { isVisibleFromTop = false }
        }

        // bottom
        // - [2, 4]
        var isVisibleFromBottom = true
        for i in (coord.y+1)..<self.input.count {
            let height = self.input[i][coord.x]
            if height >= currTreeHeight { isVisibleFromBottom = false }
        }

        // left
        // - [1, 3], [0, 3]
        var isVisibleFromLeft = true
        for i in stride(from: coord.x - 1, through: 0, by: -1) {
            let height = self.input[coord.y][i]
            if height >= currTreeHeight { isVisibleFromLeft = false }
        }

        // right
        var isVisibleFromRight = true
        for i in (coord.x+1)..<self.input[coord.y].count {
            let height = self.input[coord.y][i]
            if height >= currTreeHeight { isVisibleFromRight = false }
        }

        return isVisibleFromTop || isVisibleFromBottom || isVisibleFromLeft || isVisibleFromRight
    }
}
