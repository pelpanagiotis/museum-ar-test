//
//  DemoStep.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 8/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

enum DemoStep: UInt {
    case prepare                // prepare to start
    case createCloudAnchor      // the session will create a cloud anchor
    case lookForAnchor          // the session will look for an anchor
    case lookForNearbyAnchors   // the session will look for nearby anchors
    case stopWatcher            // the watcher will stop looking for anchors
    case deleteFoundAnchors     // the session will delete found anchors
    case stopSession            // the session will stop and be cleaned up
}
