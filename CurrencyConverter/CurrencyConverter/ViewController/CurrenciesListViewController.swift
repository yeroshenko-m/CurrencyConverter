//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 17.12.2020.
//

import UIKit

class CurrenciesListViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var currenciesList = [Currency]()
    private let heightForRowInTableView: CGFloat = 55.0
    private let fontSizeForButton: CGFloat = 18.0
    private let bankAPI = BankAPI()
    
    // MARK: - ViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bankAPI.fetchCurrenciesList { fetchedList in
            DispatchQueue.main.async { [weak self] in
                self?.currenciesList = fetchedList
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    // MARK: - Configuring UI elements

    private func configureNavigationBar() {
        self.title = "Exchange rates 🇺🇦"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = editButtonItem
    }

    // MARK: - TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return currenciesList.count }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return heightForRowInTableView }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell") as? CurrencyTableViewCell
        else { return UITableViewCell() }
        cell.configure(with: currenciesList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            currenciesList.remove(at: indexPath.row)
            tableView.endUpdates()
        default: return
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = currenciesList[sourceIndexPath.row]
        currenciesList.remove(at: sourceIndexPath.row)
        currenciesList.insert(rowToMove, at: destinationIndexPath.row)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let converterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConverterViewController")
                as? ConverterViewController
        else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        UISelectionFeedbackGenerator().selectionChanged()
        
        let baseCurrency = Currency(rate: 1.0, code: "UAH", description: "Українська гривня")
        let convertibleCurrency = currenciesList[indexPath.row]
        
        converterVC.baseCurrency = baseCurrency
        converterVC.convertibleCurrency = convertibleCurrency
        
        self.navigationController?.pushViewController(converterVC, animated: true)
        
    }
    
}

