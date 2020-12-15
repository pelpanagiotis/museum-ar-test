//
//  CameraAccessView.swift
//  Tzoker
//
//  Created by Christos Christou on 12/11/19.
//  Copyright © 2019 ARX.NET. All rights reserved.
//

import UIKit

class CameraAccessView: UIView {
    
    // MARK: - IBProperties
    
    @IBOutlet var view: UIView! {
        didSet {
            self.view.backgroundColor =  UIColor.white
        }
    }
    
    @IBOutlet weak var goToSettingsButton: UIButton! {
        didSet {
            self.goToSettingsButton.setTitle("", for: .normal)
        }
    }
    
    // MARK: - Life cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    
    @IBAction func goToSettingsButtonPressed(_ sender: UIButton) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }

        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            print("Settings opened: \(success)")
        })
        
    }
}
