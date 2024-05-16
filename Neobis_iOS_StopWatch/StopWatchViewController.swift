//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by Ai Hawok on 01/05/2024.
//

import UIKit

class StopWatchViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerPicker: TimerPickerView!
    @IBOutlet weak var timeTypeSegmentedControl: UISegmentedControl!
    
    var eventDateComponents = DateComponents()
    var timer: Timer!
    var elapsedTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerPicker.timerDelegate = self
        
        setupUI()

    }
    
    @IBAction func timeTypeSegmentedControl(_ sender: UISegmentedControl) {
        timeLabel.text = "00:00:00"
        
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
            timerPicker.resetTimer()
        }
    }
    
    
    @IBAction func playPressed(_ sender: Any) {
        //
        switch timeTypeSegmentedControl.selectedSegmentIndex{
        case 0:
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label
            print("play in timer")
        case 1:
            print("play in stopwatch")
        default:
            print("")
        }
    }
    
    private func setupUI(){
        view.backgroundColor = AppColors.primaryColor
        timeLabel.text = "00:00:00"
    }
    
    @objc func UpdateTime(){
        let userCalendar = Calendar.current
        //Set current date
        let date = Date()
        let components = userCalendar.dateComponents([.hour, .minute,
                                                      .month, .year,
                                                      .day, .second], from: date)
        let currentDate = userCalendar.date(from: components)!
        print(currentDate)
        
        eventDateComponents.year = components.year
        eventDateComponents.month = components.month
        eventDateComponents.day = components.day
        
        guard let eventDate = userCalendar.date(from: eventDateComponents) else {
            return
        }
        print(eventDate)
        // Change the seconds to days, hours, minutes and seconds
        let timeLeft = userCalendar.dateComponents([.hour, .minute, .second], from: currentDate, to: eventDate)
        
        timeLabel.text = String(format: "%02d:%02d:%02d", timeLeft.hour!, timeLeft.minute!, timeLeft.second!)
        
    }
}

extension StopWatchViewController: TimerPickerViewDelegate{
    func timerPickerView(_ pickerView: TimerPickerView, didSelectHour hour: Int, minute: Int, second: Int) {
        timeLabel.text = String(format: "%02d:%02d:%02d", hour, minute, second)
        eventDateComponents.hour = hour
        eventDateComponents.minute = minute
        eventDateComponents.second = second
    }
}

