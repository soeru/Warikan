//
//  ViewController.swift
//  Warikan
//
//  Created by 添田祐輝 on 2017/03/20.
//  Copyright © 2017年 添田祐輝. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var paymentLabel: UILabel!
  @IBOutlet weak var sumPayment: UITextField!
  @IBOutlet weak var numPeople: UITextField!
  
  var effectiveDigit = 100.0
  let settingKey = "effectiveDigit"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let userDefaults = UserDefaults.standard
    if userDefaults.object(forKey: settingKey) != nil {
      effectiveDigit = userDefaults.double(forKey: settingKey)
    }
    
    sumPayment.delegate = self
    numPeople.delegate = self
    
    sumPayment.keyboardType = UIKeyboardType.numberPad
    numPeople.keyboardType = UIKeyboardType.numberPad
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return string.isEmpty || string.range(of: "^[0-9]+$", options: .regularExpression, range: nil, locale: nil) != nil
  }
  
  @IBAction func warikanButtonTapped(_ sender: Any) {
    view.endEditing(true)
    let payment = sumPayment.text!
    let people  = numPeople.text!
    if payment.isEmpty || people.isEmpty {
      let alert = UIAlertController(title: "アラート表示", message: "合計金額又は、人数が未入力です。", preferredStyle: UIAlertControllerStyle.alert)
      let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
      alert.addAction(defaultAction)
      present(alert, animated: true, completion: nil)
    } else if Int(people)! <= 1 {
      let alert = UIAlertController(title: "アラート表示", message: "人数は2名以上入力してください。", preferredStyle: UIAlertControllerStyle.alert)
      let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
      alert.addAction(defaultAction)
      present(alert, animated: true, completion: nil)
    } else {
      warikan(digit: self.effectiveDigit)
    }
  }

  @IBAction func effectiveDigitChange(_ sender: Any) {
    view.endEditing(true)
    let alert = UIAlertController(title: "単位の変更", message: "単位を選択してください。", preferredStyle: UIAlertControllerStyle.actionSheet)
    let hundredDigitAction = UIAlertAction(title: "100円単位で切り上げ", style: UIAlertActionStyle.default, handler: { action in
      self.effectiveDigit = 100.0
      self.saveEffectiveDigitToUserDefaults(digit: self.effectiveDigit)
      self.warikan(digit: self.effectiveDigit)
    })
    let tenDigitAction = UIAlertAction(title: "10円単位で切り上げ", style: UIAlertActionStyle.default, handler: { action in
      self.effectiveDigit = 10.0
      self.saveEffectiveDigitToUserDefaults(digit: self.effectiveDigit)
      self.warikan(digit: self.effectiveDigit)
    })
    alert.addAction(hundredDigitAction)
    alert.addAction(tenDigitAction)
    present(alert, animated: true, completion: nil)
  }
  
  func warikan(digit: Double) {
    let payment = sumPayment.text!
    let people  = numPeople.text!
    if payment.isEmpty || people.isEmpty {
      effectiveDigitChangedAlert(digit: effectiveDigit)
    } else {
      let each    = Double(payment)! / Double(people)! / digit
      let formatter = NumberFormatter()
      formatter.numberStyle = NumberFormatter.Style.decimal
      formatter.groupingSeparator = ","
      formatter.groupingSize = 3
      paymentLabel.text = formatter.string(from: (Int(ceil(each) * digit)) as NSNumber)! + "円"
    }
  }
  
  func saveEffectiveDigitToUserDefaults(digit: Double) {
    let userDefaults = UserDefaults.standard
    userDefaults.setValue(digit, forKey: settingKey)
  }
  
  func effectiveDigitChangedAlert(digit: Double) {
    let alert = UIAlertController(title: "アラート表示", message: "\(Int(digit))円単位で切り上げます。", preferredStyle: UIAlertControllerStyle.alert)
    let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
    alert.addAction(defaultAction)
    present(alert, animated: true, completion: nil)
  }
}

