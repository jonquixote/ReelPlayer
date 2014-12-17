//
//  MixerViewController.swift
//  ReelPlayer
//
//  Created by Bo Jacobson on 12/12/14.
//  Copyright (c) 2014 RealtoReal. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class MixerViewController: UIViewController {
    
    
    
    
@IBOutlet var track1slider: UISlider!

    override func viewDidLoad() {
        configuretrack1slider()
        
       

    }
    


    
func configuretrack1slider() {
    
    let thumbImage = UIImage(named: "faderknob1")
    
    track1slider.setThumbImage(thumbImage, forState: .Normal)

    track1slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
    
    track1slider = UISlider(frame: CGRect(x: 0, y: 0, width: 200, height: 23))
    
    track1slider.transform = CGAffineTransformMakeRotation(CGFloat(M_PI)/180.0)
}

    

}