//
//  GridCell.swift
//  Connect4
//
//  Created by Sami Youssef on 9/28/18.
//  Copyright © 2018 Sami Youssef. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {

    lazy var cellImage: UIImageView = {
        let cellImage = UIImageView()
        cellImage.image = #imageLiteral(resourceName: "grid_box_alt")
        cellImage.contentMode = .scaleToFill
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        return cellImage
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateConstrains()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateConstrains() {
        self.contentView.addSubview(cellImage)
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cellImage.topAnchor.constraint(equalTo: self.topAnchor),
            cellImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }

}
