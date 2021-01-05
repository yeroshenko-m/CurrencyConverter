//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 20.12.2020.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var decriptionLabel: UILabel!
    
    func configure(with model: Currency) {
        self.codeLabel.text = model.code
        self.rateLabel.text = String(model.rate)
        self.decriptionLabel.text = model.description
    }

}


