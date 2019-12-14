//
//  RecordingScreenViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 03/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftSiriWaveformView
import Speech
import PKHUD
import AudioKit
import FirebaseStorage
import FirebaseDatabase
//RUTTAB
import SVProgressHUD
//END RUTTAB
class RecordingScreenViewController: UIViewController, AVAudioRecorderDelegate, AVSpeechSynthesizerDelegate {
    
    //MARK:- Properties
    //06-05-2019
    var uploadToFirebaseDictionary = [String : AnyObject]()
    var uploadToFirebaseArray = Array<String>()
    var audioReference : StorageReference {
        return Storage.storage().reference().child("Voiceover")
    }
    //END 06-05-2019
    
    var part2 = Bool()
    var part2Initialize = Bool()
    var part = Bool()
    //18 - 01 - 2019
//    var textToSpeech = [[String: AnyObject]]()
    var categoryname = String()

    var indexedTopicContent = String()
    var topicNames = [String]()
    var topicContents = [String]()
    var topicFrequencies = [[Float]]()
    var seperateStringByWordsArray = [String]()
    var seperateStringByWordsCounter = 0
    var vocabsInStringsCounter = 0
    
    var repetitionOfWordsCounter = [Int]()
    var totalWordsInSentenceCounter = [Int]()
    var vocabsInSentenceCounter = [Int]()
    var index = 0
    var numberOfSentences = 0
    var punctuatedStrings = [String]()
    var topicSeparatedBySentences = [[String]]()
    
    
    var hypotheticalSituation = 0
    var modalVerbs = 0
    
    //21 - 01 - 2019
    
    var collocationsInSentencesCounter = 0
    var collocationsInSentences = [[String:String]]()
    
    let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
    let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
    
    
    //RUTTAB
    var isTestNow: Bool = false
//    var questionsWithMultipleParts = Array<Dictionary<String,AnyObject>>()
//
//    /**
//     This value is used to track which part of a question is being displayed
//     A question has three parts
//     This value goes from 0 -2
//     **/
//    var currentQuestionPart = 0
    private let audioEngine = AVAudioEngine()
    var audioPlayer: AVAudioPlayer?
    var player: AVPlayer?
    var playerObserver: NSKeyValueObservation?
    var part2QuestionRead = Bool()
    var numberOfLines = 0
    //END RUTTAB
    
    //Old Code
    let mic = AKMicrophone()
    var tracker : AKFrequencyTracker!
    var silence : AKBooster!
    var currentFrequency = [Float]()
    var noteFrequencies = [[Float]]()
    var insertFirstItem = false
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    let speechSynthesizer = AVSpeechSynthesizer()
    
    
    var startRecordingTimer = Timer()
    var callTextToSpeech  = Timer()
    var updateSoundWaves = Timer()
    var updateUITimer = Timer()
    
    
    var data = Dictionary<String,AnyObject>()
    var urls = [URL]()
    var topicCount = Int()
    var change:CGFloat = 0.01
    var recordingStart = 0
    var recordingTimer = 0
    var globalIndex = 0
    var tableViewReloader = 1
    var toRootViewController :Bool = false
    
    var textToSpeech = [[String: AnyObject]]()
    
    var textToSpeechCounter = 0
    
    var recordSampleResult : Bool = false
    var resumeRecording = false
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var mainHeadingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var audioWave: SwiftSiriWaveformView!
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet weak var subtitleSwitch: UISwitch!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var nextQuesBtn: RoundedButtons!
    @IBOutlet weak var timerImageView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUoContectView: UIView!
    @IBOutlet weak var subtitleView: UIView!
    @IBOutlet weak var practicePaused: UILabel!
    @IBOutlet weak var soundWaveView: UIView!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var part2View: UIView!
    
    
    //MARK:- VC LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 25.0
        speechSynthesizer.delegate = self
//        speechRecognizer?.delegate = self
        
        
        exitBtn.isHidden = true
        timerImageView.isHidden = true
        subtitleSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        //RUTTAB
//        if isTestNow {
//            subtitleSwitch.isHidden = true
//            subtitleView.isHidden = true
//            subtitleLabel.isHidden = true
//        } else {
//            subtitleSwitch.isHidden = false
//            subtitleView.isHidden = false
//            subtitleLabel.isHidden = false
//        }
        //END RUTTAB
        
        //RUTTAB
//        if isTestNow {
//            data.removeAll()
//            data = questionsWithMultipleParts[currentQuestionPart]
//        }
        //END RUTTAB
        
        if audioReference != nil {
            print("AUDIO REFERENCE FOUND")
        }
        
