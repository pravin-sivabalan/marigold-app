import UIKit

class AddNotificationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
//    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var weekdayPicker: UIPickerView!
    let weekdays = ["Mon","Tues","Wed","Thurs","Fri","Sat","Sun"]
    var hours = [String]()
    var minutes = [String]()
    let meridiem = ["AM", "PM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        weekdayPicker.delegate = self
        weekdayPicker.dataSource = self
        
        for num in 1...12 {
            hours.append(String(format: "%02d", num))
        }
        
        for num in 0...59 {
            minutes.append(String(format: "%02d", num))
        }


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0) {
            return weekdays.count
        }
        
        if(component == 1) {
            return hours.count
        }
        
        if(component == 2) {
            return minutes.count
        }
        
        if(component == 3) {
            return meridiem.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0) {
            return weekdays[row]
        }
        
        if(component == 1) {
            return hours[row]
        }
        
        if(component == 2) {
            return minutes[row]
        }
        
        if(component == 3) {
            return meridiem[row]
        }
        
        return weekdays[row]
    }
}

extension AddNotificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}

