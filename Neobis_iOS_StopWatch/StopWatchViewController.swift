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
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerPicker: TimerPickerView!
    @IBOutlet weak var timeTypeSegmentedControl: UISegmentedControl!
    
    var timer: Timer!
    var isTimerRunning = false
    var eventDate: Date!
    var startTime: Date!
    
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
            UIView.animate(withDuration: 0.3){
                self.timerPicker.alpha = 1.0
            }
        } else {
            //hide the timerPicker if Stopwatch selected
            UIView.animate(withDuration: 0.3){
                self.timerPicker.alpha = 0.0
            }
           
        }
    }
    
    private func setupUI(){
        view.backgroundColor = AppColors.primaryColor
        timeLabel.text = "00:00:00"
    }
    
    // MARK: - Control buttons
    
    @IBAction func playPressed(_ sender: Any) {
        pauseButton.animateIn()
        playButton.animateOut()
        
        switch timeTypeSegmentedControl.selectedSegmentIndex{
        case 0:
            if !isTimerRunning{
                generateEventDate(timePressed: Date())
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label
                isTimerRunning = true
                playButton.isEnabled = false
            }
        case 1:
            if !isTimerRunning {
                startTime = Date()
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label
                isTimerRunning = true
                playButton.isEnabled = false
            }
        default:
            print("")
        }
        
        
    }
    
    @IBAction func pausePressed(_ sender: UIButton) {
        timer.invalidate()
        isTimerRunning = false
        pauseButton.animateOut()
        enablePlay()
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        timer.invalidate()
        timeLabel.text = "00:00:00"
        isTimerRunning = false
        pauseButton.animateIn()
        enablePlay()
    }
    
    private func enablePlay(){
        // Enable the play button
        playButton.animateIn()
        playButton.isEnabled = true
        isTimerRunning = false
    }
    
    private func resetTimer(){
        timeLabel.text = "00:00:00"
        timerPicker.resetTimer()
        if isTimerRunning { timer.invalidate() }
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
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
        let currentDate = userCalendar.date(from: components)!
        
        switch timeTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            if let eventDate = eventDate {
                // Change the seconds to days, hours, minutes, and seconds
                let timeLeft = userCalendar.dateComponents([.hour, .minute, .second], from: currentDate, to: eventDate)
                timeLabel.text = String(format: "%02d:%02d:%02d", timeLeft.hour!, timeLeft.minute!, timeLeft.second!)
                
                if currentDate >= eventDate {
                    timeLabel.text = "Finish!"
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
            return
        }
        
        
    }
}

extension StopWatchViewController: TimerPickerViewDelegate{
    func timerPickerView(_ pickerView: TimerPickerView, didSelectHour hour: Int, minute: Int, second: Int) {
        timeLabel.text = String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}

