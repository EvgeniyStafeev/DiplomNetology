//
//  String+Extension.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 22.06.2023.
//

extension String {
    func limitedText(to symbols: Int) -> String {
        guard self.count > symbols else {
            return self
        }
        return self.prefix(symbols) + " ..."
    }
}

