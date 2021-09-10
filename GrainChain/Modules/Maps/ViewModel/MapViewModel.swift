//
//  MapViewModel.swift
//  GrainChain
//
//  Created by Javier Hernandez on 09/09/21.
//

import Foundation
import GoogleMaps

class MapTourViewModel {
    var arrLocations = [CLLocation]()
    
    func cleanLocations() {
        arrLocations = [CLLocation]()
    }
    func setNewLocation(location: CLLocation) {
        arrLocations.append(location)
    }
    func saveTour(name: String) {
        guard let firstLocation = arrLocations.first else { return }
        guard let lastLocation = arrLocations.last else { return }
        let distance = firstLocation.distance(from: lastLocation)
        let tour = TrackingModel()
        tour.beginning = "\(firstLocation.timestamp.getFormat())"
        tour.end = "\(lastLocation.timestamp.getFormat())"
        tour.km = "\(String(format: "%.01fkm", distance/1000))"
        tour.name = name
        tour.locations = arrLocations
        
        let diffComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: firstLocation.timestamp, to: lastLocation.timestamp)
        tour.time = "Horas: \(diffComponents.hour ?? 0), minutos: \(diffComponents.minute ?? 0), segundos: \(diffComponents.second ?? 0)"
        
        DatabaseManager().saveTour(tour: tour)
    }
}
