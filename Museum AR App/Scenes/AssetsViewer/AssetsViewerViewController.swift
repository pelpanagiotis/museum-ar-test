//
//  AssetsViewerViewController.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 18/11/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import GLTFSceneKit
import SceneKit
import UIKit

class AssetsViewerViewController: UIViewController {
    
    // MARK: - Properties
    
    var filePaths: [String] = []
    let zipFileName = "octagon.zip"
    let fileName = "octagon.glb"
    
    // MARK: - IBProperties
    
    @IBOutlet weak var sceneView: SCNView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.get3DAssetsZip(zip: zipFileName)
        
        filePaths = NetworkManager.getDocumentFilesPaths()
        
        self.addExhibit()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.addExhibit()
    }
    
    // MARK: - Methods
    
    func addExhibit() {
        
        
        
        for path in filePaths {
            if path.hasSuffix(fileName) {

                do {
                    
                    let sceneS = try GLTFSceneSource(path: path)
                    try sceneS.scene().rootNode.childNode(withName: "Octagon", recursively: true)!.scale = SCNVector3(0.001, 0.001, 0.001)
                    let newScene = SCNScene()
                    try newScene.rootNode.addChildNode( sceneS.scene().rootNode.childNode(withName: "Octagon", recursively: true)!)
                    
                    // 2: Add camera node
                    let cameraNode = SCNNode()
                    cameraNode.camera = SCNCamera()
                    // 3: Place camera
                    cameraNode.position = SCNVector3(x: 0, y: 0, z: 35)
                    // 4: Set camera on scene
                    newScene.rootNode.addChildNode(cameraNode)
                    
                    // 5: Adding light to scene
                    let lightNode = SCNNode()
                    lightNode.light = SCNLight()
                    lightNode.light?.type = .omni
                    lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
                    newScene.rootNode.addChildNode(lightNode)
                    
                    // 6: Creating and adding ambien light to scene
                    let ambientLightNode = SCNNode()
                    ambientLightNode.light = SCNLight()
                    ambientLightNode.light?.type = .ambient
                    ambientLightNode.light?.color = UIColor.darkGray
                    newScene.rootNode.addChildNode(ambientLightNode)
                    
                    // If you don't want to fix manually the lights
            //        sceneView.autoenablesDefaultLighting = true
                    
                    // Allow user to manipulate camera
                    sceneView.allowsCameraControl = true
                    
                    // Show FPS logs and timming
                    // sceneView.showsStatistics = true
                    
                    // Set background color
                    sceneView.backgroundColor = UIColor.white
                    
                    // Allow user translate image
                    sceneView.cameraControlConfiguration.allowsTranslation = false
                    
                    sceneView.scene = newScene
                    
                    // Set scene settings
//                    sceneView.scene = sceneS.scene()
                    
//                    let sceneS = try GLTFSceneSource(path: path)
//
//                    sceneView.autoenablesDefaultLighting = true
//
//                    let object = SCNSphere(radius: 0.01)
//                    let material = SCNMaterial()
//                    material.diffuse.contents = UIColor.red
//                    object.materials = [material]
//                    let node = SCNNode(geometry: object)
//                    node.position = SCNVector3(0, 0, 0)
//
//
//                    sceneView.scene?.rootNode.addChildNode(node)
//
//                    let cameraNode = SCNNode()
//                    cameraNode.camera = SCNCamera()
//                    cameraNode.position = SCNVector3(x: 0, y: 10, z: 35)
//                    sceneView.scene?.rootNode.addChildNode(cameraNode)
//
//                    try sceneS.scene().rootNode.childNode(withName: "Octagon", recursively: true)!.scale = SCNVector3(0.0001, 0.0001, 0.0001)




                } catch {

                    print("\(error.localizedDescription)")
                    return

                }

            }
        }
        
    }
    
}
