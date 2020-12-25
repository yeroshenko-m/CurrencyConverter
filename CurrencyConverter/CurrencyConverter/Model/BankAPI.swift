//
//  BankAPI.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 20.12.2020.
//

import Foundation

final class BankAPI {
    
    static let shared = BankAPI()
    private init() {}
    
    func fetchCurrenciesList(completionHandler: @escaping ([Currency]) -> ()) {
        let urlString = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            if let list =  try? JSONDecoder().decode([Currency].self, from: data) {
                
                completionHandler(list.filter { (currency) -> Bool in
                    currency.code == "USD" || currency.code == "EUR"
                })
//                completionHandler(list)
                
            }
        }.resume()
    }
}