        mainHeadingLabel.text = data["topicTitle"] as? String
        topicCount = (data["topics"] as! Array<String>).count
        
        
        self.popUoContectView.layer.cornerRadius = 10.0;
        self.popUpView.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.60)
        
        
        audioWave.amplitude = 0.1
        audioWave.numberOfWaves = 10
        audioWave.waveColor = UIColor(red: 62.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1)
        
        tracker = AKFrequencyTracker.init(mic)
        let silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        
        part2QuestionRead = false
        if data["part"] as! String == "Part - 2" {
            //mainHeadingLabel.isHidden = true
            //tableView.isHidden = true
            //part2View.isHidden = false
            part2 = true
            //part2Initialize = true
            //part = true
            recordingTimer = 0
            mainHeadingLabel.isHidden = false
            tableView.isHidden = false
            part2View.isHidden = true
            part2Initialize = true
            part = false

        } else {
            recordingTimer = 0
            mainHeadingLabel.isHidden = false
            tableView.isHidden = false
            part2View.isHidden = true
            part2Initialize = true
            part = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if toRootViewController {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    //RUTTAB
    override func viewWillDisappear(_ animated: Bool) {
        
        print("Audio player disapperaing")
        
        if audioPlayer != nil {
            audioPlayer?.pause()
            
            audioPlayer = nil
        }
        
        if player != nil {
            player?.pause()
            player = nil
        }
        
        if playerObserver != nil {
            playerObserver = nil
        }
        
        //There is already a tap installed on that bus and that you can't have another one. App was breaking after coming back to this screen. This code prevents it
        if audioEngine != nil {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        cancelTimer()
    }
    //END RUTTAB
    
    //MARK:- ACTIONS
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func startRecordingTapped(_ sender: Any) {
        
        if(globalIndex == topicCount) {
            cancelTimer()
            finishRecording(false)
            nextQuesBtn.alpha = 0.5
            nextQuesBtn.isEnabled = false
            popUpView.isHidden = false
            addFrequencies()
            return
        }
        if recordingStart == 0 {
            recordingSession = AVAudioSession.sharedInstance()
            do {
                recordingSession.requestRecordPermission() { [unowned self] allowed in
                    DispatchQueue.main.async {
                        if allowed {
                            let image = UIImage(named: "stop_btn")
                            self.recordBtn.setImage(image, for: .normal)
                            self.recordingStart = 1
                            self.readSentence()
                        } else {
                            let alert = UIAlertController(title: "Alert", message: "You need allow microphone access from Settings", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alert.addAction(alertAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            return
        } else {
            //WASIQ
//            self.countdownTimer.text = "00:00:00"
//            recordingTimer = 0
//            addFrequencies()
//            recordingStart = 0
//            popUpView.isHidden = false
//            audioRecorder.pause()
//            cancelTimer()
            //END WASIQ
            
            //RUTTAB
            //self.countdownTimer.text = "00:00:00"
            //recordingTimer = 0
            addFrequencies()
            //recordingStart = 0
            popUpView.isHidden = false
            audioRecorder.pause()
            cancelTimer()
            //END RUTTAB
            
        }
    }
    @IBAction func exitBtnTapped(_ sender: Any) {
        
        resumeRecording = true
        
        startRecordingTimer.invalidate()
        audioRecorder.pause()
        popUpView.isHidden = false
    }
    @IBAction func subtitleOnOff(_ sender: Any) {
        if subtitleSwitch.isOn {
            subtitleView.isHidden = false
        } else {
            subtitleView.isHidden = true
        }
    }
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        //WASIQ
        if(globalIndex == topicCount) {
            self.popUpView.isHidden = true
            return
        }
        //END WASIQ
        
        //RUTTAB
//        if (globalIndex == topicCount && currentQuestionPart <= 2) {
//            self.loadNextQuestionPart()
//        }
//        if(globalIndex == topicCount && currentQuestionPart == 2) {
//            self.popUpView.isHidden = true
//            return
  //      }
        //END RUTTAB
        
        resumeRecording = true
        self.popUpView.isHidden = true
        
        startRecordingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        updateSoundWaves = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(refreshAudioView(_:)), userInfo: nil, repeats: true)
        updateUITimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(getFrequencies), userInfo: nil, repeats: true)
        
        //RUTTAB 21oct19
        startRecordingTimer.tolerance = 0.1
        RunLoop.current.add(startRecordingTimer, forMode: RunLoop.Mode.common)
        RunLoop.current.add(updateSoundWaves, forMode: RunLoop.Mode.common)
        RunLoop.current.add(updateUITimer, forMode: RunLoop.Mode.common)
        //END RUTTAB
        
    }
    @IBAction func startOverBtnTapped(_ sender: Any) {
        finishRecording(true)
        self.popUpView.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextQuesBtnTapped(_ sender: Any) {
        
        //RUTTAB
        self.countdownTimer.text = "00:00:00"
        recordingTimer = 0
        recordingStart = 0
        //END RUTTAB
        
        self.countdownTimer.textColor = UIColor.white
        recordingTimer = 0
        popUpView.isHidden = true
        readSentence()
    }
    @available(iOS 11.0, *)
    @IBAction func endTestBtnTapped(_ sender: Any) {
        self.countdownTimer.textColor = UIColor.white
        popUpView.isHidden = true
        toRootViewController = true
        audioRecorder.stop()
        audioRecorder = nil
        cancelTimer()
        requestTranscribePermissions()
    }
    
    //MARK:- Functions
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if part2 {
            mainHeadingLabel.isHidden = false
            tableView.isHidden = false
            part2View.isHidden = true
            self.tableView.reloadData()
            timerAction()
            return
        }
        
        updateSoundWaves.invalidate()
        if globalIndex != 0 {
            audioRecorder.stop()
            audioRecorder = nil
        }
        if(globalIndex > topicCount) {
            return
        }
        loadRecordingUI()
        startRecordingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        callTextToSpeech = Timer(timeInterval: TimeInterval(recordingTimer), target: self, selector: #selector(readSentence), userInfo: nil, repeats: true)
        updateSoundWaves = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(refreshAudioView(_:)), userInfo: nil, repeats: true)
        
        //RUTTAB 21oct19
        startRecordingTimer.tolerance = 0.1
        RunLoop.current.add(startRecordingTimer, forMode: RunLoop.Mode.common)
        RunLoop.current.add(updateSoundWaves, forMode: RunLoop.Mode.common)
        //END RUTTAB
        
    }
    @objc func refreshAudioView(_:Timer) {
        if self.audioWave.amplitude <= self.audioWave.idleAmplitude || self.audioWave.amplitude > 1.0 {
            self.change *= -1.0
        }
        self.audioWave.amplitude += self.change
    }
    @objc func readSentence () {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.spokenAudio)
            try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try recordingSession.setActive(true)
        } catch {
            
        }
        
        recordBtn.isEnabled = false
        updateSoundWaves.invalidate()
        
        
        if insertFirstItem {
            noteFrequencies.append(currentFrequency)
            insertFirstItem = false
        } else {
            if noteFrequencies.isEmpty {
                insertFirstItem = true
            } else {
                noteFrequencies.append(currentFrequency)
            }
        }
        if globalIndex == (data["topics"] as! Array<String>).count {
            noteFrequencies.append(currentFrequency)
            finishRecording(true)
            return
        }
        if !part2Initialize {
            noteFrequencies.append(currentFrequency)
            finishRecording(true)
            return
        }
        currentFrequency = [10.0]
//        if part2 {
//            let speech   = AVSpeechUtterance(string: "Now, I'm going to give you a topic, and I'd like you to talk about it for one to two minutes. Before you talk, you'll have one minute to think about what you're going to say. You can make some notes if you wish... Here's some paper and a pencil for making notes, and here's your topic")
//            speech.voice = AVSpeechSynthesisVoice(language: "en-US")
//            //speechSynthesizer.speak(speech)
//            playAudioFile()
//            return
//        }
        
        self.tableView.reloadData()
        tableViewReloader = tableViewReloader + 1
        let sentence = (data["topics"] as! Array<String>)[globalIndex]
        let speech   = AVSpeechUtterance(string: sentence)
        speech.voice = AVSpeechSynthesisVoice(language: "en-US")
        speech.volume = 1.0
        
       //speechSynthesizer.speak(speech)
        
        
        let topic = data["topics"] as! Array<String>
        let subsection = topic[globalIndex]
        var audioUrl: String = ""

        if part2 {
//            if let range = subsection.range(of: "You should say:") {
//                let value = subsection[range.lowerBound...]
//                print(value) // prints "123.456.7891"
//                audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(value).wav"
//            }
            
            audioUrl = createAudioUrl()
        } else {
            var value = topic[globalIndex]
            var title = data["title"]! as! String
//            if value.contains("?") && title  != "Personal Matters & Hobbies" {
//               value = value.replacingOccurrences(of: "?", with: "")
//            }

            var part = data["part"] as! String
            
            if value.contains("?") {
                if title  != "Personal Matters & Hobbies" {
                    value = value.replacingOccurrences(of: "?", with: "")
                    
                } else if title  == "Personal Matters & Hobbies" && part == "Part - 3" {
                    var topicTitle = data["topicTitle"] as! String
                    if topicTitle != "Arrive on Time" {
                        value = value.replacingOccurrences(of: "?", with: "")
                    }
                }
            }

            //if part3 {
            if value.contains(":") {
                value = value.replacingOccurrences(of: ":", with: "")
            }
//            if value.contains("?") {
//                value = value.replacingOccurrences(of: "?", with: "")
//            }
            if value.contains(".") {
                value = value.replacingOccurrences(of: ".", with: "")
            }
            //}
            
            if value.contains("?") {
                if title  != "Personal Matters & Hobbies" {
                    value = value.replacingOccurrences(of: "?", with: "")
                    
                } else if title  == "Personal Matters & Hobbies" && part == "Part - 3" {
                    var topicTitle = data["topicTitle"] as! String
                    if topicTitle != "Arrive on Time" {
                        value = value.replacingOccurrences(of: "?", with: "")
                    }
                }
            }
            
            if part == "Part - 3" {
                value = value.trimmingCharacters(in: .whitespaces)
            }

            
            audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(value).wav"
        }


        playAudioFile(audioUrl: audioUrl)
        
    }
    
    
    
    @objc func timerAction() {
        recordingTimer = recordingTimer + 1
        if part2 {
            if part2Initialize {
                part2Initialize = false
                startRecordingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                
                startRecordingTimer.tolerance = 0.1
                RunLoop.current.add(startRecordingTimer, forMode: RunLoop.Mode.common)
            }
            if recordingTimer < 60 {

                timerImageView.isHidden = false
                let timer = recordingTimer - 60
                if timer >= 10 {
                    countdownTimer.text = "01:\(timer)"
                } else {
                    countdownTimer.text = "01:0\(timer)"
                }
//                return
            } else {
                recordingTimer = 0
                part2 = false
                loadRecordingUI()
                callTextToSpeech = Timer(timeInterval: TimeInterval(recordingTimer), target: self, selector: #selector(readSentence), userInfo: nil, repeats: true)
                updateSoundWaves = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(refreshAudioView(_:)), userInfo: nil, repeats: true)
                
            }
        }
        
//        if recordingTimer < 0 {
//            if recordingTimer >= 10 {
//                countdownTimer.text = "00:\(recordingTimer)"
//            } else {
//                countdownTimer.text = "00:0\(recordingTimer)"
//            }
//        }
//        if recordingTimer == 0 {
//            countdownTimer.text = "00:00"
//            if(topicCount != globalIndex || topicCount == globalIndex) {
//                readSentence()
//                recordingTimer = 0
//                cancelTimer()
//            }
//        }
        countdownTimer.text = timeString(time: TimeInterval(recordingTimer))
    }
    
    @objc func getFrequencies() {
        print(tracker.frequency)
        let frequency = Float(tracker.frequency)
        currentFrequency.append(frequency)
    }
    
    func addFrequencies () {
        noteFrequencies.append(currentFrequency)
    }
    
    func cancelTimer () {
        startRecordingTimer.invalidate() //actual timer showing on screen
        updateSoundWaves.invalidate() //the wave showing on screen in being updated(going up and down).
        updateUITimer.invalidate()  //frequency of person speaking(maybe)
    }
    //Recording methods
    func loadRecordingUI() {
        recordingStart = 1
        exitBtn.isHidden = false
        backBtn.isHidden = true
        timerImageView.isHidden = false
        
        startRecording()
    }
    func getAudioDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
    func getAudioURL() -> URL{
        let topics = data["topics"] as? Array<String>
        let title = data["title"] as? String
        let part = data["part"] as? String
        
        if part == "Part - 2" {
            
        }
        
        let path = getAudioDirectory().appendingPathComponent(title!).appendingPathComponent(part!)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path.path) {
            do {
                try fileManager.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't create document directory")
            }
        }
        NSLog("Document directory is \(path)")
        
        if globalIndex != topics?.count {
            globalIndex = globalIndex + 1
        }
        urls.append(path.appendingPathComponent(topics![globalIndex-1]+".m4a"))
        return path.appendingPathComponent(topics![globalIndex-1]+".m4a")
    }
    func startRecording(){
        recordBtn.isEnabled = true
        let audioURL = getAudioURL()
        print(audioURL.absoluteString)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            try AudioKit.start()
            if resumeRecording {
//                recordSampleResult = audioRecorder.rec
            }
            recordSampleResult = audioRecorder.record(forDuration: TimeInterval(recordingTimer))

            updateUITimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(getFrequencies), userInfo: nil, repeats: true)
            if audioRecorder.prepareToRecord() {
                if recordSampleResult == false {
                    finishRecording(false)
                }
            }
            
        } catch {
            finishRecording(false)
        }
    }
    func finishRecording(_ success: Bool) {
        if success {
            cancelTimer()
            practicePaused.text = "Practice Completed"
            popUpView.isHidden = false
            do {
                try AudioKit.stop()
                mic!.stop()
            } catch {}
            
        }
    }
        
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(true)
        }
    }
    
    
    func timeString(time: TimeInterval) -> String {
        self.countdownTimer.textColor = UIColor.white
        let hours = Int(time) / 36000
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        if seconds > 10 {
            self.countdownTimer.textColor = UIColor.yellow
        }
        if seconds > 20 {
            self.countdownTimer.textColor = UIColor.orange
        }
        if seconds > 30 {
            self.countdownTimer.textColor = UIColor.red
        }
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

//MARK:- TableView functions
extension RecordingScreenViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if part2 {
            return (data["topics"] as! Array<String>).count
        } else {
            return tableViewReloader
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if part2 {
            return 180
        }
        
        //RUTTAB
        if numberOfLines == 2 {
            return 38
        } else if numberOfLines == 3 {
            return 52
        } else if numberOfLines == 4 {
            return 57
        } else  {
            numberOfLines = 0
            return 28
        }
        //END RUTTAB
        
        //
//        var height: CGFloat = 38
//
//        //we are just measuring height so we add a padding constant to give the label some room to breathe!
//        var padding: CGFloat = 5
        
        //estimate each cell's height
//        if let text = tableView.cellForRow(at: indexPath)!.textLabel!.text {
//            height =  estimateFrameForText(text: text).height + padding  //estimateFrameForText(text).height + padding
//        }
        //
        
        
       // return 28
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingScreenCell") as! RecordingScreenTableViewCell
        let topic = data["topics"] as! Array<String>
        

        cell.initializeCell(topic[indexPath.row], delegate: self)
        
        return cell
    }

}

