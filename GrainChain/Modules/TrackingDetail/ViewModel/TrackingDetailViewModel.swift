//
//  TrackingDetailViewModel.swift
//  GrainChain
//
//  Created by Javier Hernandez on 09/09/21.
//

import Foundation

class TrackingDetailViewModel {
    
    private var tourModel: Tour?
    var reloadData: (() -> Void)?
    var deleteComplete: (() -> Void)?
    
    init(tourModel: Tour) {
        self.tourModel = tourModel
    }
    func fetch() {
        reloadData?()
    }
    func getTitle() -> String {
        return tourModel?.name ?? ""
    }
    func numberOfLocation() -> Int {
        return tourModel?.locations?.count ?? 0
    }
    func getLocationForCell(indexPath: IndexPath) -> String? {
        let location =  tourModel?.locations?[indexPath.row]
        guard let coordinate = location?.coordinate else { return "" }
        let text = "cordenada: Lat:\(coordinate.latitude), Long: \(coordinate.longitude)"
        return text
    }
    func getTour() -> String? {
        var text = "Fecha: \(tourModel?.beginning ?? "")\n"
        text += "Nombre: \(tourModel?.name ?? "")\n"
        text += "Kilometros recorridos: \(tourModel?.km ?? "")\n"
        text += "Tiempo de recorrido: \(tourModel?.time ?? "")\n"
        return text
    }
    func getTourForMap() -> Tour? {
        return tourModel
    }
    
    func deleteTour() {
        DatabaseManager().deleteTour(tour: tourModel)
        deleteComplete?()
    }
   
}
