//
//  BankAPI.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 20.12.2020.
//

import Foundation

final class BankAPI {

    let urlString = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
    
    func fetchCurrenciesList(completionHandler: @escaping ([Currency]) -> ()) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                if let list =  try? JSONDecoder().decode([Currency].self, from: data) {
                    completionHandler(list.sorted(by: { $1.rate < $0.rate }))
                }
            }.resume()
        }
    }
    
}
