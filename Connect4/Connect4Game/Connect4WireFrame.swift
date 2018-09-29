//
//  Connect4WireFrame.swift
//  Connect4
//
//  Created by Sami Youssef on 9/29/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import UIKit

class Connect4WireFrame: Connect4WireFrameProtocol {
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }

    static func createConnect4GameModule() -> UIViewController {
        if let view = mainStoryboard.instantiateViewController(withIdentifier: "Connect4Game") as? Connect4ViewController {
            let presenter: Connect4PresenterProtocol & Connect4InteractorOutputProtocol = Connect4Presenter()
            let interactor: Connect4InteractorInputProtocol = Connect4Interactor()
            let wireFrame: Connect4WireFrameProtocol = Connect4WireFrame()

            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            interactor.presenter = presenter

            return view
        }
        return UIViewController()
    }
}
