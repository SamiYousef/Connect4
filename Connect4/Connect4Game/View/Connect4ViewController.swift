//
//  ViewController.swift
//  Connect4
//
//  Created by Sami Youssef on 9/28/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import UIKit

class Connect4ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var redScore: UILabel!
    @IBOutlet weak var yellowScore: UILabel!
    @IBOutlet weak var gameGridView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var yellowPlayerTurnIndicator: UIImageView!
    @IBOutlet weak var redPlayerTurnIndicator: UIImageView!
    @IBOutlet weak var newgameButton: UIButton!

    var viewModel: Connect4ViewModel!
    var presenter: Connect4PresenterProtocol?
    var soundPlayer = SoundPlayer()

    var coinSize: CGSize {
        return CGSize(width: columnWidth, height: columnWidth)
    }

    var columnWidth: CGFloat {
        return gameGridView.bounds.size.width / CGFloat(viewModel.columns)
    }

    lazy var tapRegognizer: UITapGestureRecognizer = {
        let tapRegognizer = UITapGestureRecognizer(target: self, action: #selector(drop(_:)))
        tapRegognizer.delegate = self
        return tapRegognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        viewModel = Connect4ViewModel()

        gameGridView.dataSource = self
        gameGridView.delegate = self
        gameGridView.register(GridCell.self, forCellWithReuseIdentifier: .gridCellId)
        gameGridView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        gameGridView.addGestureRecognizer(tapRegognizer)
    }

    @objc func drop(_ sender: UITapGestureRecognizer) {
        toggleViewInteraction(active: false)
        let location = sender.location(in: gameGridView)
        var column = viewModel.getColumnFrom(positionInView: location, columnWidth: columnWidth)
        column = abs(column - 6)
        if let row = viewModel.nextEmptyRow(column: column) {
            viewModel.addCoinToGameBoard(inColumn: column)
            displayChip(viewModel.activePlayer.coin, at: column, row: row)
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
            heightConstraint.constant = screenWidth / CGFloat(viewModel.rows) * CGFloat(viewModel.rows)
            widthConstraint.constant  = screenWidth
        }
        yellowPlayerTurnIndicator.frame.size = coinSize
        yellowPlayerTurnIndicator.frame.origin.x = screenWidth - coinSize.width - 4
        redPlayerTurnIndicator.frame.size = coinSize
    }

    func updateCoins() {}

    func displayChip(_ coin: CoinStatus, at column:Int, row: Int) {
        let chipFrame = CGRect(x: 0, y: 0, width: columnWidth, height: columnWidth)
        let chip = UIImageView(frame: chipFrame)
        chip.tag = 20
        chip.image = coin == .red ? #imageLiteral(resourceName: "coin_1") : #imageLiteral(resourceName: "coin_2")
        chip.contentMode = .scaleAspectFit

        let xPos = gameGridView.frame.minX + CGFloat(column)*columnWidth + columnWidth/2
        let yPos = gameGridView.frame.maxY - columnWidth*CGFloat(row) - columnWidth/2
        chip.center = CGPoint(x: xPos, y: yPos)

        chip.transform = CGAffineTransform(translationX: 0, y: -800)
        view.addSubview(chip)

        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            chip.transform = CGAffineTransform.identity
        }) { (completed) in
            if completed {
                self.soundPlayer.coinDropping()
                if self.viewModel.gameBoard.winnerCoins.count == 4 {
                    self.showWinningPath()
                }
                // self.displayCurrentTurn()
            }
        }

    }

    func showWinningPath() {
        
    }

    private func updateGame() {
        if viewModel.isPlayerWin {
            toggleViewInteraction(active: false)
            viewModel.incrementActivePlayer()
            toggleNewGameButton(hiden: false)
            updatePlayerScore()
            displayWinnerAlert(winner: viewModel.activePlayer)
        } else {
            toggleViewInteraction(active: true)
            viewModel.switchAcivePlayer()
        }
    }

    func displayWinnerAlert(winner: Player) {
        let title = "Game Over"
        let message = "Player \(winner.playerName) wins!"
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let playAgainAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(playAgainAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func newGameButton(_ sender: UIButton) {
        toggleNewGameButton(hiden: true)
        viewModel.gameBoard.resetBoard()
        let boardImageViews = self.view.subviews.filter{$0.tag == 20}
        for boardImageView in boardImageViews {
            boardImageView.removeFromSuperview()
        }
        toggleViewInteraction(active: true)
    }

    func toggleViewInteraction(active: Bool) {
        gameGridView.isUserInteractionEnabled = active
    }

    func toggleNewGameButton(hiden: Bool) {
        newgameButton.isHidden = hiden
    }

    func updatePlayerScore() {
        redScore.text = String(viewModel.firstPlayer.numOfWins)
        yellowScore.text = String(viewModel.secundPlayer.numOfWins)
    }
}

extension Connect4ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .gridCellId, for: indexPath) as! GridCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.rows
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.columns
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return coinSize
    }

}

extension Connect4ViewController: Connect4ViewProtocol {
    func updateView(with configuration: [GameConfiguration]) {
        guard let configuration = configuration.first else { return }
        viewModel.updatePlayer(with: configuration)
    }

    func showError() {
    }

    func showLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func hideLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

fileprivate extension String {
    static let gridCellId = "GridCell"
}
