//
//  Converter.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 21.12.2020.
//

import Foundation

final class Converter {

    public func convertRate(convertibleCurrency: Currency, resultCurrency: Currency, amount: Double) -> Double {
        guard
            convertibleCurrency.rate > 0.0,
            resultCurrency.rate > 0.0
        else { return 0.0 }

        let convertingСoefficient = convertibleCurrency.rate / resultCurrency.rate
        return amount * convertingСoefficient
        
    }
    
}
