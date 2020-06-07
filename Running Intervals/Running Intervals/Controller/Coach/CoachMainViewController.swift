//
//  TrainingMainViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 03/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import HealthKit

class CoachMainViewController: UIViewController {

    //============================================================
    // MARK: - @IBOutlets
    //============================================================
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fillManuallyLabel: UILabel!
    
    @IBOutlet weak var importButton: UIButton!
    
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var genderTitelLabel: UILabel!
    @IBOutlet weak var selectedGenderLabel: UILabel!
    @IBOutlet weak var selectGenderButton: UIButton!
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageTitelLabel: UILabel!
    @IBOutlet weak var selectedAgeLabel: UILabel!
    @IBOutlet weak var selectAgeButton: UIButton!
    
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightTitelLabel: UILabel!
    @IBOutlet weak var selectedHeightLabel: UILabel!
    @IBOutlet weak var selectHeightButton: UIButton!
    
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightTitelLabel: UILabel!
    @IBOutlet weak var selectedWeightLabel: UILabel!
    @IBOutlet weak var selectWeightButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    //============================================================
    // MARK: - Properties
    //============================================================
    
    private var datePicker: UIDatePicker?
    private var dataPicker: UIPickerView?
    var toolBar = UIToolbar()
    
    //============================================================
    // MARK: - LifeCycle
    //============================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setText()
        self.setCornerRadius()
        self.initDatePicker()
        self.initDataPicker()
    }
    override func viewWillLayoutSubviews() {
        self.setCornerRadius()
    }
    
    //============================================================
    // MARK: - SetUp
    //============================================================
    
    func setText() {
        self.headerLabel.text = "Build Plan"
        self.titleLabel.text = "הכנס/י מדדים פיזיים על מנת שנוכל ליצור לך את התוכנית הטובה ביותר בשבילך"
        self.importButton.setTitle("❤️  Import from Appel Health", for: .normal)
        self.fillManuallyLabel.text = "Or fill out manually"
        self.genderTitelLabel.text = "Gender"
        self.ageTitelLabel.text = "Your Age"
        self.heightTitelLabel.text = "Your Height"
        self.weightTitelLabel.text = "Your Weight"
    }
    
    func setCornerRadius() {
        self.importButton.layer.cornerRadius = self.importButton.bounds.height / 2
        self.importButton.layer.borderWidth = 2
        self.importButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.continueButton.layer.cornerRadius = self.continueButton.bounds.height / 2
        self.continueButton.layer.borderWidth = 2
        self.continueButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.genderView.layer.cornerRadius = self.genderView.bounds.height / 2
        self.genderView.layer.borderWidth = 2
        self.genderView.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.ageView.layer.cornerRadius = self.ageView.bounds.height / 2
        self.ageView.layer.borderWidth = 2
        self.ageView.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.heightView.layer.cornerRadius = self.heightView.bounds.height / 2
        self.heightView.layer.borderWidth = 2
        self.heightView.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.weightView.layer.cornerRadius = self.weightView.bounds.height / 2
        self.weightView.layer.borderWidth = 2
        self.weightView.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
    }
    
    //============================================================
    // MARK: - @IBActions
    //============================================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func importButtonPressed(_ sender: Any) {
        
        if HealthKitManager.shared.authorizeHealthKit() {
            print("Health Kit Authorized")
            
            HealthKitManager.shared.getUserAuthorization { (sucsses, error) in
                if let error = error {
                    print(error)
                } else {
                    if sucsses {
                        self.getAgeAndGender()
                        self.getHeight()
                        self.getWeight()
                        
                    } else {
                        print(sucsses)
                    }
                }
            }
        }
    }
    
    
    @IBAction func selectAgeButtonPressed(_ sender: Any) {
        self.dataPicker?.tag = 0
        self.setInputViews()
    }
    
    @IBAction func selectGenderButtonPressed(_ sender: Any) {
        self.dataPicker?.tag = 1
        self.setInputViews()
    }
    
    @IBAction func selectHeightButtonPressed(_ sender: Any) {
    
    }
    
    @IBAction func selectWeightButtonPressed(_ sender: Any) {
    
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
    }
    
    //============================================================
    // MARK: - Actions
    //============================================================
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.dateFormat = "yyyy"
        
    }
    
    @objc func donePressed(_ sender: UITextField) {
        guard let date = self.datePicker?.date else { return }
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.dateFormat = "yyyy"
        let age = dateFormatter.string(from: date)
        self.selectedAgeLabel.text = age
        
        self.view.endEditing(true)
    }
    
    @objc func keyboardDonePressed(_ sender: Any) {
        if let index = self.dataPicker?.selectedRow(inComponent: 0) {
            
        }
        if let pickerView = self.dataPicker {
            pickerView.removeFromSuperview()
            self.toolBar.removeFromSuperview()
        }
        
    }
    
    @objc func keyboardCancelPressed(_ sender: Any) {
        if let pickerView = self.dataPicker {
            pickerView.removeFromSuperview()
            self.toolBar.removeFromSuperview()
        }
    }
    //============================================================
    // MARK: - Data Picker
    //============================================================
    
    private func initDatePicker() {
        self.datePicker = UIDatePicker()
        self.datePicker?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

    }
    
    private func initDataPicker() {
        self.dataPicker = UIPickerView()
        self.dataPicker?.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        self.dataPicker?.dataSource = self
        self.dataPicker?.delegate = self
    }
    
    
    
    private func setInputViews() {
        if let pickerView = self.dataPicker {
            pickerView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            pickerView.autoresizingMask = .flexibleWidth
            pickerView.contentMode = .center
            self.view.addSubview(pickerView)
            
            self.setToolBar()
        }
    }
    private func setToolBar() {
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: #selector(self.keyboardDonePressed(_:)))
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: target, action: #selector(self.keyboardCancelPressed(_:)))
        toolBar.items = [cancelBarButton, flexBarButton, doneBarButton]
        cancelBarButton.tintColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        doneBarButton.tintColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        self.view.addSubview(toolBar)
        
    }
    
    //============================================================
    // MARK: - Health Kit
    //============================================================
    private func getWeight () {
        HealthKitManager.shared.getWeight { (results, error) in
            if let error = error {
                print(error)
            } else {
                if let result = results.first as? HKQuantitySample {
                    DispatchQueue.main.async {
                        self.selectedWeightLabel.text = "\(result.quantity)"
                    }
                }
            }
        }
    }
    
    private func getHeight() {
        HealthKitManager.shared.getHeight { (results, error) in
            if let error = error {
                print(error)
            } else {
                if let result = results.first as? HKQuantitySample {
                    DispatchQueue.main.async {
                        self.selectedHeightLabel.text = "\(result.quantity)"
                    }
                }
            }
        }
    }

    private func getAgeAndGender() {
        do {
            let parameters = try HealthKitManager.shared.getAgeAndGender()
            DispatchQueue.main.async {
                self.selectedAgeLabel.text = "\(parameters.age)"
                let gender = parameters.biologicalSex.rawValue
                if gender == 2 {
                    self.selectedGenderLabel.text = "Male"
                } else {
                    self.selectedGenderLabel.text = "Female"
                }
            }
        } catch {
            print("unabeld to get parameters")
        }
    }
    
}

extension CoachMainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if let genderPickerView = self.dataPicker {
                textField.inputView = genderPickerView
            }
        }
        if textField.tag == 2 {
            if let datePickerView = self.datePicker {
                
                datePickerView.datePickerMode = .date
                datePickerView.maximumDate = Date()
                textField.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
                let keyboardToolbar = UIToolbar()
                keyboardToolbar.sizeToFit()
                let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePressed(_:)))
                keyboardToolbar.items = [flexBarButton, doneBarButton]
                textField.inputAccessoryView = keyboardToolbar
            }
            
        }
        
    }
        
}

extension CoachMainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            print("age picker view")
        }
        if pickerView.tag == 1 {
            print("gender picker view")
        }
        let gender = ["Male", "Female"]
        
        return gender[row]
    }
    
}
