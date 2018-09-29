//
//  Connect4Protocols.swift
//  Connect4
//
//  Created by Sami Youssef on 9/29/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import UIKit

protocol Connect4InteractorOutputProtocol: class {
    // INTERACTOR -> PRESENTER
    func didRetrieveConfiguration(_ configuration: [GameConfiguration])
    func onError()
}

protocol Connect4InteractorInputProtocol: class {
    var presenter: Connect4InteractorOutputProtocol? { get set }
    // PRESENTER -> INTERACTOR
    func loadConnectFourConfiguration​()
}

protocol RemoteDataManagerOutputProtocol: class {
    func onConfigurationRetrieved(_ config: [GameConfiguration])
    func onError()
}

protocol Connect4WireFrameProtocol: class {
    static func createConnect4GameModule() -> UIViewController
}

protocol Connect4ViewProtocol: class {
    var presenter: Connect4PresenterProtocol? { get set }

    func updateView(with configuration: [GameConfiguration])
    func showError()
    func showLoading()
    func hideLoading()
}

protocol Connect4PresenterProtocol: class {
    var view: Connect4ViewProtocol? { get set }
    var interactor: Connect4InteractorInputProtocol? { get set }
    var wireFrame: Connect4WireFrameProtocol? { get set }

    func viewDidLoad()
}
