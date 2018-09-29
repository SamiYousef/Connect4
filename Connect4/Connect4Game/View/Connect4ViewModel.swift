//
//  Connect4ViewModel.swift
//  Connect4
//
//  Created by Sami Youssef on 9/29/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import UIKit

class Connect4ViewModel: NSObject {

    var columns       = 7
    var rows          = 6

    var firstPlayer, secundPlayer, activePlayer: Player!
    var gameBoard: GameBoard!
    var chipGrid: [Chip]!

    var isPlayerWin: Bool {
        return gameBoard.isPlayerWon(coin: activePlayer.coin, connections: 4)
    }

    var winnerCoinsCount: Int {
        return gameBoard.winnerCoins.count
    }

    override init() {
        super.init()

        gameBoard = GameBoard(rows: rows, columns: columns)
        chipGrid = [Chip]()
        firstPlayer = Player(coin: .red)
        secundPlayer = Player(coin: .yellow)
        activePlayer = firstPlayer
    }

    func resetGame() {
        for chip in chipGrid {
            chip.imageView.removeFromSuperview()
        }
        chipGrid.removeAll()
        gameBoard.resetBoard()
    }

    func nextEmptyRow(column: Int) -> Int? {
        return gameBoard.nextEmptyRow(at: column)
    }

    func switchAcivePlayer() {
        activePlayer = activePlayer == firstPlayer ? secundPlayer : firstPlayer
    }

    func updatePlayer(with configuration: GameConfiguration) {
        firstPlayer.playerName = configuration.name1
        secundPlayer.playerName = configuration.name2
    }

    func addCoinToGameBoard(inColumn column: Int) {
        gameBoard.addCoin(withStatus: activePlayer.coin, inColumn: column)
    }

    func addChipToGrid(imageView: UIImageView, row: Int, column: Int) {
        let position = GridPosition(row: row, column: column)
        chipGrid.append(Chip(imageView: imageView, position: position))
    }

    func getColumnFrom(positionInView pos:CGPoint, columnWidth: CGFloat) -> Int {
        return Int(floor(pos.x / columnWidth))
    }

    func incrementActivePlayer() {
        activePlayer.incrementNumberOfWins()
    }

    func showWinningPath() {
        let winCoins = gameBoard.winnerCoins
        for chip in chipGrid {
            let filterArray = winCoins.filter { (gridPosition) in
                return chip.position == gridPosition
            }
            if filterArray.isEmpty {
                chip.reversImage()
            }
        }
    }
}
