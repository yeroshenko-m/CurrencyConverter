//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 17.12.2020.
//

import UIKit

class CurrenciesListViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sortListButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    private var currenciesList = [Currency]()
    private let heightForRowInTableView: CGFloat = 55.0
    private let fontSizeForButton: CGFloat = 18.0
    private let bankAPI = BankAPI()
    
    // MARK: - Ordering list
    
    private var currentOrder = CurrenciesOrder.descending
    
    @objc private enum CurrenciesOrder: Int, CustomStringConvertible {
        case descending, raising
        var description: String {
            switch self {
            case .descending:
                return "Rates ↓"
            case .raising:
                return "Rates ↑"
            }
        }
    }
    
    // Handles touching "Sort" button, switches state and updates button label //
    @IBAction func sortListButtonTapped(_ sender: UIBarButtonItem) {
        switch currentOrder {
        case .descending:
            currentOrder = .raising
            sortListButton.title = currentOrder.description
            reorder(to: .raising)
        case .raising:
            currentOrder = .descending
            sortListButton.title = currentOrder.description
            reorder(to: .descending)
        }
    }
    
    // Reorders currenciesList //
    private func reorder(to orderType: CurrenciesOrder) {
        switch orderType {
        case .descending:
            currenciesList.sort { $0.rate > $1.rate }
            tableView.reloadData()
        case .raising:
            currenciesList.sort { $0.rate < $1.rate }
            tableView.reloadData()
        default: return
        }
    }
    
    // MARK: - ViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bankAPI.fetchCurrenciesList { fetchedList in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.currenciesList = fetchedList
                self.reorder(to: self.currentOrder)
                self.tableView.reloadData()
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
        sortListButton.title = currentOrder.description
        self.navigationItem.rightBarButtonItems = [sortListButton, editButtonItem]
    }
    
    fileprivate func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControlAction), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc fileprivate func handleRefreshControlAction() {
        bankAPI.fetchCurrenciesList { fetchedList in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.currenciesList = fetchedList
                self.reorder(to: self.currentOrder)
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()

            }
        }
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

