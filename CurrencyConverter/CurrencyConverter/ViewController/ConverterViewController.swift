//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 04.01.2021.
//

import UIKit

class ConverterViewController: UIViewController {
    
    // MARK: - IBOutlets
    // Convertible //
    @IBOutlet weak var convertibleCurrencyVIew: UIView!
    @IBOutlet weak var convertibleCurrencyCodeLabel: UILabel!
    @IBOutlet weak var convertibleCurrencyDescriptionLabel: UILabel!
    @IBOutlet weak var convertibleCurrencyTextField: UITextField!
 
    // Base //
    @IBOutlet weak var baseCurrencyView: UIView!
    @IBOutlet weak var baseCurrencyCodeLabel: UILabel!
    @IBOutlet weak var baseCurrencyDescriptionLabel: UILabel!
    @IBOutlet weak var baseCurrencytextField: UITextField!
    
    // Reset Button //
    @IBOutlet weak var resetButton: UIButton!
   
    // MARK: - Properties
    
    private let converter = Converter()
    var convertibleCurrency: Currency?
    var baseCurrency: Currency?
    
    
    // MARK: - ViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainView()
        configureCurrenciesViews()
        configureResetButtonView()
        configureDismissingKeyboardByTouchOutsideTextFields()
        convertibleCurrencyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        baseCurrencytextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        configureCurrenciesLabels()
    }
    
    // MARK: - Configuring UI elements
    
    private func configureNavigationBar() {
        self.navigationItem.title = "Converter 🔄"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    fileprivate func configureMainView() {
        self.view.backgroundColor = #colorLiteral(red: 0.928406775, green: 0.9285623431, blue: 0.928386271, alpha: 1)
    }
    
    fileprivate func configureCurrenciesViews() {
        let views = [baseCurrencyView, convertibleCurrencyVIew]
        views.forEach { view in
            view?.backgroundColor = #colorLiteral(red: 0.5544310212, green: 0.351777494, blue: 0.9665914178, alpha: 1)
            view?.layer.cornerRadius = 30
            view?.clipsToBounds = true
        }
    }
    
    fileprivate func configureCurrenciesLabels() {
        if let convertibleCurrency = self.convertibleCurrency {
            convertibleCurrencyCodeLabel.text = convertibleCurrency.code
            convertibleCurrencyDescriptionLabel.text = convertibleCurrency.description
            convertibleCurrencyTextField.text = String(1.0)
        }
        
        if let baseCurrency = self.baseCurrency,
           let convertibleCurrency = self.convertibleCurrency {
            baseCurrencyCodeLabel.text = baseCurrency.code
            baseCurrencyDescriptionLabel.text = baseCurrency.description
            baseCurrencytextField.text = String(convertibleCurrency.rate)
        }
    }
    
    fileprivate func configureResetButtonView() {
        resetButton.backgroundColor = .systemRed
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = resetButton.frame.height / 2
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
    
    @objc fileprivate func dismissKeyboard() { self.view.endEditing(true) }
    
    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case convertibleCurrencyTextField:
            if let text = convertibleCurrencyTextField.text,
               let amount = Double(text),
               let convertibleCurrency = self.convertibleCurrency,
               let baseCurrency = self.baseCurrency {
                let convertedValue = converter.convertRate(convertibleCurrency: convertibleCurrency, resultCurrency: baseCurrency, amount: amount)
                baseCurrencytextField.text = String(convertedValue)
            }
            
        case baseCurrencytextField:
            if let text = baseCurrencytextField.text,
               let amount = Double(text),
               let convertibleCurrency = self.convertibleCurrency,
               let baseCurrency = self.baseCurrency {
                let convertedValue = converter.convertRate(convertibleCurrency: baseCurrency, resultCurrency: convertibleCurrency, amount: amount)
                convertibleCurrencyTextField.text = String(convertedValue)
            }
        default: return
        }
    }
}