//MARK:- Speech Recognition Functions
extension RecordingScreenViewController : SFSpeechRecognizerDelegate, SFSpeechRecognitionTaskDelegate {
//MARK: Permissions for Speech Recognition
    @available(iOS 11.0, *)
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    PKHUD.sharedHUD.contentView = PKHUDTextView.init(text: "Generating your result...")
                    PKHUD.sharedHUD.show()
                    self.extractFilenameAndPath()
                } else {
                    print("Transcription permission was declined.")
                    let alertController = UIAlertController(title: "Oops!", message: "You need to allow Speech Recognition to translate your answers.", preferredStyle: .alert)
                    
                    let okayBtn = UIAlertAction(title: "Ok", style: .default , handler: { _ in
                        let fileManager = FileManager.default
                        do {
                            let path = self.getAudioDirectory().appendingPathComponent(self.data["title"] as! String)
                            try fileManager.removeItem(at: path)
                        }
                        catch let error as NSError {
                            print("Ooops! Something went wrong: \(error)")
                        }
                        self.finishRecording(true)
                        self.popUpView.isHidden = true
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(okayBtn)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
//MARK: Extracting Files and Path
    @available(iOS 11.0, *)
    func extractFilenameAndPath() {
        let directoryName = urls.map { $0.lastPathComponent }
        let fileName : NSString = directoryName[textToSpeechCounter] as NSString
        
        //RUTTAB
        //if user doesnt speaks and exit the app. The application was breaking. thus i added this check
        var frequencies = [Float]()
        if !self.noteFrequencies.isEmpty {
            frequencies = self.noteFrequencies[textToSpeechCounter]
        }
        //END RUTTAB
        
        //WASIQ
        //let frequencies = self.noteFrequencies[textToSpeechCounter]
        //END WASIQ
        
        textToSpeech(fileName.deletingPathExtension, urls[textToSpeechCounter], frequencies)
    }
//MARK: Converting Audio into Text
    @available(iOS 11.0, *)
    func textToSpeech(_ fileName: String, _ filePath: URL, _ frequency: [Float]) {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        let request = SFSpeechURLRecognitionRequest(url: filePath)
        
        request.shouldReportPartialResults = false
        
        recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            guard error == nil else {
                PKHUD.sharedHUD.hide()
                print("ERROR: \(error?.localizedDescription)")
                let alertController = UIAlertController(title: "Oops!", message: "There is an error, please answer the questions again.", preferredStyle: .alert)
                
                let okayBtn = UIAlertAction(title: "Ok", style: .default , handler: { _ in
                    let fileManager = FileManager.default
                    do {
                        let path = self.getAudioDirectory().appendingPathComponent(self.data["title"] as! String)
                        try fileManager.removeItem(at: path)
                        self.uploadToFirebaseArray.removeAll()
                        
                        try AudioKit.stop()
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(okayBtn)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            if (result?.isFinal)! {
                self.textToSpeechCounter = self.textToSpeechCounter + 1

                print(fileName+": "+(result?.bestTranscription.formattedString)!)
                let dictionary = ["fileName" : fileName,
                                  "fileContent" : (result?.bestTranscription.formattedString)!,
                                  "frequency" : frequency] as [String : AnyObject]
                self.textToSpeech.append(dictionary)
                if self.part {
                    self.categorizedResult()
                    return
                }
                if(self.textToSpeechCounter == self.urls.count) {
//                    self.uploadToFirebase(fileName, true)
                    self.categorizedResult()
                } else {
//                    self.uploadToFirebase(fileName, false)
                    self.extractFilenameAndPath()
                }
            }
        })
//        if (recognizer?.isAvailable)! {
//            recognizer?.recognitionTask(with: request) { result, error in
//                guard error == nil else { print("Error: \(error!)"); return }
//                guard let result = result else { print("No result!"); return }
//                print(result.bestTranscription.formattedString)
//                self.textToSpeech[fileName] = result.bestTranscription.formattedString
//    //                self.extractFilenameAndPath()
//            }
//        } else {
//            print("Device doesn't support speech recognition")
//        }
    }
    func uploadToFirebase(_ fileName: String, _ lastFile: Bool) {
        let file = NSData(contentsOf: self.urls[textToSpeechCounter-1])
        if (file != nil) {
            var finalurl = ""
            let storage = Storage.storage()
            let metadata = StorageMetadata()
            metadata.contentType = "audio/aac"
            
            
            let userId = "-kLjddla34rKdld"
            let uploadRef = storage.reference().child("records/\(userId)/\(fileName).aac")

            let localUrl = self.urls[0]
            uploadRef.putFile(from: localUrl, metadata: nil) { metadata, error in
                guard let metadata = metadata else {
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                uploadRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    
                    finalurl = downloadURL.absoluteString
                    self.uploadToFirebaseDictionary[fileName] = finalurl as AnyObject
                    if lastFile {
                        let ref = Database.database().reference()
                        ref.child("Recordings").childByAutoId().setValue([
                            "userId" : userId,
                            "title" : self.data["topicTitle"] as? String as Any,
                            "content" : self.uploadToFirebaseDictionary,
                            "createTime" : Date().timeIntervalSince1970,
                            "size" : size
                            ] as [String : Any], withCompletionBlock: { (error, reference) in
                                if error != nil {
                                   print(error?.localizedDescription)
                                } else {
                                    let fileManager = FileManager.default
                                    do {
                                        let path = self.getAudioDirectory().appendingPathComponent(self.data["title"] as! String)
                                        try fileManager.removeItem(at: path)
                                    }
                                    catch let error as NSError {
                                        print("Ooops! Something went wrong: \(error)")
                                    }
                                }
                        })
                    }
                }
            }
        }
    }
}

//MARK:- Generating Result..
extension RecordingScreenViewController {
    @available(iOS 11.0, *)
    func categorizedResult() {
        for index in textToSpeech {
            topicNames.append(index["fileName"] as! String)
            topicContents.append(index["fileContent"] as! String)
            topicFrequencies.append(index["frequency"] as! [Float])
        }
        self.index = 0
        punctuate()
        
    }
    
    @available(iOS 11.0, *)
    func punctuate() {
        let url = URL(string: "http://bark.phon.ioc.ee/punctuator")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "text=" + topicContents[index]
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                let alertController = UIAlertController(title: "Error", message: "There is an error, please answer the question again.", preferredStyle: .alert)
                
                let okayBtn = UIAlertAction(title: "Ok", style: .default , handler: { _ in
                    let fileManager = FileManager.default
                    do {
                        let path = self.getAudioDirectory().appendingPathComponent(self.data["title"] as! String)
                        try fileManager.removeItem(at: path)
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(okayBtn)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
            self.punctuatedStrings.append(responseString!)
            self.index = self.index + 1
            
            if self.index != self.topicContents.count {
                self.punctuate()
            } else {
                DispatchQueue.main.async {
                    self.initializedResult()
                }
            }
        }
        task.resume()
    }
    @available(iOS 11.0, *)
    func initializedResult() {
        var index = 0
        for indexedContent in topicContents {
            var tempWordRepetition = 0
            indexedTopicContent = indexedContent
            var repetitionOfWords = [[String: Int]]()
            let totalWordCount = seperateStringByWords(for: indexedContent) //word counter + seperated words
            let vocabsInSentence = vocabsInStrings(for: indexedContent) // total vocabs in sentence
            for subString in seperateStringByWordsArray {
                let temp = repetitionOfWordCheck(for: subString)
                repetitionOfWords.append(temp)
            }
            for repetition in repetitionOfWords {
                for(_, value) in repetition {
                    if value > 1 {
                        tempWordRepetition = tempWordRepetition + 1
                    }
                }
            }
            
            totalWordsInSentenceCounter.append(totalWordCount)
            repetitionOfWordsCounter.append(tempWordRepetition)
            vocabsInSentenceCounter.append(vocabsInSentence)
            index = index + 1
        }
        //Punctuating Strings
        for subString in punctuatedStrings {
            topicSeparatedBySentences.append(subString.components(separatedBy: "."))
            numberOfSentences = numberOfSentences + subString.components(separatedBy: ".").count
        }
        //getting Hypothetical Situations
        for subString in topicSeparatedBySentences {
            for subStringSentence in subString {
                if subStringSentence == " " {
                    continue
                }
                if (subStringSentence.lowercased().range(of:"if") != nil) && (subStringSentence.lowercased().range(of:"will") != nil) {
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"if") != nil) && (subStringSentence.lowercased().range(of:"would") != nil) {
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"if") != nil) && (subStringSentence.lowercased().range(of:"would have") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                //RUTTAB
                else if (subStringSentence.lowercased().range(of:"i") != nil) && (subStringSentence.lowercased().range(of:"wish") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"if") != nil) && (subStringSentence.lowercased().range(of:"only") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"it") != nil) && (subStringSentence.lowercased().range(of:"about") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"it") != nil) && (subStringSentence.lowercased().range(of:"high") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"i") != nil) && (subStringSentence.lowercased().range(of:"rather") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"what") != nil) && (subStringSentence.lowercased().range(of:"if") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"suppose") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"in case") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"i'd") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"i") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"i") != nil) && (subStringSentence.lowercased().range(of:"will") != nil) {
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"i") != nil) && (subStringSentence.lowercased().range(of:"would") != nil) {
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"i") != nil) && (subStringSentence.lowercased().range(of:"would have") != nil) {
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"will") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"would") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                else if (subStringSentence.lowercased().range(of:"would have") != nil){
                    hypotheticalSituation = hypotheticalSituation + 1
                }
                //END RUTTAB
                //getting modal verbs
                if  (subStringSentence.lowercased().range(of:"must") != nil) ||
                    (subStringSentence.lowercased().range(of:"must not") != nil) ||
                    (subStringSentence.lowercased().range(of:"can") != nil) ||
                    (subStringSentence.lowercased().range(of:"could") != nil) ||
                    (subStringSentence.lowercased().range(of:"may") != nil) ||
                    (subStringSentence.lowercased().range(of:"might") != nil) ||
                    (subStringSentence.lowercased().range(of:"need not") != nil) ||
                    (subStringSentence.lowercased().range(of:"should") != nil) ||
                    (subStringSentence.lowercased().range(of:"ought to") != nil) ||
                    (subStringSentence.lowercased().range(of:"had better") != nil) ||
                    //RUTTAB
                    (subStringSentence.lowercased().range(of:"be able to") != nil) ||
                    (subStringSentence.lowercased().range(of:"shall") != nil) ||
                    (subStringSentence.lowercased().range(of:"have to") != nil) ||
                    (subStringSentence.lowercased().range(of:"would") != nil) ||
                    (subStringSentence.lowercased().range(of:"Has to") != nil) ||
                    (subStringSentence.lowercased().range(of:"Does not have to") != nil) ||
                    (subStringSentence.lowercased().range(of:"will have") != nil) ||
                    (subStringSentence.lowercased().range(of:"would have") != nil) ||
                    (subStringSentence.lowercased().range(of:"will") != nil) ||
                    (subStringSentence.lowercased().range(of:"does not") != nil)
                    //END RUTTAB
                {
                    modalVerbs = modalVerbs + 1
                }
            }
            //getting collocations
            for subStringSentences in subString {
                if subStringSentences == " " {
                    continue
                }
                let collocations = detectingCollocationsInSentence(for: subStringSentences)
                collocationsInSentences.append(collocations)
            }
        }
        finalizeResult()
    }

