//
//  BankAPI.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 20.12.2020.
//

import Foundation

final class BankAPI {
    
    static let shared = BankAPI()
//    private
    private init() {}
    
    func fetchCurrenciesList(completionHandler: @escaping ([Currency]) -> ()) {
        let urlString = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            if let list =  try? JSONDecoder().decode([Currency].self, from: data) {
                completionHandler(list)
            }
        }.resume()
    }
}

class Currency: Codable {
    
    public var rate: Double
    public var code: String
    

    enum CodingKeys: String, CodingKey {
        case code = "cc"
        case rate = "rate"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(rate, forKey: .rate)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        rate = try container.decode(Double.self, forKey: .rate)
    }
}
