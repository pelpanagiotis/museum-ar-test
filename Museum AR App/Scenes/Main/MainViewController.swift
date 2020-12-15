//
//  ViewController.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 29/7/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//


import ARKit
import GLTFSceneKit
import RealityKit
import SceneKit.ModelIO
import UIKit

class MainViewController: UIViewController , ARSessionDelegate {
    
    //MARK: - IBProperties
    
    @IBOutlet var sceneView: ARSCNView!
    
    //MARK: - Properties
    
    let nodeName = "matchmaker_night"
    let zipFileName = "octagon.zip"
    let fileName = "octagon.glb"

    var filePaths: [String] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        
        sceneViewSetup()
        setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.autoenablesDefaultLighting = true

        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - Methods
    
    func sceneViewSetup() {
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        sceneView.antialiasingMode = .none
    }
    
    func setup() {
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.sceneView.session.pause()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            let configuration = ARWorldTrackingConfiguration()
            self?.sceneView.session.run(configuration, options: [])
        }
        
        self.filePaths = NetworkManager.getDocumentFilesPaths()
        print("FilePaths: ", self.filePaths)
        self.addExhibit()
        
    }
    
    func addExhibit() {
        
        for path in filePaths {
            if path.hasSuffix(fileName) {

                do {
                    let sceneS = try GLTFSceneSource(path: "art.scnassets/apsidal_chamber.glb")
                    
                    try sceneS.scene().rootNode.childNode(withName: "Apsidal_Chamber", recursively: true)!.scale = SCNVector3(0.0001, 0.0001, 0.0001)

                    sceneView.scene = try sceneS.scene()


                } catch {

                    print("\(error.localizedDescription)")
                    return

                }

            }
        }
        
    }
    
}
