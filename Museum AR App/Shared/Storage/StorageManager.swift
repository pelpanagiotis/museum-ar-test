//
//  StorageManager.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 14/10/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import Foundation

class StorageManager {
    
    static func clearContents(_ url:URL) {

        do {

            let contents = try FileManager.default.contentsOfDirectory(atPath: url.path)

            print("before  \(contents)")

            let urls = contents.map { URL(string:"\(url.appendingPathComponent("\($0)"))")! }

            urls.forEach {  try? FileManager.default.removeItem(at: $0) }

            let con = try FileManager.default.contentsOfDirectory(atPath: url.path)

            print("after \(con)")

        }
        catch {

            print(error)

        }

     }
}
