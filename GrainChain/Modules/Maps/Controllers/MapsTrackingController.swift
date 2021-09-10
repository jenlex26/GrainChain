//
//  MapsTrackingController.swift
//  GrainChain
//
//  Created by Javier Hernandez on 09/09/21.
//

import UIKit
import GoogleMaps

class MapsTrackingController: UIViewController {
    // Propertys
    let mapView: GMSMapView = GMSMapView()
    var buttonRecording: UIButton = UIButton()
    var locationManager = CLLocationManager()
    var path = GMSMutablePath()
    var viewModel: MapTourViewModel = MapTourViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeTheLocationManager()
        setUI()
      
    }
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func setUI() {
        
        // Set MapView
        let lat = locationManager.location?.coordinate.latitude ?? 19.423655
        let log = locationManager.location?.coordinate.longitude ?? -99.162883
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: log, zoom: 15.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        
        // Set Button Recording
        buttonRecording.setTitle("Iniciar recorrido", for: .normal)
        buttonRecording.setTitle("Finalizar Recorrido", for: .selected)
        buttonRecording.addTarget(self, action: #selector(initRecording), for: .touchUpInside)
        buttonRecording.backgroundColor = .blue
        buttonRecording.translatesAutoresizingMaskIntoConstraints = false
        buttonRecording.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // set StackView For UI
        let stackVertical = UIStackView(arrangedSubviews: [mapView, buttonRecording])
        stackVertical.axis = .vertical
        view.addSubview(stackVertical)
        stackVertical.translatesAutoresizingMaskIntoConstraints = false
        stackVertical.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        stackVertical.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stackVertical.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stackVertical.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    
    
    @objc func initRecording() {
        buttonRecording.isSelected = !buttonRecording.isSelected
        if buttonRecording.isSelected {
            path = GMSMutablePath()
            mapView.clear()
            viewModel.cleanLocations()
            
            makeMarkerMap()
            guard let location = locationManager.location else { return }
            setAddLocation(location: location)
        } else {
            showAlertStopRecording()
            makeMarkerMap()
        }
    }
    
    func makeMarkerMap() {
        let markerImage = UIImage(named: "marker-storm")!.withRenderingMode(.alwaysOriginal)
        let markerView = UIImageView(image: markerImage)
        let lat = locationManager.location?.coordinate.latitude
        let log = locationManager.location?.coordinate.longitude
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat ?? 0, log ?? 0)
//        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.iconView = markerView
        marker.map = mapView
    }
    
    func showAlertStopRecording() {
        let alertControlller = UIAlertController(title: "Guardar Recorrido", message: "Ingresa un nombre al recorrido", preferredStyle: .alert)
        alertControlller.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Ingrese un nombre"
            textField.text = "Ruta - "
        }
        let saveAction = UIAlertAction(title: "Guardar Ruta", style: .default, handler: { alert -> Void in
            let name = alertControlller.textFields?[0]
            self.viewModel.saveTour(name: name?.text ?? "")
        })

        alertControlller.addAction(saveAction)

        self.present(alertControlller, animated: true, completion: nil)
    }
    
    func setAddLocation(location: CLLocation) {
        path.add(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 1.0
        rectangle.map = mapView
        
    }
}

extension MapsTrackingController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        if buttonRecording.isSelected {
            viewModel.setNewLocation(location: location)
            setAddLocation(location: location)
        }
    }
}
