//
//  Player.swift
//  Connect4
//
//  Created by Sami Youssef on 9/29/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import Foundation

class Player: NSObject {
    private(set) var coin: CoinStatus
    private(set) var numOfWins: Int
    var playerName: String

    init(coin: CoinStatus) {
        self.coin = coin
        self.numOfWins = 0
        self.playerName = ""
    }

    func incrementNumberOfWins() {
        numOfWins += 1
    }
}
