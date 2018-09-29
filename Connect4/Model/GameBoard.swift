//
//  GameBoard.swift
//  Connect4
//
//  Created by Sami Youssef on 9/28/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import Foundation

enum CoinStatus: Int {
    case none
    case red
    case yellow
}

enum Direction: Int {
    case horizontal
    case vertical
    case positiveDiagonal
    case negativeDiagonal
}

struct GridPosition {
    var row, column : Int
}

class GameBoard: NSObject {

    private var numOfRows = 6
    private var numOfColumns = 7
    private var grid = [[CoinStatus]]()
    private(set) var winnerCoins = [GridPosition]()

    init(rows: Int, columns: Int) {
        super.init()
        self.numOfRows = rows
        self.numOfColumns = columns
        resetBoard()
    }

    func resetBoard() {
        grid = Array(repeating: Array(repeating: .none, count: numOfColumns), count: numOfRows)
        winnerCoins = []
    }

    func nextEmptyRow(at column: Int) -> Int? {
        for row in 0 ..< numOfRows {
            if grid[row][column] == .none {
                return row
            }
        }
        return nil
    }

    func addCoin(withStatus status: CoinStatus, inColumn col: Int) {
        if let row = nextEmptyRow(at: col) {
            grid[row][col] = status
        }
    }

    func printGameGrid() {
        for row in 0 ..< numOfRows {
            for col in 0..<numOfColumns {
                print(grid[row][col], separator: " ", terminator: " ")
            }
            print("\n")
        }
    }

    func isGridFull() -> Bool {
        for row in 0 ..< numOfRows {
            for col in 0..<numOfColumns {
                if grid[row][col] == .none {
                    return false
                }
            }
        }
        return true
    }

    func checkHorizontalDirection(for coin: CoinStatus, in position: GridPosition, connections: Int) -> Bool {
        if position.column + connections > numOfColumns { return false }
        for i in 0 ..< connections {
            if grid[position.row][position.column + i] != coin {
                return false
            }
        }
        return true
    }

    func checkVerticalDirection(for coin: CoinStatus, in position: GridPosition, connections: Int) -> Bool {
        if position.row + connections > numOfRows { return false }
        for i in 0 ..< connections {
            if grid[position.row + i][position.column] != coin {
                return false
            }
        }
        return true
    }

    func checkPositiveDiagonalDirection(for coin: CoinStatus, in position: GridPosition, connections: Int) -> Bool {
        if position.row + connections > numOfRows { return false }
        if position.column + connections > numOfColumns { return false }
        for i in 0..<connections {
            if grid[position.row + i][position.column + i] != coin {
                return false
            }
        }
        return true
    }

    func checkNegativeDiagonalDirection(for coin: CoinStatus, in position: GridPosition, connections: Int) -> Bool {
        if position.row - (connections - 1) < 0 { return false }
        if position.column + connections > numOfColumns { return false }
        for i in 0..<connections {
            if grid[position.row - i][position.column + i] != coin {
                return false
            }
        }
        return true
    }

    func getWinnerCoins(startPosition position: GridPosition,with dirction: Direction) {
        winnerCoins = []
        switch dirction {
        case .horizontal:
            for i in 0 ..< 4 {
                winnerCoins.append(GridPosition(row: position.row, column: position.column + i))
            }
        case .vertical:
            for i in 0 ..< 4 {
                winnerCoins.append(GridPosition(row: position.row + i, column: position.column))
            }
        case .positiveDiagonal:
            for i in 0 ..< 4 {
                winnerCoins.append(GridPosition(row: position.row + i, column: position.column + i))
            }
        case .negativeDiagonal:
            for i in 0 ..< 4 {
                winnerCoins.append(GridPosition(row: position.row - i, column: position.column + i))
            }
        }
    }

    func getWinnerDirrection(for coin: CoinStatus, position: GridPosition, connections: Int) -> Direction? {
        if checkHorizontalDirection(for: coin, in: position, connections: connections) {
            return .horizontal
        }
        if checkVerticalDirection(for: coin, in: position, connections: connections) {
            return .vertical
        }
        if checkPositiveDiagonalDirection(for: coin, in: position, connections: connections) {
            return .positiveDiagonal
        }
        if checkNegativeDiagonalDirection(for: coin, in: position, connections: connections) {
            return .negativeDiagonal
        }
        return nil
    }

    func isPlayerWon(coin: CoinStatus, connections: Int) -> Bool {
        for row in 0 ..< numOfRows {
            for col in 0 ..< numOfColumns {
                let pos = GridPosition(row: row, column: col)
                if let winnerDirection = getWinnerDirrection(for: coin,
                                                             position: pos,
                                                             connections: connections) {
                    getWinnerCoins(startPosition: pos, with: winnerDirection)
                    return true
                }
            }
        }
        return false
    }

}
