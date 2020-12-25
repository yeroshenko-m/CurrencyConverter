//
//  Converter.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 21.12.2020.
//

import Foundation

final class Converter {
    
    var firstCurrency: Currency?
    var secondCurrency: Currency?
    
    func convertRate(input: Double) -> Double {
        guard
            let firstCurrency = self.firstCurrency, firstCurrency.rate > 0.0,
            let secondCurrency = self.secondCurrency, secondCurrency.rate > 0.0
        else { return 0.0 }

        let convertingСoefficient = firstCurrency.rate / secondCurrency.rate
        return input * convertingСoefficient
        
    }
    
}
