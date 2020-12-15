//
//  LocationProviderSensorStatus.swift
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

import AzureSpatialAnchors

class LocationProviderSensorStatus {
    private var locationProvider: ASAPlatformLocationProvider?

    func geoLocationStatus() -> SensorStatus {
        if locationProvider == nil {
            return .indeterminate
        }

        if locationProvider?.sensors.geoLocationEnabled == nil {
            return .blocked
        }

        switch locationProvider?.geoLocationStatus {
        case .available:
            return .available
        case .disabledCapability:
            return .blocked
        case .missingSensorFingerprintProvider:
            return .indeterminate
        case .noGPSData:
            return .unavailable
        default:
            break
        }

        return .indeterminate
    }

    func wifiSignal() -> SensorStatus {
        if locationProvider == nil {
            return .indeterminate
        }

        if locationProvider?.sensors.wifiEnabled == nil {
            return .blocked
        }

        switch locationProvider?.wifiStatus {
        case .available:
            return .available
        case .disabledCapability:
            return .blocked
        case .missingSensorFingerprintProvider:
            return .indeterminate
        case .noAccessPointsFound:
            return .unavailable
        default:
            break
        }

        return .indeterminate
    }

    func bluetoothSignalStatus() -> SensorStatus {
        if locationProvider == nil {
            return .indeterminate
        }

        if !(locationProvider?.sensors.bluetoothEnabled)! {
            return .blocked
        }

        switch locationProvider!.bluetoothStatus {
        case .available:
            return .available
        case .disabledCapability:
            return .blocked
        case .missingSensorFingerprintProvider:
            return .indeterminate
        case .noBeaconsFound:
            return .unavailable
        default:
            break
        }

        return .indeterminate
    }

    init?(for locationProvider: ASAPlatformLocationProvider?) {
        self.locationProvider = locationProvider
    }
}
