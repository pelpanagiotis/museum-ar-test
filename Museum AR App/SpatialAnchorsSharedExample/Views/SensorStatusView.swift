//
//  SensorStatusView.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import UIKit

class SensorStatusView: UIView {
    
    private weak var model: (NSObjectProtocol & SensorStatusModel)?
    
    @IBOutlet var geoLocationStatusIcon: UIImageView!
    @IBOutlet var wifiStatusIcon: UIImageView!
    @IBOutlet var bluetoothStatusIcon: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        let ownType = SensorStatusView.self
        let bundle = Bundle(for: ownType)
        let nib = bundle.loadNibNamed(NSStringFromClass(ownType.self), owner: self, options: nil)?.first as? UINib
        let contentView = nib?.instantiate(withOwner: self, options: nil).first as? UIView
        var adjustedFrame = frame
        adjustedFrame.size = contentView?.frame.size ?? CGSize.zero
        contentView?.frame = adjustedFrame
        self.addSubview(contentView!)

    }

    func setModel(_ model: (NSObjectProtocol & SensorStatusModel)?) {
        self.model = model
    }

    func update() {
        let geoLocationStatus = model == nil ? .indeterminate : model?.geoLocationStatus
        let wifiSignalStatus = model == nil ? .indeterminate : model?.wifiSignalStatus
        let bluetoothSignalStatus = model == nil ? .indeterminate : model?.bluetoothSignalStatus

        if let geoLocationStatus = geoLocationStatus {
            geoLocationStatusIcon.image = getIconFor(geoLocationStatus)
        }
        if let wifiSignalStatus = wifiSignalStatus {
            wifiStatusIcon.image = getIconFor(wifiSignalStatus)
        }
        if let bluetoothSignalStatus = bluetoothSignalStatus {
            bluetoothStatusIcon.image = getIconFor(bluetoothSignalStatus)
        }
    }

    func getIconFor(_ status: SensorStatus) -> UIImage? {
        switch status {
        case .indeterminate:
            return UIImage(named: "gray-circle")
        case .blocked:
            return UIImage(named: "red-circle")
        case .unavailable:
            return UIImage(named: "orange-circle")
        case .available:
            return UIImage(named: "green-circle")
        default:
            break
        }
    }
}
