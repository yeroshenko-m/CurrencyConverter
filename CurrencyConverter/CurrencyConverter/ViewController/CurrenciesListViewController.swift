//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 17.12.2020.
//

import UIKit

class CurrenciesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var currenciesList = [Currency]()
    private let heightForRowInTableView: CGFloat = 55.0
    private let fontSizeForButton: CGFloat = 18.0
    private let bankAPI = BankAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
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
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureNavigationBar() {
        self.title = "Exchange rates 🇺🇦"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = editButtonItem
    }

}

extension CurrenciesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return currenciesList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell") as? CurrencyTableViewCell
        else { return UITableViewCell() }
        cell.configure(with: currenciesList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return heightForRowInTableView }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            currenciesList.remove(at: indexPath.row)
            tableView.endUpdates()
        default: return
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return true }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = currenciesList[sourceIndexPath.row]
        currenciesList.remove(at: sourceIndexPath.row)
        currenciesList.insert(rowToMove, at: destinationIndexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

