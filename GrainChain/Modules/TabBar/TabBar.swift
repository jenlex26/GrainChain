//
//  TabBar.swift
//  GrainChain
//
//  Created by Javier Hernandez on 09/09/21.
//

import Foundation
import UIKit

class ContentTabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        let mapController = MapsTrackingController()
        
        let navigationController = UINavigationController(rootViewController: mapController)
        let navigationTourController = UINavigationController(rootViewController: TrackingController())
        navigationController.tabBarItem = UITabBarItem(title: "Mapa", image: UIImage(named: "mapa"), selectedImage: nil)
        navigationTourController.tabBarItem = UITabBarItem(title: "Rutas", image: UIImage(named: "ruta"), selectedImage: nil)
        
        viewControllers = [navigationController, navigationTourController]
    }
    
    func setAppearance() {
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .white
        UITabBar.appearance().barTintColor = .white
    }
}
