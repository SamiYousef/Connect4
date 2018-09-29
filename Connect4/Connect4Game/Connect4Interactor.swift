//
//  Connect4Interactor.swift
//  Connect4
//
//  Created by Sami Youssef on 9/29/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import Foundation

class Connect4Interactor: Connect4InteractorInputProtocol {
    weak var presenter: Connect4InteractorOutputProtocol?

    func loadConnectFourConfiguration​() {
        guard let url = URL(string: .configuration​Url) else {
            presenter?.onError()
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                self.presenter?.onError()
                return
            }
            do {
                let result = try JSONDecoder().decode([GameConfiguration].self, from: data)
                self.presenter?.didRetrieveConfiguration(result)
            } catch {
                self.presenter?.onError()
            }
        }.resume()
    }
}

fileprivate extension String {
    static let configuration​Url = "https://private-75c7a5-blinkist.apiary-mock.com/connectFour/configuration"
}
