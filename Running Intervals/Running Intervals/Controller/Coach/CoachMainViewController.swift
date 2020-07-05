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
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    //============================================================
    // MARK: - Properties
    //============================================================
    
    private var dataPicker: UIPickerView?
    var toolBar = UIToolbar()
    var user: User?
    let gender = [Strings.male, Strings.female]
    
    //============================================================
    // MARK: - LifeCycle
    //============================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setText()
        self.setCornerRadius()
        self.initDataPicker()
        self.user = UserDefaultsProvider.shared.user
        self.setBmi()
        self.setUserInfoText()
    }
    override func viewWillLayoutSubviews() {
        self.setCornerRadius()
    }
    
    //============================================================
    // MARK: - SetUp
    //============================================================
    
    func setText() {
        self.backButton.setTitle(Strings.back, for: .normal)
        self.headerLabel.text = Strings.personalInformaition
        self.titleLabel.text = Strings.descreptionTitle
        self.importButton.setTitle(Strings.appelHealth, for: .normal)
        self.fillManuallyLabel.text = Strings.fillManually
        self.ageTitelLabel.text = Strings.age
        self.genderTitelLabel.text = Strings.gender
        self.heightTitelLabel.text = Strings.height
        self.weightTitelLabel.text = Strings.weight
        self.continueButton.setTitle(Strings.continueTitle, for: .normal)
    }
    
    func setUserInfoText() {
        guard let user = self.user else { return }
        self.selectedGenderLabel.text = user.gender
        self.selectedAgeLabel.text = "\(user.age)"
        self.selectedHeightLabel.text = "\(user.height) \(Strings.centimeter)"
        self.selectedWeightLabel.text = "\(user.weight) \(Strings.kilogram)"
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
    
    func createUser() {
        guard let gender = self.selectedGenderLabel.text,
              let age = self.selectedAgeLabel.text,
              let height = self.selectedHeightLabel.text,
              let weight = self.selectedWeightLabel.text else { return }
        if let userHeight = height.components(separatedBy: " ").first, let userWeight = weight.components(separatedBy: " ").first {
            let values = ["gender": gender, "age": Int(age), "height": Int(userHeight), "weight": Int(userWeight)] as [String : Any]
            self.user = User(values: values)
            UserDefaultsProvider.shared.user = self.user
            setBmi()
        }
    }
    
    func setBmi() {
        guard let user = self.user else { return }
        let height = Double(user.height) / 100
        let bmi = Double(user.weight) / (height * height)
        if bmi < 18.5 {
            self.bmiLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.bmiLabel.text = "your BNI is \(Int(bmi)) It's too low, you better start eating 😉"
        } else if bmi >= 18.5 && bmi < 25 {
            self.bmiLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            self.bmiLabel.text = "your BNI is \(Int(bmi)) You're on average, well done 👏"
        } else if bmi > 24  && bmi < 30 {
            self.bmiLabel.text = "your BNI is \(Int(bmi)) It's a bit high, if you have background illnesses think seriously about a serious diet 🤔"
            self.bmiLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        } else {
            self.bmiLabel.text = "your BNI is \(Int(bmi)) It's a to high, you realy need to start a serious diet 😡, unless you are a bodybuilder 💪"
            self.bmiLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        
    }
    
    //============================================================
    // MARK: - @IBActions
    //============================================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func importButtonPressed(_ sender: Any) {
        if HealthKitManager.shared.authorizeHealthKit() {
            HealthKitManager.shared.getUserAuthorization { (sucsses, error) in
                if let error = error {
                    print(error)
                } else {
                    if sucsses {
                        self.getWeight()
                    } else {
                        print(sucsses)
                    }
                }
            }
        }
    }
    
    @IBAction func selectAgeButtonPressed(_ sender: Any) {
        self.setInputViews(0)
    }
    
    @IBAction func selectGenderButtonPressed(_ sender: Any) {
        self.setInputViews(1)
    }
    
    @IBAction func selectHeightButtonPressed(_ sender: Any) {
        self.setInputViews(2)
    }
    
    @IBAction func selectWeightButtonPressed(_ sender: Any) {
        self.setInputViews(3)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
    }
    
    //============================================================
    // MARK: - Actions
    //============================================================
    
    @objc func keyboardDonePressed(_ sender: Any) {
        if let pickerView = self.dataPicker {
            if let index = self.dataPicker?.selectedRow(inComponent: 0) {
                print(index)
                if pickerView.tag == 0 {
                    self.selectedAgeLabel.text = "\(index + 10)"
                } else if pickerView.tag == 1 {
                    self.selectedGenderLabel.text = self.gender[index]
                } else if pickerView.tag == 2 {
                    self.selectedHeightLabel.text = "\(index + 50) \(Strings.centimeter)"
                } else if pickerView.tag == 3 {
                    self.selectedWeightLabel.text = "\(index + 50) \(Strings.kilogram)"
                }
            }
            self.createUser()
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
    
    private func initDataPicker() {
        self.dataPicker = UIPickerView()
        self.dataPicker?.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        self.dataPicker?.dataSource = self
        self.dataPicker?.delegate = self
        
    }
    
    private func setInputViews(_ tag: Int) {
        self.initDataPicker()
        if let pickerView = self.dataPicker {
            pickerView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            pickerView.autoresizingMask = .flexibleWidth
            pickerView.contentMode = .center
            pickerView.tag = tag
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
                        if let weight = "\(result.quantity)".components(separatedBy: " ").first {
                            self.selectedWeightLabel.text = "\(weight) \(Strings.kilogram)"
                            self.getHeight()
                        }
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
                        if let height = "\(result.quantity)".components(separatedBy: " ").first {
                            self.selectedHeightLabel.text = "\(height) \(Strings.centimeter)"
                            self.getAgeAndGender()
                        }
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
                    self.selectedGenderLabel.text = Strings.male
                } else {
                    self.selectedGenderLabel.text = Strings.female
                }
                self.createUser()
            }
        } catch {
            print("unabeld to get parameters")
        }
    }
    
}

extension CoachMainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return 2
        } else if pickerView.tag == 2 {
            return 180
        } else {
            return 100
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return "\(row + 10)"
        }
        if pickerView.tag == 1 {
            return self.gender[row]
        }
        if pickerView.tag == 2 {
            return "\(row + 50)"
        }
        if pickerView.tag == 3 {
            return "\(row + 50)"
        }
        return ""
    }
    
}
