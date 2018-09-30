//
//  Connect4Tests.swift
//  Connect4Tests
//
//  Created by Sami Youssef on 9/30/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import XCTest
@testable import Connect4
class Connect4Tests: XCTestCase {

    var gameBoard: GameBoard!

    override func setUp() {
        super.setUp()
        gameBoard = GameBoard(rows: 6, columns: 7)

        // Mockup grid
        gameBoard.addCoin(withStatus: .red, inColumn: 0)
        gameBoard.addCoin(withStatus: .red, inColumn: 1)
        gameBoard.addCoin(withStatus: .red, inColumn: 2)
        gameBoard.addCoin(withStatus: .red, inColumn: 3)

        gameBoard.addCoin(withStatus: .yellow, inColumn: 0)
        gameBoard.addCoin(withStatus: .yellow, inColumn: 1)
        gameBoard.addCoin(withStatus: .yellow, inColumn: 6)
        gameBoard.addCoin(withStatus: .yellow, inColumn: 5)
    }

    func testNextEmptyRow() {
        let nextRow = gameBoard.nextEmptyRow(at: 0)
        XCTAssertEqual(nextRow, 2)
    }

    func testIsGridFull() {
        XCTAssertFalse(gameBoard.isGridFull())
    }

    func testHorizontalDirection() {
        let gridPosition = GridPosition(row: 0, column: 0)
        XCTAssertTrue(gameBoard.checkHorizontalDirection(for: .red, in: gridPosition, connections: 4))
    }

    func testVerticalDirection() {
        let gridPosition = GridPosition(row: 0, column: 0)
        XCTAssertFalse(gameBoard.checkVerticalDirection(for: .red, in: gridPosition, connections: 4))
    }

    func testWinnerDirection() {
        let gridPosition = GridPosition(row: 0, column: 0)
        let testedDirection = gameBoard.getWinnerDirrection(for: .red, position: gridPosition, connections: 4)
        XCTAssertEqual(testedDirection, Direction.horizontal)
    }

    func testPlayerWin() {
        XCTAssertTrue(gameBoard.isPlayerWon(coin: .red, connections: 4))
    }

    override func tearDown() {
        gameBoard = nil
        super.tearDown()
    }

    func testPerformanceExample() {
        self.measure {
            _ = gameBoard.isPlayerWon(coin: .red, connections: 4)
        }
    }
    
}
