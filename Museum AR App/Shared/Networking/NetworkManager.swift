//
//  NetworkManager.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 29/7/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import Alamofire
import Foundation
import Zip

class NetworkManager {
    
    static let fileManager = FileManager.default
    static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    static func get3DAssetsZip(zip: String, onCompletion: (() -> Void)? = nil) {
        
        print("Get 3D Assets Zip")
        
        let destination : DownloadRequest.Destination = {_, _ in
            let fileURL = documentsURL.appendingPathComponent(zip)
            
            return (fileURL, [.removePreviousFile])
        }
        
        AF.download("https://public.arx.net/~ppeltekis/museum_assets/\(zip)", to: destination)
            .downloadProgress(closure: { (progress) in
                print("Download Progress ->", progress.fractionCompleted)
            })
            .response(completionHandler: { response in
            
            if response.error == nil, let zip = response.fileURL?.path {
                
                do {
                    let text2 = try String(contentsOf: URL(string: zip)!, encoding: .utf8)
                    print(text2)
                }
                catch {/* error handling here */}
                
                print(response.debugDescription)
                
                print("Zip Filepath: ", zip)
                
                do {
                    if fileManager.fileExists(atPath: zip) {
                        print("File Available")
                        try Zip.unzipFile(URL(fileURLWithPath: zip), destination: documentsURL, overwrite: true, password: nil)
                        
                        onCompletion?()
                        
                    } else {
                        print("File Unavailable")
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print(response.error)
            }
        }).validate()
    }
    
    static func get3DAsset(object: String) {
        let destination : DownloadRequest.Destination = {_, _ in
            let fileURL = documentsURL.appendingPathComponent(object)

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download("https://public.arx.net/~ppeltekis/museum_assets/Billboard_matchm_night/\(object)", to: destination).response(completionHandler: { response in
            if response.error == nil, let object = response.fileURL?.path {
                
                print("Filepath: ", object)
                
                var text2 = ""
                
                do {
                    text2 = try String(contentsOf: response.fileURL!, encoding: .utf8)
                }
                catch {
                    /* error handling here */
                }
                
                print(text2)
            }
        })
    }
    
    static func getDocumentFilesPaths() -> [String] {
        var paths: [String] = []
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)

            for path in fileURLs {
                let final_path = path.absoluteString.replacingOccurrences(of: "file:///", with: "/")
                paths.append(final_path)
            }
        } catch {
            print("Error while enumerating files : \(error.localizedDescription)")
        }
        
        return paths
    }
}