//MARK: Finalize Result
    @available(iOS 11.0, *)
    func finalizeResult() {
        
//MARK: FC
        //Frequencies count
        var frequencyCounter = 0
        var frequencyResult  : Double = 0.0
        var delayed : Double = 0.0
        for indexedFrequencies in topicFrequencies {
            frequencyCounter = frequencyCounter + indexedFrequencies.count
            for frequency in indexedFrequencies {
                if frequency > 50 {
                    frequencyResult = frequencyResult + frequency
                } else {
                    delayed = delayed + frequency
                }
            }
        }
        frequencyResult = frequencyResult/Double(frequencyCounter)
        let frequencyDelayedResult = delayed/Double(frequencyCounter)
        
        if (frequencyResult > 100) {
            frequencyCounter = 0
        } else if (frequencyResult > 90.00) {
            frequencyCounter = 2
        } else if (frequencyResult > 80.00) {
            frequencyCounter = 3
        } else if (frequencyResult > 70.00) {
            frequencyCounter = 4
        } else if (frequencyResult > 60.00) {
            frequencyCounter = 5
        } else if (frequencyResult > 50.00) {
            frequencyCounter = 6
        } else if (frequencyResult > 40.00) {
            frequencyCounter = 7
        } else if (frequencyResult > 30.00) {
            frequencyCounter = 8
        } else if (frequencyResult > 20.00) {
            frequencyCounter = 9
        }
        
        //Repeating Words
        var totalwords = 0
        var repetitionWords = 0
        for index in totalWordsInSentenceCounter{
            totalwords = totalwords + index
        }
        for index in repetitionOfWordsCounter {
            repetitionWords = repetitionWords + index
        }
//        _ = totalwords / repetitionWords
        
//MARK: LR
        //Range of Vocabulary
        var rangeOfVocabulary = 0
        for index in vocabsInSentenceCounter {
            rangeOfVocabulary = rangeOfVocabulary + index
        }

//MARK: GR
        //Collocations
        for collocations in collocationsInSentences {
            if let _ = collocations["Verb"], let _ = collocations["Adverb"] {
                collocationsInSentencesCounter = collocationsInSentencesCounter + 1
            }
            if let _ = collocations["Verb"], let _ = collocations["Noun"] {
                collocationsInSentencesCounter = collocationsInSentencesCounter + 1
            }
            if let _ = collocations["Noun"], let _ = collocations["Verb"] {
                collocationsInSentencesCounter = collocationsInSentencesCounter + 1
            }
            if let _ = collocations["Noun"], let _ = collocations["Noun"] {
                collocationsInSentencesCounter = collocationsInSentencesCounter + 1
            }
            if let _ = collocations["Adverb"], let _ = collocations["Adjective"] {
                collocationsInSentencesCounter = collocationsInSentencesCounter + 1
            }
            if let _ = collocations["Adjective"], let _ = collocations["Noun"] {
                collocationsInSentencesCounter = collocationsInSentencesCounter + 1
            }
        }

//MARK: calculate band
        //WASIQ
//        let fcband = ((Double(frequencyCounter) + Double(repetitionWords)) / 2) * 0.25
//        let grband = (Double(hypotheticalSituation + modalVerbs).truncatingRemainder(dividingBy: 2.0)) * 0.25
//        let lrband = (Double(rangeOfVocabulary + collocationsInSentencesCounter) / 2) * 0.25
//        let prband = (Double(totalwords + frequencyCounter) / 2) * 0.25
        //END WASIQ
        
        //RUTTAB
        /** A score is given out of 9 for each of the bands
         * thats is why i am dividing by 9 and adding the score to give total band
         */
        var fcband = (((Double(frequencyCounter) + Double(repetitionWords)) / 2) / 9)
        fcband = round(fcband * 2.0) / 2.0
        
        var grband = ((Double(hypotheticalSituation + modalVerbs + collocationsInSentencesCounter)/3) / 9)
        grband = round(grband * 2.0) / 2.0
        
        var lrband = ((Double(rangeOfVocabulary + collocationsInSentencesCounter) / 2) / 9)
        lrband = round(lrband * 2.0) / 2.0
        
        var prband = ((Double(totalwords + frequencyCounter) / 2) / 9)
        prband = round(prband * 2.0) / 2.0
        
        //END RUTTAB
        
        let totalBand = fcband+grband+lrband+prband
        
        print("Pronounced Word: \(totalwords)\nRange of Vocabs: \(rangeOfVocabulary)\nFrequencies result: \(frequencyCounter)\nRepetition of words: \(repetitionWords)\nNumber of Sentences: \(numberOfSentences)\nHypthetical Situation: \(hypotheticalSituation)\nModal verbs: \(modalVerbs)")
        
        PKHUD.sharedHUD.hide()
        let endTest = self.storyboard?.instantiateViewController(withIdentifier: "EndTest") as! EndTestViewController
        endTest.categoryname = self.mainHeadingLabel.text!
        endTest.textToSpeech = self.topicNames
        endTest.pronouncedWords = totalwords
        endTest.rangeOfVocabulary = rangeOfVocabulary
        endTest.frequencyCounter = frequencyCounter
        endTest.repetitedWords = repetitionWords
        endTest.numberOfSentences = numberOfSentences
        endTest.hypotheticalSituation = hypotheticalSituation
        endTest.modalVerbs = modalVerbs
        endTest.collocations = collocationsInSentencesCounter
        endTest.delayedFrequency = Int(frequencyDelayedResult)
        
        //getting 25% of band
        //WASIQ
//        endTest.frband = fcband
//        endTest.grband = grband
//        endTest.lrband = lrband
//        endTest.prband = prband
     //   endTest.totalBand = totalBand
        //END WASIQ
        
        //RUTTAB
        endTest.frband = Double(String(format: "%.1f", fcband)) ?? 0.0
        endTest.grband = Double(String(format: "%.1f", grband)) ?? 0.0
        endTest.lrband = Double(String(format: "%.1f", lrband)) ?? 0.0
        endTest.prband = Double(String(format: "%.1f", prband)) ?? 0.0
       
        
        endTest.totalBand = Double(String(format: "%.1f", totalBand)) ?? 0.0
        //END RUTTAB
        
        
        self.present(endTest, animated: true, completion: nil)
    }
    
    func repetitionOfWordCheck(for text: String) -> [String: Int] {
        var count = 0
        var temp = [String: Int]()
        indexedTopicContent.enumerateSubstrings(in: indexedTopicContent.startIndex..<indexedTopicContent.endIndex, options: .byWords) { (subString, subStringRange, enclosingRange, stop) in
            
            if case let s? = subString{
                if s.caseInsensitiveCompare(text) == .orderedSame{
                    count = count + 1
                    temp = [text:count]
                }
            }
        }
        return temp
    }
    
    @available(iOS 11.0, *)
    func vocabsInStrings(for text: String) -> Int{
        vocabsInStringsCounter = 0
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
            if let tag = tag {
                if  tag.rawValue == "Noun" ||
                    tag.rawValue == "Verb" ||
                    tag.rawValue == "Pronoun" ||
                    tag.rawValue == "Adverb" ||
                    tag.rawValue == "Adjective" {
                    vocabsInStringsCounter = vocabsInStringsCounter + 1
                }
            }
        }
        return vocabsInStringsCounter
    }
    
    @available(iOS 11.0, *)
    func seperateStringByWords(for text: String) -> Int{
    seperateStringByWordsArray.removeAll()
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
            let word = (text as NSString).substring(with: tokenRange)
            seperateStringByWordsArray.append(word)
        }
        return seperateStringByWordsArray.count
    }
    
    
    //21 - 01 - 2019
    @available(iOS 11.0, *)
    func detectingCollocationsInSentence(for text: String) -> [String: String]{
        var detectedCollocations = [String: String]()
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
            if let tag = tag {
                let word = (text as NSString).substring(with: tokenRange)
                if  tag.rawValue == "Noun" ||
                    tag.rawValue == "Verb" ||
                    tag.rawValue == "Adverb" ||
                    tag.rawValue == "Adjective" {
                    
                    detectedCollocations[tag.rawValue] = word
                    //collocationsInSentencesCounter = collocationsInSentencesCounter + 1
                }
            }
        }
        return detectedCollocations
    }
}


