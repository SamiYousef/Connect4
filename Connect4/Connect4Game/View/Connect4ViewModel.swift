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

    var isPlayerWin: Bool {
        return gameBoard.isPlayerWon(coin: activePlayer.coin, connections: 4)
    }

    override init() {
        super.init()

        gameBoard = GameBoard(rows: rows, columns: columns)
        firstPlayer = Player(coin: .red)
        secundPlayer = Player(coin: .yellow)
        activePlayer = firstPlayer
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

    func getColumnFrom(positionInView pos:CGPoint, columnWidth: CGFloat) -> Int {
        return Int(floor(pos.x / columnWidth))
    }

    func incrementActivePlayer() {
        activePlayer.incrementNumberOfWins()
    }
}
