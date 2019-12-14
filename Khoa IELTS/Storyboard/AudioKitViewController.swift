////
////  AudioKitViewController.swift
////  Khoa IELTS
////
////  Created by ColWorx on 15/01/2019.
////  Copyright © 2019 ast. All rights reserved.
////
//
//import UIKit
//import AudioKit
//import AudioKitUI
//
//class AudioKitViewController: UIViewController {
//
//    @IBOutlet weak var audioPlot: EZAudioPlot!
//    
//    var labelFrequencyValue : UILabel!
//    var labelAmplitudeValue : UILabel!
//    var labelSharpValue : UILabel!
//    var labelFlatValue : UILabel!
//    
//    let mic = AKMicrophone()
//    var tracker : AKFrequencyTracker!
//    var silence : AKBooster!
//    
//    
//    var noteFrequencies : [Float] = [0.0]
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        AudioKit.output = mic
////
////        tracker = AKFrequencyTracker.init(self.mic, hopSize: 200, peakCount: 2000)
////
////        updateUI()
//        let labelSing = UILabel(frame: CGRect(x: 0, y: 28, width: view.frame.width, height: 50))
//        labelSing.text = "Sing into the Microphone"
//        labelSing.textAlignment = .center
//        labelSing.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold) //System Font Bold
//        labelSing.textColor = UIColor.white
//        labelSing.backgroundColor = UIColor(red: 2/255, green: 181/255, blue: 31/255, alpha: 1.0)
//        view.addSubview(labelSing)
//        
//        let labelFrequency = UILabel(frame: CGRect(x: 16, y: 86, width: 85.5, height: 20.5))
//        labelFrequency.text = "Frequency:"
//        view.addSubview(labelFrequency)
//        
//        labelFrequencyValue = UILabel(frame: CGRect(x: view.frame.width-70, y: 86, width: 50, height: 20.5))
//        labelFrequencyValue.text = "0"
//        labelFrequencyValue.textAlignment = .right
//        view.addSubview(labelFrequencyValue)
//        
//        let labelAmplitude = UILabel(frame: CGRect(x: 16, y: 114.5, width: 85.5, height: 20.5))
//        labelAmplitude.text = "Amplitude:"
//        view.addSubview(labelAmplitude)
//        
//        labelAmplitudeValue = UILabel(frame: CGRect(x: view.frame.width-70, y: 114.5, width: 50, height: 20.5))
//        labelAmplitudeValue.text = "0"
//        labelAmplitudeValue.textAlignment = .right
//        view.addSubview(labelAmplitudeValue)
//        
//        let labelSharp = UILabel(frame: CGRect(x: 16, y: 142, width: 111.5, height: 20.5))
//        labelSharp.text = "Note (Sharps):"
//        view.addSubview(labelSharp)
//        
//        labelSharpValue = UILabel(frame: CGRect(x: view.frame.width-70, y: 142, width: 50, height: 20.5))
//        labelSharpValue.text = "C4"
//        labelSharpValue.textAlignment = .right
//        view.addSubview(labelSharpValue)
//        
//        let labelFlat = UILabel(frame: CGRect(x: 16, y: 170.5, width: 94, height: 20.5))
//        labelFlat.text = "Note (Flats):"
//        view.addSubview(labelFlat)
//        
//        labelFlatValue = UILabel(frame: CGRect(x: view.frame.width-70, y: 170.5, width: 50, height: 20.5))
//        labelFlatValue.text = "F4"
//        labelFlatValue.textAlignment = .right
//        view.addSubview(labelFlatValue)
//        
//        let labelPlot = UILabel(frame: CGRect(x: 0, y: 199, width: view.frame.width, height: 21.5))
//        labelPlot.text = "Audio Input Plot"
//        labelPlot.textAlignment = .center
//        view.addSubview(labelPlot)
//        
//        
//        tracker = AKFrequencyTracker.init(mic)
//        let silence = AKBooster(tracker, gain: 0)
//        AudioKit.output = silence
//
//        
//        setupPlot()
//        
//        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        do {
//            
//            try AudioKit.start()
//            
//        } catch {
//            
//        }
//    }
//    
//    func setupPlot() {
//        let plot = AKNodeOutputPlot(mic, frame: audioPlot.bounds)
//        plot.plotType = .rolling
//        plot.shouldFill = true
//        plot.shouldMirror = true
//        plot.color = UIColor.blue
//        audioPlot.addSubview(plot)
//    }
//    
//    @objc func updateUI() {
////        noteFrequencies.append(0.0)
////        if tracker.amplitude > 0.1 {
////            labelFrequencyValue.text = String(format: "%0.1f", tracker.frequency)
////
////            var frequency = Float(tracker.frequency)
//////            if frequency == noteFrequencies[noteFrequencies.count-1] {
//////
//////            } else {
//////
//////            }
////            noteFrequencies.append(frequency)
////            print(noteFrequencies)
////            while (frequency > Float(noteFrequencies[noteFrequencies.count-1])){
////                //frequency = frequency / 2.0
//////                noteFrequencies.append(frequency)
//////                print(noteFrequencies)
////            }
////            while (frequency < Float(noteFrequencies[0])) {
////                frequency = frequency * 2.0
////            }
////
////            var minDistance : Float = 10000.0
////            for i in 0..<noteFrequencies.count {
////                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
////                if (distance < minDistance) {
////                    minDistance = distance
////                }
////            }
////        }
//        labelAmplitudeValue.text = String(format: "%0.2f", tracker.amplitude)
//        labelFrequencyValue.text = String(format: "%0.1f", tracker.frequency)
//        let frequency = Float(tracker.frequency)
//        if tracker.amplitude > 0.1 {
//            noteFrequencies.append(frequency)
//        } else {
//            noteFrequencies.append(0.0)
//        }
////        print(noteFrequencies)
//        print("Frequency: \(tracker.frequency), Amplitude: \(tracker.amplitude)")
//    }
//}
