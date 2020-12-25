//
//  ConverterTableViewController.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 20.12.2020.
//

import UIKit

class ConverterTableViewController: UITableViewController {
    
    private let heightForRowInTableView: CGFloat = 55.0
    private var convertibleCurrenciesList = [Currency]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarAppearence()
    }
    
    private func configureNavigationBarAppearence() {
        self.navigationItem.title = "Converter"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setupConvertibleCurrenciesList(with data: [Currency]) {
        self.convertibleCurrenciesList = data
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        return UITableViewCell()
    }

}
