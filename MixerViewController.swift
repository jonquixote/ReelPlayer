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
    
@IBOutlet var track2slider: UISlider!
    
@IBOutlet var track3slider: UISlider!

@IBOutlet var track4slider: UISlider!
    
@IBOutlet weak var slider1view: UIView! // JOHN, what is this????
 
    
override func viewDidLoad() {
        super.viewDidLoad()
        configuretrack1slider()
        configuretrack2slider()
        configuretrack3slider()
        configuretrack4slider()
    
    }
    
    
    
    
// CONFIGURE TRACK SLIDERS //
    func configuretrack1slider() {
    
        let thumbImage = UIImage(named: "faderknob1")
        track1slider.setThumbImage(thumbImage, forState: .Normal)

       
        
        let sliderangle = CGFloat(-M_PI_2)
        track1slider.transform = CGAffineTransformRotate(track1slider.transform, sliderangle)
        
        
         track1slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
    
        
        
    }
    func configuretrack2slider() {
        
        let thumbImage = UIImage(named: "faderknob1")
        track2slider.setThumbImage(thumbImage, forState: .Normal)
        
        
        
        let sliderangle = CGFloat(-M_PI_2)
        track2slider.transform = CGAffineTransformRotate(track2slider.transform, sliderangle)
        
        
        track2slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        
        
        
    }
    func configuretrack3slider() {
        
        let thumbImage = UIImage(named: "faderknob1")
        track3slider.setThumbImage(thumbImage, forState: .Normal)
        
        
        
        let sliderangle = CGFloat(-M_PI_2)
        track3slider.transform = CGAffineTransformRotate(track3slider.transform, sliderangle)
        
        
        track3slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        
        
        
    }
    func configuretrack4slider() {
        
        let thumbImage = UIImage(named: "faderknob1")
        track4slider.setThumbImage(thumbImage, forState: .Normal)
        
        
        
        let sliderangle = CGFloat(-M_PI_2)
        track4slider.transform = CGAffineTransformRotate(track4slider.transform, sliderangle)
        
        
        track4slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        
        
        
    }
// END CONFIGURE TRACK SLIDERS //
    

    
// MARK: Actions   DO WE NEED THIS JOHN????? 
    
func sliderValueDidChange(slider: UISlider) {
        NSLog("A slider changed its value: \(slider).")
    }


}