//RUTTAB
//MARK:- PLAYING AUDIO FILE
extension RecordingScreenViewController {
//    func loadNextQuestionPart() {
//        currentQuestionPart += 1
//        if !data.isEmpty {
//            data.removeAll()
//            tableViewReloader = 1
//            globalIndex = 0
//        }
//        data = questionsWithMultipleParts[currentQuestionPart]
//        
//        mainHeadingLabel.text = data["topicTitle"] as? String
//        topicCount = (data["topics"] as! Array<String>).count
//        
////        if data["part"] as! String == "Part - 2" {
////            mainHeadingLabel.isHidden = true
////            tableView.isHidden = true
////            part2View.isHidden = false
////            part2 = true
////            part2Initialize = true
////            part = true
////            
////        } else {
////            recordingTimer = 0
////            mainHeadingLabel.isHidden = false
////            tableView.isHidden = false
////            part2View.isHidden = true
////            part2Initialize = true
////            part = false
////        }
//        
//        tableView.reloadData()
//    }
    
    
    func playAudioFile() {
        
        print(data["topics"])
        print(data["topicTitle"])
        print(data["part"])
        
        
        let topic = data["topics"] as! Array<String>
        
        //Users/colworx/Desktop/Ruttab/Khoa IELTS/Khoa IELTS/Khoa IELTS/Audio/Personal Matters & Hobbies/Part 1/Age/Part 1 A01.wav
        let path = Bundle.main.path(forResource: "TR04 - Before Part 2.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            audioPlayer?.delegate = self
        } catch {
            // couldn't load file :(
        }
    }
    
