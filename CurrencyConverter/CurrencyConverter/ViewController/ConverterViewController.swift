//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 04.01.2021.
//

import UIKit

class ConverterViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    // Container view //
    @IBOutlet weak var containerView: UIView!
    
    // Convertible //
    @IBOutlet weak var convertibleCurrencyCodeLabel: UILabel!
    @IBOutlet weak var convertibleCurrencyDescriptionLabel: UILabel!
    @IBOutlet weak var convertibleCurrencyTextField: UITextField!
    
    // Separator view //
    @IBOutlet weak var separatorView: UIView!
    
    // Base //
    @IBOutlet weak var baseCurrencyCodeLabel: UILabel!
    @IBOutlet weak var baseCurrencyDescriptionLabel: UILabel!
    @IBOutlet weak var baseCurrencytextField: UITextField!
    
    // Reset Button //
    @IBOutlet weak var resetButton: UIButton!
    
    private let alertController: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        return alertController
    }()
    
    // MARK: - Properties
    
    private let converter = Converter()
    var convertibleCurrency: Currency?
    var baseCurrency: Currency?
    
    
    // MARK: - Constants
    
    private let textFormatString = "%.3f"
    private let allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789.")
    
    
    // MARK: - ViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDismissingKeyboardByTouchOutsideTextFields()
        
        convertibleCurrencyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        baseCurrencytextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        convertibleCurrencyTextField.delegate = self
        baseCurrencytextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        configureCurrenciesLabels()
        configureMainView()
        configureContainerView()
        configureResetButtonView()
        configureSeparatorView()
    }
    
    // MARK: - Configuring elements
    
    // NavBar //
    private func configureNavigationBar() {
        self.navigationItem.title = "Converter 🔄"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // Main view //
    fileprivate func configureMainView() {
        self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    // Separator //
    fileprivate func configureSeparatorView() {
        separatorView.layer.cornerRadius = separatorView.frame.height / 2
        separatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    // Container view //
    fileprivate func configureContainerView() {
        containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
    }
    
    // Currencies labels //
    fileprivate func configureCurrenciesLabels() {
        guard let convertibleCurrency = self.convertibleCurrency,
              let baseCurrency = self.baseCurrency
        else { return }
        
        convertibleCurrencyCodeLabel.text = convertibleCurrency.code
        convertibleCurrencyDescriptionLabel.text = convertibleCurrency.description
        convertibleCurrencyTextField.text = String(1.0)
        
        baseCurrencyCodeLabel.text = baseCurrency.code
        baseCurrencyDescriptionLabel.text = baseCurrency.description
        baseCurrencytextField.text = String(format: textFormatString, convertibleCurrency.rate)
    }
    
    // Reset button //
    fileprivate func configureResetButtonView() {
        resetButton.backgroundColor = .systemBlue
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = resetButton.frame.height / 4
        resetButton.clipsToBounds = true
        resetButton.setTitle("Reset", for: .normal)
    }
    
    // MARK: - Events handling
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        UISelectionFeedbackGenerator().selectionChanged()
        configureCurrenciesLabels()
    }
    
    fileprivate func configureDismissingKeyboardByTouchOutsideTextFields() {
        let outsideTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(outsideTapGestureRecognizer)
    }
    
    fileprivate func subscribeForKeyboardNotifications() {
        
    }
    
    @objc fileprivate func dismissKeyboard() { self.view.endEditing(true) }
    
    
    #warning("Needs to be fixed")
    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text, let amount = Double(text),
           let convertibleCurrency = self.convertibleCurrency, let baseCurrency = self.baseCurrency {
            
            switch textField {
            case convertibleCurrencyTextField:
                if text.isEmpty {
                    baseCurrencytextField.text = String(format: textFormatString, "0.00")
                } else {
                    let convertedValue = converter.convertRate(convertibleCurrency: convertibleCurrency, resultCurrency: baseCurrency, amount: amount)
                    baseCurrencytextField.text = String(format: textFormatString, convertedValue)
                }
                
                
            case baseCurrencytextField:
                if text.isEmpty {
                    convertibleCurrencyTextField.text = String(format: textFormatString, "0.00")
                } else {
                    let convertedValue = converter.convertRate(convertibleCurrency: baseCurrency, resultCurrency: convertibleCurrency, amount: amount)
                    convertibleCurrencyTextField.text = String(format: textFormatString, convertedValue)
                }
            default: return
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            switch text {
            // Limit of characters count in textfield //
            case _ where (text + string).count > 12:
                alertController.title = "Sorry, you exceeded maximum amount of input numbers"
                present(alertController, animated: true, completion: nil)
                return false
            // Limiting "." count in textfield input //
            case _ where text.contains(".") && string == ".":
                alertController.title = "Invalid input"
                present(alertController, animated: true, completion: nil)
                return false
            // Allow only numbers input //
            default:
                let textCharacterSet = CharacterSet.init(charactersIn: textField.text! + string)
                if allowedCharacterSet.isSuperset(of: textCharacterSet) { return true }
            }
        }
        
        return false
    }
    
    
}

