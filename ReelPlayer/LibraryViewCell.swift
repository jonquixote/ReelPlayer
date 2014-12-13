//
//  LibraryViewCell.swift
//  ReelPlayer
//
//  Created by John Hawley and Bo Jacobson on 12/11/14.
//  Copyright (c) 2014 RealtoReal. All rights reserved.
//

import Foundation
import UIKit

class LibraryViewCell: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var view = UIView(frame:self.frame)
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        view.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        view.layer.borderColor = UIColor.whiteColor().CGColor
        view.layer.borderWidth = 4
        self.selectedBackgroundView = view
    }
    
}