    func playAudioFile(audioUrl: String) {
        
        SVProgressHUD.show(withStatus: "Loading Audio")
        
        let audioPath = audioReference.child(audioUrl)
        
        audioPath.downloadURL { [weak self] (url, err) in
            
            guard let weakSelf = self else {return}
            
            if err != nil {
                print("Error => \(err)")
                SVProgressHUD.dismiss()
                self?.displayAudioErrorAlert(err: "Something went wrong. Audio file not played!")
            }
            
            if let url = url {
                do {
                    let playerItem = AVPlayerItem(url: url)
                    weakSelf.player = try AVPlayer(playerItem:playerItem)
                    weakSelf.player!.volume = 1.0
                    weakSelf.player!.automaticallyWaitsToMinimizeStalling = false
                    weakSelf.player!.play()
                    
                    NotificationCenter.default.addObserver(weakSelf, selector: #selector(weakSelf.didFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
                    
                    self?.playerObserver = playerItem.observe(\.status, options: [.new, .old], changeHandler: { (playerItem, change) in
                        if playerItem.status == .readyToPlay {
                            print("Reason for waiting to play =>", weakSelf.player!.reasonForWaitingToPlay?.rawValue)
                            SVProgressHUD.dismiss()
                        }
                    })
                    
                } catch let error as NSError {
                    weakSelf.player = nil
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    self?.displayAudioErrorAlert(err: "Something went wrong. Audio file not played!")
                } catch {
                    print("AVAudioPlayer init failed")
                    SVProgressHUD.dismiss()
                    self?.displayAudioErrorAlert(err: "Something went wrong. Audio file not played!")
                }
            }
        }
    }

    
    @objc func didFinishPlaying() {
        print("AUDIO PLAYED")
        if part2 {
            mainHeadingLabel.isHidden = false
            tableView.isHidden = false
            part2View.isHidden = true
            
            self.tableView.reloadData()
            timerAction()
            return
        }
        
        updateSoundWaves.invalidate()
        if globalIndex != 0 {
            audioRecorder.stop()
            audioRecorder = nil
        }
        if(globalIndex > topicCount) {
            return
        }
        loadRecordingUI()
        startRecordingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        callTextToSpeech = Timer(timeInterval: TimeInterval(recordingTimer), target: self, selector: #selector(readSentence), userInfo: nil, repeats: true)
        updateSoundWaves = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(refreshAudioView(_:)), userInfo: nil, repeats: true)
        
        //RUTTAB 21oct19
        startRecordingTimer.tolerance = 0.1
        RunLoop.current.add(startRecordingTimer, forMode: RunLoop.Mode.common)
        RunLoop.current.add(updateSoundWaves, forMode: RunLoop.Mode.common)
        //END RUTTAB
        
    }
    
    func createAudioUrl() -> String {
        let topic = data["topics"] as! Array<String>
        let topicTitle = data["topicTitle"]! as! String
        let title = data["title"]! as! String
        let subsection = topic[globalIndex]
        var audioUrl: String = ""
        if part2 {
        
            let splittedStringArr = subsection.split(separator: ":")
            let value = splittedStringArr[0]
            var filename = value.replacingOccurrences(of: ". You should say", with: "")
            //            if let range = subsection.range(of: "You should say:") {
            //                let value = subsection[range]
            //                print(value) // prints "123.456.7891"
            //}
            
            if value.contains(".You should say") {
                filename = ""
                filename = value.replacingOccurrences(of: ".You should say", with: "")
            }
            
            
            if title  == "Food" || title == "TV, Media & Entertainment" {
                audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(filename).wav"
            }
            else if title == "Fashion & Shopping" {
                if topicTitle == "Street Market" || topicTitle == "Street Market Visit" {
                    audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(filename).wav"
                } else {
                    audioUrl = "\(data["title"]!)/\(data["part"]!)/\(filename).wav"
                }
            }
            else if  title == "People, Relationship & Communication" {
                if topicTitle == "Helper Person" || topicTitle == "Helpful person" || topicTitle == "Someone Does Well" || topicTitle == "Well doing Person" {
                    audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(value).wav"
                } else {
                    audioUrl = "\(data["title"]!)/\(data["part"]!)/\(filename).wav"
                }
            } else if title == "City, Traffic & Transport" {
                 audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(value.replacingOccurrences(of: ". You should say", with: "")).wav"
            }
            else {
                audioUrl = "\(self.data["title"]!)/\(data["part"]!)/\(filename).wav"
            }
        }
        else {
                var value = topic[globalIndex]
                var title = data["title"]! as! String
                var part = data["part"]! as! String
            
                if value.contains("?") && title  != "Personal Matters & Hobbies" {
                    value = value.replacingOccurrences(of: "?", with: "")
                }
            
                if value.contains("?") && title  == "Personal Matters & Hobbies"  && part == "Part - 3" {
                    value = value.replacingOccurrences(of: "?", with: "")
                }
            
                if value.contains(".") {
                    value = value.replacingOccurrences(of: ".", with: "")
                }
            
                audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(value).wav"
        }
        return audioUrl
    }
    
    func displayAudioErrorAlert(err: String) {
        let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
}
//END RUTTAB

//RUTTAB
//MARK:- AVPAUDIOPLAYER DELEGATE
extension RecordingScreenViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        SVProgressHUD.dismiss()
        print("AUDIO PLAYED")
        if part2 {
            mainHeadingLabel.isHidden = false
            tableView.isHidden = false
            part2View.isHidden = true
            self.tableView.reloadData()

            if part2QuestionRead {
                timerAction()
            } else {
                part2QuestionRead = true
                readSecondPartSentence()
            }
            
//            readSecondPartSentence()
//            timerAction()
            return
        }
        
        updateSoundWaves.invalidate()
        if globalIndex != 0 {
            audioRecorder.stop()
            audioRecorder = nil
        }
        if(globalIndex > topicCount) {
            return
        }
        loadRecordingUI()
        startRecordingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        callTextToSpeech = Timer(timeInterval: TimeInterval(recordingTimer), target: self, selector: #selector(readSentence), userInfo: nil, repeats: true)
        updateSoundWaves = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(refreshAudioView(_:)), userInfo: nil, repeats: true)
    }
}
//END RUTTAB


