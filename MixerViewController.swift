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
    

@IBOutlet var mute1: UILabel!
@IBOutlet var mute2: UILabel!
@IBOutlet var mute3: UILabel!
@IBOutlet var mute4: UILabel!
    
// MUTE BUTTONS 
// Mute 1
@IBAction func mutebutton1(sender: UIButton) {
        
       if mute1.textColor == UIColor.whiteColor() {
        self.mute1.textColor = UIColor(red: 10, green: 0.0, blue: 0.0, alpha: 1.0)
        }
       else {
        self.mute1.textColor = UIColor.whiteColor()
        }
}
    
//Mute 2
@IBAction func mutebutton2(sender: UIButton) {
    
    if mute2.textColor == UIColor.whiteColor() {
        self.mute2.textColor = UIColor(red: 10, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    else {
        self.mute2.textColor = UIColor.whiteColor()
        }
}
    
// Mute 3
@IBAction func mutebutton3(sender: UIButton) {
    
    if mute3.textColor == UIColor.whiteColor() {
        self.mute3.textColor = UIColor(red: 10, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    else {
        self.mute3.textColor = UIColor.whiteColor()
    }
    
}
    
// Mute 4
@IBAction func mutebutton4(sender: AnyObject) {
    
    if mute4.textColor == UIColor.whiteColor() {
        self.mute4.textColor = UIColor(red: 10, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    else {
        self.mute4.textColor = UIColor.whiteColor()
    }
    
    
}
    
override func viewDidLoad() {
        super.viewDidLoad()
        configuretrack1slider()
        configuretrack2slider()
        configuretrack3slider()
        configuretrack4slider()
    
        mute1.textColor = UIColor.whiteColor()
        mute2.textColor = UIColor.whiteColor()
        mute3.textColor = UIColor.whiteColor()
        mute4.textColor = UIColor.whiteColor()
    
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
    

    
// MARK: Actions   DO WE NEED THIS JOHN????? -- NEED? no WANT? mmmmm kinda? good for debugging
    
func sliderValueDidChange(slider: UISlider) {
        NSLog("A slider changed its value: \(slider).")
    }


}