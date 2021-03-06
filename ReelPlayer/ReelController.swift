//
//  ReelController.swift
//  ReelPlayer
//
//  Created by John Hawley and Bo Jacobson on 12/10/14.
//  Copyright (c) 2014 RealtoReal. All rights reserved.
//

import UIKit
import AVFoundation


//// 12/17/14 - engine in progress...
var engine = AVAudioEngine()
var input = engine.inputNode
var mixer = engine.mainMixerNode
var output = engine.outputNode
var format = input.inputFormatForBus(0)

class ReelController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var recorder: AVAudioRecorder!
    
    var player:AVAudioPlayer!
    
    @IBOutlet var reels: UIImageView!

    @IBOutlet var recordButton: UIButton!
    
    @IBOutlet var pauseButton: UIButton!
    
    @IBOutlet var playButton: UIButton!
    
    @IBOutlet var fastforwardButton: UIButton!
    
    @IBOutlet var rewindButton: UIButton!
    
    @IBOutlet var statusLabel: UILabel!
    
    //record enable buttons
    @IBOutlet var track1Button: UIButton!
    
    @IBOutlet var track2Button: UIButton!
    
    @IBOutlet var track3Button: UIButton!
    
    @IBOutlet var track4Button: UIButton!
    
    
    var meterTimer:NSTimer!
    
    var soundFileURL:NSURL?
    
    var error:NSError?

    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.enabled = false
        playButton.enabled = false
        setSessionPlayback()
        askForNotifications()
        
        track1Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        track2Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        track3Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        track4Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        engine.connect(input, to: mixer, format: format)
        engine.connect(mixer, to: output, format: format)
    }
    
    func updateAudioMeter(timer:NSTimer) {
        
        if recorder.recording {
            let dFormat = "%02d"
            let min:Int = Int(recorder.currentTime / 60)
            let sec:Int = Int(recorder.currentTime % 60)
            let s = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            statusLabel.text = s
            recorder.updateMeters()
            var apc0 = recorder.averagePowerForChannel(0)
            var peak0 = recorder.peakPowerForChannel(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        recorder = nil
        player = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let TrackPopupController = segue.destinationViewController as UIViewController
            TrackPopupController.modalPresentationStyle = UIModalPresentationStyle.Popover
            TrackPopupController.popoverPresentationController!.delegate = self
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    
    @IBAction func record(sender: UIButton) {
        if player != nil && player.playing {
            player.stop()
        }
        
        if recorder == nil {
            playButton.enabled = false
            pauseButton.enabled = true
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.recording {
            recorder.pause()
            
        } else {
            playButton.enabled = false
            pauseButton.enabled = true
            //            recorder.record()
            recordWithPermission(false)
        }

    }
    

    @IBAction func pause(sender: UIButton) {
        recorder.stop()
        meterTimer.invalidate()
        
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setActive(false, error: &error) {
            println("could not make session inactive")
            if let e = error {
                println(e.localizedDescription)
                return
            }
        }
        playButton.enabled = true
        pauseButton.enabled = false
        recordButton.enabled = true
        recorder = nil
    }
    
    
    @IBAction func play(sender: UIButton) {
        play()
    }
    
    func play() {
        
        var error: NSError?
        // recorder might be nil
        // self.player = AVAudioPlayer(contentsOfURL: recorder.url, error: &error)
        self.player = AVAudioPlayer(contentsOfURL: soundFileURL!, error: &error)
        if player == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        }
        player.delegate = self
        player.prepareToPlay()
        player.volume = 1.0
        player.play()
    }
    
    
    func setupRecorder() {
        var format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        var currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        println(currentFileName)
        
        var dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var docsDir: AnyObject = dirPaths[0]
        var soundFilePath = docsDir.stringByAppendingPathComponent(currentFileName)
        soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(soundFilePath) {
            // probably won't happen. want to do something about it?
            println("sound exists")
        }
        
        var recordSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        var error: NSError?
        recorder = AVAudioRecorder(URL: soundFileURL!, settings: recordSettings, error: &error)
        if let e = error {
            println(e.localizedDescription)
        } else {
            recorder.delegate = self
            recorder.meteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        }
    }
    
    func recordWithPermission(setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    println("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                        target:self,
                        selector:"updateAudioMeter:",
                        userInfo:nil,
                        repeats:true)
                } else {
                    println("Permission to record not granted")
                }
            })
        } else {
            println("requestRecordPermission unrecognized")
        }
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayback, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
    
    func setSessionPlayAndRecord() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
    
    func deleteAllRecordings() {
        var docsDir =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var fileManager = NSFileManager.defaultManager()
        var error: NSError?
        var files = fileManager.contentsOfDirectoryAtPath(docsDir, error: &error) as [String]
        if let e = error {
            println(e.localizedDescription)
        }
        var recordings = files.filter( { (name: String) -> Bool in
            return name.hasSuffix("m4a")
        })
        for var i = 0; i < recordings.count; i++ {
            var path = docsDir + "/" + recordings[i]
            
            println("removing \(path)")
            if !fileManager.removeItemAtPath(path, error: &error) {
                NSLog("could not remove \(path)")
            }
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
    
    func askForNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"background:",
            name:UIApplicationWillResignActiveNotification,
            object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"foreground:",
            name:UIApplicationWillEnterForegroundNotification,
            object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"routeChange:",
            name:AVAudioSessionRouteChangeNotification,
            object:nil)
    }
    
    func background(notification:NSNotification) {
        println("background")
    }
    
    func foreground(notification:NSNotification) {
        println("foreground")
    }
    
    
    func routeChange(notification:NSNotification) {
        //      let userInfo:Dictionary<String,String!> = notification.userInfo as Dictionary<String,String!>
        //      let userInfo = notification.userInfo as Dictionary<String,[AnyObject]!>
        //  var reason = userInfo[AVAudioSessionRouteChangeReasonKey]
        
        // var userInfo: [NSObject : AnyObject]? { get }
        //let AVAudioSessionRouteChangeReasonKey: NSString!
        
        /*
        if let reason = notification.userInfo[AVAudioSessionRouteChangeReasonKey] as? NSNumber  {
        }
        
        if let info = notification.userInfo as? Dictionary<String,String> {
        
        
        if let rs = info["AVAudioSessionRouteChangeReasonKey"] {
        var reason =  rs.toInt()!
        
        if rs.integerValue == Int(AVAudioSessionRouteChangeReason.NewDeviceAvailable.toRaw()) {
        }
        
        switch reason  {
        case AVAudioSessionRouteChangeReason
        println("new device")
        }
        
        }
        }
        
        var description = userInfo[AVAudioSessionRouteChangePreviousRouteKey]
        */
        /*
        //        var reason = info.valueForKey(AVAudioSessionRouteChangeReasonKey) as UInt
        //var reason = info.valueForKey(AVAudioSessionRouteChangeReasonKey) as AVAudioSessionRouteChangeReason.Raw
        //var description = info.valueForKey(AVAudioSessionRouteChangePreviousRouteKey) as String
        println(description)
        
        switch reason {
        case AVAudioSessionRouteChangeReason.NewDeviceAvailable.toRaw():
        println("new device")
        case AVAudioSessionRouteChangeReason.OldDeviceUnavailable.toRaw():
        println("old device unavail")
        //case AVAudioSessionRouteChangeReasonCategoryChange
        //case AVAudioSessionRouteChangeReasonOverride
        //case AVAudioSessionRouteChangeReasonWakeFromSleep
        //case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory
        
        default:
        println("something or other")
        }
        */
    }

