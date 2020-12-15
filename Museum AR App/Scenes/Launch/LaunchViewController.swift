//
//  LaunchViewController.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 17/11/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import GLTFSceneKit
import SceneKit
import UIKit

class LaunchViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - IBProperties
    
    @IBOutlet weak var threeDimensionsViewerButton: UIButton!
    
    @IBAction func threeDimensionsViewerButtonTap(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "AssetsViewer", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AssetsViewerViewControllerIdentifier") as? AssetsViewerViewController else { return }
        
        self.present(viewController, animated: true)
        
    }
    
    @IBOutlet weak var arLocationButton: UIButton!
    
    @IBAction func arLocationButtonTap(_ sender: Any) {
        
        let viewController = ARLocationViewController()
        
        self.view.window?.rootViewController = viewController
        
    }
    
    
    @IBOutlet weak var arButton: UIButton!
    
    @IBAction func arButtonTap(_ sender: Any) {
        
        self.arButton.isEnabled = false
        
        NetworkManager.get3DAssetsZip(zip: "octagon.zip") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewControllerIdentifier") as? MainViewController else { return }
            
            self.view.window?.rootViewController = viewController
        }
        
    }
    
    // MARK: - Lifecycle
    
    
    
    // MARK: - Methods
    
    
    
}
