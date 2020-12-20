//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 17.12.2020.
//

import UIKit

class CurrenciesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goToConverterScreenButton: UIButton!
    
    private var currenciesList = [Currency]()
    private let heightForRowInTableView: CGFloat = 50.0
    private let fontSizeForButton: CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureButton()
        BankAPI.shared.fetchCurrenciesList { fetchedList in
            DispatchQueue.main.async { [weak self] in
                self?.currenciesList = fetchedList
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureButton() {
        goToConverterScreenButton.setTitle("Converter", for: .normal)
        goToConverterScreenButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSizeForButton)
    }
}

extension CurrenciesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenciesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell") as? CurrencyTableViewCell
        else { return UITableViewCell() }
        let currency = currenciesList[indexPath.row]
        cell.codeLabel.text = currency.code
        cell.rateLabel.text = String(currency.rate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowInTableView
    }
    
}

