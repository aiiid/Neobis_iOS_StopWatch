//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by Ai Hawok on 01/05/2024.
//

import UIKit

class StopWatchViewController: UIViewController {
    
    @IBOutlet weak var playButton: ControlButton!
    @IBOutlet weak var pauseButton: ControlButton!
    @IBOutlet weak var resetButton: ControlButton!
    
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerPicker: TimerPickerView!
    @IBOutlet weak var timeTypeSegmentedControl: UISegmentedControl!
    
    var timer: Timer!
    var isTimerRunning = false
    var eventDate: Date!
    var startTime: Date!
    var stopTime: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerPicker.timerDelegate = self
        setupUI()
        
    }
    
    // MARK: - Initial setup
    @IBAction func timeTypeSegmentedControl(_ sender: UISegmentedControl) {
        resetTimer()
        if sender.selectedSegmentIndex == 0 {
            //show the timerPicker if the first is selected
            timeImage.image = UIImage(named: "timer")
            timerPicker.animateIn()
        } else {
            //hide the timerPicker if Stopwatch selected
            timeImage.image = UIImage(named: "stopWatch")
            timerPicker.animateOut()
        }
    }
    
    private func setupUI(){
        view.backgroundColor = AppColors.primaryColor
        timeLabel.text = "00:00:00"
        timeImage.image = UIImage(named: "timer")
        var size: CGFloat = 60
       
        NSLayoutConstraint.activate([
            timeImage.widthAnchor.constraint(equalToConstant: size),
            timeImage.heightAnchor.constraint(equalToConstant: size)])
    }
    
    // MARK: - Control buttons
    
    @IBAction func playPressed(_ sender: Any) {
        pauseButton.animateIn()
        playButton.animateOut()
        
        if !isTimerRunning{
            startTime = Date()
        }else{
            var elapsedTime = Date().timeIntervalSince(stopTime)
            startTime = startTime.addingTimeInterval(elapsedTime)
        }
        
        generateEventDate(timePressed: startTime)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label
        isTimerRunning = true
        playButton.isEnabled = false
        
    }
    
    @IBAction func pausePressed(_ sender: UIButton) {
        timer.invalidate()
        stopTime = Date()
        pauseButton.animateOut()
        enablePlay()
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        resetTimer()
    }
    
    private func enablePlay(){
        // Enable the play button
        playButton.animateIn()
        playButton.isEnabled = true
    }
    
    private func resetTimer(){
        if isTimerRunning{ timer.invalidate() }
        timeLabel.text = "00:00:00"
        timerPicker.resetTimer()
        isTimerRunning = false
        enablePlay()
        pauseButton.animateIn()
    }
    
    // MARK: - Time functions
    
    private func generateEventDate(timePressed: Date){
        let userCalendar = Calendar.current
        var eventDateComponents = userCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: timePressed)
        
        let selectedHour = timerPicker.selectedRow(inComponent: 0)
        let selectedMinute = timerPicker.selectedRow(inComponent: 1)
        let selectedSecond = timerPicker.selectedRow(inComponent: 2)
        
        eventDateComponents.hour! += selectedHour
        eventDateComponents.minute! += selectedMinute
        eventDateComponents.second! += selectedSecond
        
        eventDate = userCalendar.date(from: eventDateComponents)
    }
    
    @objc func UpdateTime(){
        let userCalendar = Calendar.current
        // Set Current Date
        let date = Date()
        let components = userCalendar.dateComponents([.hour, .minute,
                                                      .month, .year,
                                                      .day, .second], from: date)
        
        let currentDate = userCalendar.date(from: components)!
        
        switch timeTypeSegmentedControl.selectedSegmentIndex{
        case 0:
            if let eventDate = eventDate {
                // Change the seconds to days, hours, minutes, and seconds
                let timeLeft = userCalendar.dateComponents([.hour, .minute, .second],
                                                           from: currentDate, to: eventDate)
                
                timeLabel.text = String(format: "%02d:%02d:%02d", timeLeft.hour!, timeLeft.minute!, timeLeft.second!)
                
                if currentDate >= eventDate {
                    timeLabel.text = "Finish!"
                    isTimerRunning = false
                    // Stop Timer
                    timer.invalidate()
                    enablePlay()
                }
            } else {
                // Handle the case when eventDate is nil
                print("Event date is nil.")
            }
        case 1:
            if let startTime = startTime {
                let timeLeft = userCalendar.dateComponents([.hour, .minute, .second], from: startTime, to: currentDate)
                timeLabel.text = String(format: "%02d:%02d:%02d", timeLeft.hour!, timeLeft.minute!, timeLeft.second!)
            }
        default:
            print("")
        }
        
    }
}

extension StopWatchViewController: TimerPickerViewDelegate{
    func timerPickerView(_ pickerView: TimerPickerView, didSelectHour hour: Int, minute: Int, second: Int) {
        timeLabel.text = String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}

