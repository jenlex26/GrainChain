//
//  TrackingViewModel.swift
//  GrainChain
//
//  Created by Javier Hernandez on 09/09/21.
//

import Foundation

class TrackingViewModel {
    private var arrayTours: [Tour] = []
    var successFecth: (() -> Void)?
    func fetch() {
        DatabaseManager().getTours { [weak self] (result) in
            switch result {
            case .success(let tours):
                self?.arrayTours = tours
                self?.successFecth?()
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
    func getNumberOfRows() -> Int {
        return arrayTours.count
    }
    func getTourForRow(indexPath: IndexPath) -> Tour {
        return arrayTours[indexPath.row]
    }
}
