//
//  BaseViewController.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import ARKit
import AzureSpatialAnchors
import UIKit

enum DemoStep : Int {
    case prepare ///< prepare to start
    case createCloudAnchor ///< the session will create a cloud anchor
    case enterAnchorNumber ///< in the sharing sample, we will enter the anchor number to locate
    case lookForAnchor ///< the session will look for an anchor
    case lookForNearbyAnchors ///< the session will look for nearby anchors
    case stopWatcher ///< the watcher will stop looking for anchors
    case deleteFoundAnchors ///< the session will delete found anchors
    case stopSession
}

class AnchorVisual: NSObject {
    var node: SCNNode?
    var identifier: String?
    var cloudAnchor: ASACloudSpatialAnchor?
    var localAnchor: ARAnchor?
}