extension RecordingScreenViewController {
    func readSecondPartSentence() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.spokenAudio)
            try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try recordingSession.setActive(true)
        } catch {
            
        }
        
        recordBtn.isEnabled = false
        updateSoundWaves.invalidate()
        
        
        let sentences = (data["topics"] as! Array<String>)
        let sentencesStringRepresentation = sentences.joined()
        let speech   = AVSpeechUtterance(string: sentencesStringRepresentation)
        speech.voice = AVSpeechSynthesisVoice(language: "en-US")
        speech.volume = 1.0
        
        
        //        let topic = data["topics"] as! Array<String>
        //        let topicTitle = data["topicTitle"]! as! String
        //        let title = data["title"]! as! String
        //        let subsection = topic[globalIndex]
        //        var audioUrl: String = ""
        //        if part2 {
        //
        //            let splittedStringArr = subsection.split(separator: ":")
        //            let value = splittedStringArr[0]
        //            let filename = value.replacingOccurrences(of: ". You should say", with: "")
        ////            if let range = subsection.range(of: "You should say:") {
        ////                let value = subsection[range]
        ////                print(value) // prints "123.456.7891"
        //        //}
        //
        //            if title  == "Food" || title == "TV, Media & Entertainment" {
        //                audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(filename).wav"
        //            }
        //            else if title == "Fashion & Shopping" {
        //                if topicTitle == "Street Market" || topicTitle == "Street Market Visit" {
        //                   audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(value).wav"
        //                } else {
        //                    audioUrl = "\(data["title"]!)/\(data["part"]!)/\(filename).wav"
        //                }
        //            }
        //            else if  title == "People, Relationship & Communication" {
        //                if topicTitle == "Helper Person" || topicTitle == "Helpful person" || topicTitle == "Someone Does Well" || topicTitle == "Well doing Person" {
        //                    audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(value).wav"
        //                } else {
        //                    audioUrl = "\(data["title"]!)/\(data["part"]!)/\(filename).wav"
        //                }
        //            }
        //            else {
        //                audioUrl = "\(self.data["title"]!)/\(data["part"]!)/\(filename).wav"
        //            }
        //        } else {
        //            var value = topic[globalIndex]
        //            var title = data["title"]! as! String
        //            if value.contains("?") && title  != "Personal Matters & Hobbies" {
        //                value = value.replacingOccurrences(of: "?", with: "")
        //            }
        //            audioUrl = "\(data["title"]!)/\(data["part"]!)/\(data["topicTitle"]!)/\(value).wav"
        //        }
        
        
        playAudioFile(audioUrl: createAudioUrl())
        
        //speechSynthesizer.speak(speech)
        
    }
    
    
    func estimateFrameForText(text: String) -> CGRect {
        let height: CGFloat = 38
        
        
        let size = CGSize(width: tableView.frame.size.width , height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}


extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    
}

extension UILabel {
    
    func actualNumberOfLines() -> Int {
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0, index = 0, lineRange = NSMakeRange(0, 1)
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
    
    
    
//    var actualNumberOfLines: Int {
//        let textStorage = NSTextStorage(attributedString: self.attributedText!)
//        let layoutManager = NSLayoutManager()
//        textStorage.addLayoutManager(layoutManager)
//        let textContainer = NSTextContainer(size: self.bounds.size)
//        textContainer.lineFragmentPadding = 0
//        textContainer.lineBreakMode = self.lineBreakMode
//        layoutManager.addTextContainer(textContainer)
//
//        let numberOfGlyphs = layoutManager.numberOfGlyphs
//        var numberOfLines = 0, index = 0, lineRange = NSMakeRange(0, 1)
//
//        while index < numberOfGlyphs {
//            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
//            index = NSMaxRange(lineRange)
//            numberOfLines += 1
//        }
//        return numberOfLines
//    }
}
