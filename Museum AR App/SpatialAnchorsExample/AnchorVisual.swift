//
//  AnchorVisual.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 8/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import ARKit
import AzureSpatialAnchors

class AnchorVisual {
    init() {
        node = nil
        identifier = ""
        cloudAnchor = nil
        localAnchor = nil
    }
    
    var node : SCNNode? = nil
    var identifier : String
    var cloudAnchor : ASACloudSpatialAnchor? = nil
    var localAnchor : ARAnchor? = nil
}

