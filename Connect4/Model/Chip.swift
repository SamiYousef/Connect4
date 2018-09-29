//
//  ChipGrid.swift
//  Connect4
//
//  Created by Sami Youssef on 9/29/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import UIKit

struct Chip {
    var imageView: UIImageView
    var position: GridPosition

    func reversImage() {
        switch imageView.image {
        case #imageLiteral(resourceName: "coin_1"):
            imageView.image = #imageLiteral(resourceName: "coin_1_shaded")
        case #imageLiteral(resourceName: "coin_2"):
            imageView.image = #imageLiteral(resourceName: "coin_2_shaded")
        default:
            print(imageView)
            imageView.image = #imageLiteral(resourceName: "grid_box")
        }
    }
}
