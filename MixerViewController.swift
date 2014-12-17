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

@IBOutlet weak var slider1view: UIView!
    
 override func viewDidLoad() {
        super.viewDidLoad()
        configuretrack1slider()
    
    }
    

    func configuretrack1slider() {
    
        let thumbImage = UIImage(named: "faderknob1")
        track1slider.setThumbImage(thumbImage, forState: .Normal)

       
        
        let sliderangle = CGFloat(-M_PI_2)
        track1slider.transform = CGAffineTransformRotate(track1slider.transform, sliderangle)
        
        
         track1slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
    
    }
    
    
    // MARK: Actions
    
    func sliderValueDidChange(slider: UISlider) {
        NSLog("A slider changed its value: \(slider).")
    }


}