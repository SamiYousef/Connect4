//
//  ViewController.swift
//  Connect4
//
//  Created by Sami Youssef on 9/28/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import UIKit

class Connect4ViewController: UIViewController, UIGestureRecognizerDelegate {

    var columns       = 7
    var rows          = 6

    var firstPlayer, secundPlayer, activePlayer: Player!

    @IBOutlet weak var redScore: UILabel!
    @IBOutlet weak var yellowScore: UILabel!
    @IBOutlet weak var gameGridView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var yellowPlayerTurnIndicator: UIImageView!
    @IBOutlet weak var redPlayerTurnIndicator: UIImageView!
    @IBOutlet weak var newgameButton: UIButton!

    var soundPlayer = SoundPlayer()
    var gameBoard: GameBoard!

    var coinSize: CGSize {
        return CGSize(width: columnWidth, height: columnWidth)
    }

    var columnWidth: CGFloat {
        return gameGridView.bounds.size.width / CGFloat(columns)
    }

    lazy var tapRegognizer: UITapGestureRecognizer = {
        let tapRegognizer = UITapGestureRecognizer(target: self, action: #selector(drop(_:)))
        tapRegognizer.delegate = self
        return tapRegognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        gameGridView.dataSource = self
        gameGridView.delegate = self
        gameGridView.register(GridCell.self, forCellWithReuseIdentifier: .gridCellId)
        gameGridView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        gameGridView.addGestureRecognizer(tapRegognizer)

        gameBoard = GameBoard(rows: rows, columns: columns)
        self.firstPlayer = Player(coin: .red)
        secundPlayer = Player(coin: .yellow)
        activePlayer = firstPlayer
    }

    @objc func drop(_ sender: UITapGestureRecognizer) {
        toggleViewInteraction(active: false)
        let location = sender.location(in: gameGridView)
        var column = getColumnFrom(positionInView: location)
        column = abs(column - 6)
        if let row = gameBoard.nextEmptyRow(at: column) {
            gameBoard.addCoin(withStatus: activePlayer.coin, inColumn: column)
            displayChip(activePlayer.coin, at: column, row: row)
        }
        updateGame()
    }

    override func viewDidLayoutSubviews() {
        layoutGameboard()
        gameGridView.reloadData()
    }

    private func layoutGameboard() {
        let screenBounds = UIScreen.main.bounds
        let screenWidth  = screenBounds.size.width
        let screenHeight = screenBounds.size.height
        if screenHeight > screenWidth {
            heightConstraint.constant = screenWidth / CGFloat(rows) * CGFloat(rows)
            widthConstraint.constant  = screenWidth
        }
        yellowPlayerTurnIndicator.frame.size = coinSize
        yellowPlayerTurnIndicator.frame.origin.x = screenWidth - coinSize.width - 4
        redPlayerTurnIndicator.frame.size = coinSize
    }

    func updateCoins() {}

    func switchAcivePlayer() {
        activePlayer = activePlayer == firstPlayer ? secundPlayer : firstPlayer
    }

    func displayChip(_ coin: CoinStatus, at column:Int, row: Int) {
//        print("row: \(row)  column: \(column)")
//        gameBoard.printGameGrid()
//        print(activePlayer.coin)

        let chipFrame = CGRect(x: 0, y: 0, width: columnWidth, height: columnWidth)
        let chip = UIImageView(frame: chipFrame)
        chip.tag = 20
        chip.image = coin == .red ? #imageLiteral(resourceName: "coin_1") : #imageLiteral(resourceName: "coin_2")
        chip.contentMode = .scaleAspectFit

        let x = gameGridView.frame.minX + CGFloat(column)*columnWidth + columnWidth/2
        let y = gameGridView.frame.maxY - columnWidth*CGFloat(row) - columnWidth/2
        chip.center = CGPoint(x: x, y: y)

        chip.transform = CGAffineTransform(translationX: 0, y: -800)
        view.addSubview(chip)

        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            chip.transform = CGAffineTransform.identity
        }) { (completed) in
            if completed {
                self.soundPlayer.coinDropping()
                if self.gameBoard.winnerCoins.count == 4 {
                    //self.showWinningPath()
                }
               // self.displayCurrentTurn()
            }
        }

    }

    private func updateGame() {
        if gameBoard.isPlayerWon(coin: activePlayer.coin, connections: 4) {
            toggleViewInteraction(active: false)
            displayWinnerAlert(winner: activePlayer)
        } else {
            toggleViewInteraction(active: true)
            switchAcivePlayer()
        }
    }

    func displayWinnerAlert(winner: Player) {

        var title = ""
        var message = ""

        title = "Game Over"
        message = "Player \(winner.playerName) wins!"

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { _ in
                //self.newGame()
            }

            let exitAgainAction = UIAlertAction(title: "Exit", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }

            alert.addAction(playAgainAction)
            alert.addAction(exitAgainAction)
            self.present(alert, animated: true, completion: nil)
        }

    }
//    func getCGPoint(for move: Move) -> CGPoint {
//        let chipSize = max(gameBoard.frame.width / CGFloat(Board.width), gameBoard.frame.height / CGFloat(Board.height))
//        let columnView = columnViews[move.column]
//        let x = columnView.frame.midX + gameBoard.frame.minX
//        var y = columnView.frame.maxY - chipSize / 2 + gameBoard.frame.minY
//        y -= chipSize * CGFloat(move.row)
//
//        return CGPoint(x: x, y: y)
//    }

    private func getColumnFrom(positionInView pos:CGPoint) -> Int {
        return Int(floor(pos.x / columnWidth))
    }

    @IBAction func newGameButton(_ sender: UIButton) {
        gameBoard.resetBoard()
        let boardImageViews = self.view.subviews.filter{$0.tag == 20}
        for boardImageView in boardImageViews {
            boardImageView.removeFromSuperview()
        }
        toggleViewInteraction(active: true)
    }

    func toggleViewInteraction(active: Bool) {
        gameGridView.isUserInteractionEnabled = active
    }
}

extension Connect4ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .gridCellId, for: indexPath) as! GridCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return coinSize
    }

}

fileprivate extension String {
    static let gridCellId = "GridCell"
}
