//
//  GameConfiguration.swift
//  Connect4
//
//  Created by Sami Youssef on 9/29/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import Foundation

struct GameConfiguration: Codable {
    var id: Int
    var color1: String
    var color2: String
    var name1: String
    var name2: String
}
