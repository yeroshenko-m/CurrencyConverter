//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Mykhailo Yeroshenko on 21.12.2020.
//

import Foundation

struct Currency: Codable {
    let rate: Double
    let code: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case code = "cc"
        case rate = "rate"
        case description = "txt"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(rate, forKey: .rate)
        try container.encode(description, forKey: .description)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        rate = try container.decode(Double.self, forKey: .rate)
        description = try container.decode(String.self, forKey: .description)
    }
}
