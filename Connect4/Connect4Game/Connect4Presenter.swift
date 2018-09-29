//
//  Connect4Presenter.swift
//  Connect4
//
//  Created by Sami Youssef on 9/29/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import Foundation

class Connect4Presenter: Connect4PresenterProtocol {
    var view: Connect4ViewProtocol?
    var interactor: Connect4InteractorInputProtocol?
    var wireFrame: Connect4WireFrameProtocol?

    func viewDidLoad() {
        view?.showLoading()
        interactor?.loadConnectFourConfiguration​()
    }

}

extension Connect4Presenter: Connect4InteractorOutputProtocol {
    func didRetrieveConfiguration(_ configuration: [GameConfiguration]) {
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.view?.updateView(with: configuration)
        }
    }

    func onError() {
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.view?.showError()
        }
    }
}
