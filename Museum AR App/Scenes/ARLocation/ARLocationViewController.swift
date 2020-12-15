//
//  ARLocationViewController.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 20/11/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import ARCL
import CoreLocation
import UIKit

class ARLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    var sceneLocationView = SceneLocationView()
    
    // MARK: - IBProperties
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneLocationView.run()
        
        let coordinate = CLLocationCoordinate2D(latitude: 40.661740, longitude: 22.953705)
        let location = CLLocation(coordinate: coordinate, altitude: 100)
        let image = UIImage(named: "Paok24Placeholder")!
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = true
        
        view.addSubview(self.sceneLocationView)
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    // MARK: - Methods
    
    
}
