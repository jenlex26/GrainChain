//
//  Date+Addons.swift
//  GrainChain
//
//  Created by Javier Hernandez on 09/09/21.
//

import Foundation

extension Date {
    func getFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}
