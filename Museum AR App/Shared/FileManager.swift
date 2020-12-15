//
//  FileManager.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 31/7/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import Foundation
import Alamofire
import SSZipArchive

class FileManager {
    static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    static func getDocumentPaths() -> [String] {
        
    }
}
