//
//  SceneLocationViewExtension.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 29/11/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import ARCL
import CoreLocation
import GLTFSceneKit

@available(iOS 11.0, *)
public extension SceneLocationView {
    
    func addΜonument(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D, Δaltitude: CLLocationDistance = -2.0) {
        
        guard let altitude = sceneLocationManager.currentLocation?.altitude else {
            return assertionFailure("We don't have an elevation")
        }
        
        
        
    }
    
}
