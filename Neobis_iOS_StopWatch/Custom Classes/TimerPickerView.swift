//
//  DatePickerView.swift
//  Neobis_iOS_StopWatch
//
//  Created by Ai Hawok on 16/05/2024.
//

import UIKit

protocol TimerPickerViewDelegate: AnyObject {
    func timerPickerView(_ pickerView: TimerPickerView, didSelectHour hour: Int, minute: Int, second: Int)
}

class TimerPickerView: UIPickerView {
    //Timer components
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    weak var timerDelegate: TimerPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    func resetTimer(){
        let numberOfComponents = self.numberOfComponents
        for component in 0..<numberOfComponents {
            self.selectRow(-1, inComponent: component, animated: true)
        }
    }
    
}

extension TimerPickerView: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        case 2:
            return seconds.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(hours[row])"
        case 1:
            return "\(minutes[row])"
        case 2:
            return "\(seconds[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = self.selectedRow(inComponent: 0)
        let selectedMinute = self.selectedRow(inComponent: 1)
        let selectedSecond = self.selectedRow(inComponent: 2)
        timerDelegate?.timerPickerView(self, didSelectHour: selectedHour, minute: selectedMinute, second: selectedSecond)
    }
}