// changes color from black to red on tracks 1-4 (record enable). Doesn't allow you to have more than one red.
    
    // track 1 rec enable color red
    @IBAction func track1Button(sender: UIButton) {
    
        
        if track1Button.titleColorForState(UIControlState.Normal) == UIColor.whiteColor() {
            track1Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)}
        else {
            track1Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track2Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track1Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track3Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track1Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track4Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track1Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
    }
    
    
    // track 2 rec enable color red
    @IBAction func track2Button(sender: UIButton) {
    
        if track2Button.titleColorForState(UIControlState.Normal) == UIColor.whiteColor() {
            track2Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)}
        else {
            track2Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track1Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track2Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track3Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track2Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track4Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track2Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
    }
    
    
    // track 3 rec enable color red
    @IBAction func track3Button(sender: AnyObject){
        if track3Button.titleColorForState(UIControlState.Normal) == UIColor.whiteColor() {
            track3Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)}
        else {
            track3Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track1Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track3Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track2Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track3Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track4Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track3Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    // track 4 rec enable color red
    @IBAction func track4Button(sender: UIButton){
        if track4Button.titleColorForState(UIControlState.Normal) == UIColor.whiteColor() {
            track4Button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)}
        else {
            track4Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track1Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track4Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track2Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track4Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if track3Button.titleColorForState(UIControlState.Normal) == UIColor.redColor() {
            track4Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
    }
    ///////////////////////////////////////////
    
    @IBAction func reelmenuspin(sender: UIButton) {
    }

    ///// 12/17/14 If user is interrupted, code needs an exit
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        /* The audio session is deactivated here */
        recorder.stop()
        player.stop()
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer!,
        withOptions flags: Int) {
            if flags == AVAudioSessionInterruptionFlags_ShouldResume{
                player.play()
            }
    }
    
}

// MARK: AVAudioRecorderDelegate
extension ReelController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!,
        successfully flag: Bool) {
            println("finished recording \(flag)")
            pauseButton.enabled = false
            playButton.enabled = true
            recordButton.setTitle("Record", forState:.Normal)
            
            // iOS8 and later
            var alert = UIAlertController(title: "Recorder",
                message: "Finished Recording",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Keep", style: .Default, handler: {action in
                println("keep was tapped")
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {action in
                println("delete was tapped")
                self.recorder.deleteRecording()
            }))
            self.presentViewController(alert, animated:true, completion:nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!,
        error: NSError!) {
            println("\(error.localizedDescription)")
    }
}

// MARK: AVAudioPlayerDelegate
extension ReelController : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        println("finished playing \(flag)")
        recordButton.enabled = true
        pauseButton.enabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("\(error.localizedDescription)")
    }
    

    
}



