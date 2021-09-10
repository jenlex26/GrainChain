//
//  TrackingCell.swift
//  GrainChain
//
//  Created by Javier Hernandez on 09/09/21.
//

import Foundation
import GoogleMaps
import UIKit

class TrackingCell: UITableViewCell {
    let mapView: GMSMapView = GMSMapView()
    let labelName: UILabel = UILabel()
    let labelTime: UILabel = UILabel()
    let labelKm: UILabel = UILabel()
    let labelDate: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
       
        let stackViewHorizontal = UIStackView(arrangedSubviews: [mapView, labelName, labelTime, labelKm, labelDate])
        stackViewHorizontal.axis = .vertical
        contentView.addSubview(stackViewHorizontal)
        stackViewHorizontal.layer.cornerRadius = 10
        stackViewHorizontal.clipsToBounds = true
        
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .systemBackground
            stackViewHorizontal.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
            contentView.backgroundColor = .lightGray
            stackViewHorizontal.backgroundColor = .white
        }
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.widthAnchor.constraint(equalToConstant: 200).isActive = true

        stackViewHorizontal.spacing = 10
        stackViewHorizontal.translatesAutoresizingMaskIntoConstraints = false
        stackViewHorizontal.heightAnchor.constraint(equalToConstant: 300).isActive = true
        stackViewHorizontal.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        stackViewHorizontal.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stackViewHorizontal.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        stackViewHorizontal.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
    }
    func setupCell(tour: Tour) {
        labelName.text = "Nombre: \(tour.name ?? "")"
        labelName.numberOfLines = 0
        
        labelTime.text = "Tiempo de recorrido: \(tour.time ?? "")"
        labelTime.numberOfLines = 0
        
        labelKm.text = "KM Recorridos: \(tour.km ?? "")"
        labelDate.text = "Fecha: \(tour.beginning ?? "")"
        
        labelKm.numberOfLines = 0
        
        

        let firstLocation = tour.locations?.first?.coordinate
        let lastLocation = tour.locations?.first?.coordinate
        
        let latBeginning = firstLocation?.latitude
        let logBeginning = firstLocation?.longitude
        
        let latEnd = lastLocation?.latitude
        let logEnd = lastLocation?.longitude
        
        
        let markerBeginning = GMSMarker()
        markerBeginning.position = CLLocationCoordinate2DMake(latBeginning ?? 0, logBeginning ?? 0)
        markerBeginning.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        markerBeginning.map = mapView
        
        let markerEnd = GMSMarker()
        markerEnd.position = CLLocationCoordinate2DMake(latEnd ?? 0, logEnd ?? 0)
        markerEnd.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        markerEnd.map = mapView
        
        
        let path = GMSMutablePath()
        guard let locations = tour.locations else { return }
        for location in locations {
            path.add(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))
        }
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 1.0
        rectangle.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: latBeginning ?? 0, longitude: logBeginning ?? 0, zoom: 6.0)
        mapView.camera = camera
        mapView.isUserInteractionEnabled = false
        
    }
}
