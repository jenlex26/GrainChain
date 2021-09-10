//
//  TrackingDetailController.swift
//  GrainChain
//
//  Created by Javier Hernandez on 09/09/21.
//

import UIKit
import GoogleMaps
protocol TourDetailControllerDelegate: AnyObject {
    func reload()
}
class TrackingDetailController: UIViewController{

    let mapView: GMSMapView = GMSMapView()
    let tableView: UITableView = UITableView()
    var viewModel: TrackingDetailViewModel?
    weak var delegate: TourDetailControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        setupTableView()
        viewModelSetup()
        viewModel?.fetch()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = viewModel?.getTitle().capitalized
        setNavBar()
    }
    
    func setNavBar() {
        let btnShare = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        let btnTrash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTour))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItems = [btnShare, btnTrash]
        navigationItem.leftBarButtonItem = done

    }
    @objc func doneAction() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func deleteTour() {
        let alert = UIAlertController(title: "¿Estas seguro?", message: "Estas seguro que quieres eliminar este recorrido", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Eliminar", style: .destructive) { (_) in
           self.viewModel?.deleteTour()
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    @objc func shareAction() {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img ?? UIImage()], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    func setMapView() {
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    func setRoute() {
        let tourModel = viewModel?.getTourForMap()
        let firstLocation = tourModel?.locations?.first?.coordinate
        let lastLocation = tourModel?.locations?.first?.coordinate
        
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
        guard let locations = tourModel?.locations else { return }
        for location in locations {
            path.add(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))
        }
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 1.0
        rectangle.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: latBeginning ?? 0, longitude: logBeginning ?? 0, zoom: 6.0)
        mapView.camera = camera
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func viewModelSetup() {
        viewModel?.reloadData = {[weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.setRoute()
            }
        }
        viewModel?.deleteComplete = {[weak self] () in
            DispatchQueue.main.async {
                self?.doneAction()
                self?.delegate?.reload()
            }
        }
    }

}
extension TrackingDetailController: UITableViewDelegate {
    
}

extension TrackingDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return mapView
        } else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Coordenadas"
        } else {
            return nil
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel?.numberOfLocation() ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDescription") ?? UITableViewCell()
            cell.textLabel?.text = viewModel?.getTour()
            cell.textLabel?.numberOfLines = 0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDescription") ?? UITableViewCell()
            cell.textLabel?.text = viewModel?.getLocationForCell(indexPath: indexPath)
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
}
