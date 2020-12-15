//
//  ScannerViewController.swift
//  Tzoker
//
//  Created by Christos Christou on 12/11/19.
//  Copyright © 2019 ARX.NET. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController {
    
    // MARK: - IBAttributes

    @IBOutlet weak var cameraAccessView: CameraAccessView! {
        didSet {
            self.cameraAccessView.alpha = 0
        }
    }
    
    // MARK: - Attributes
    
    var captureSession: AVCaptureSession?
    var didAppearOnce: Bool = false
    var maskView: UIView?
    var isSendingData = false
    var accessIsGranted: Bool = false
    var supportedBarCodes = [AVMetadataObject.ObjectType.upce,
                             AVMetadataObject.ObjectType.code39,
                             AVMetadataObject.ObjectType.code39Mod43,
                             AVMetadataObject.ObjectType.ean13,
                             AVMetadataObject.ObjectType.ean8,
                             AVMetadataObject.ObjectType.code93,
                             AVMetadataObject.ObjectType.code128,
                             AVMetadataObject.ObjectType.pdf417,
                             AVMetadataObject.ObjectType.qr,
                             AVMetadataObject.ObjectType.aztec,
                             AVMetadataObject.ObjectType.interleaved2of5,
                             AVMetadataObject.ObjectType.itf14,
                             AVMetadataObject.ObjectType.dataMatrix]

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.setUpNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopCapture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.didAppearOnce {
            self.didAppearOnce = true
            self.setUpCameraAccess()
        } else {
            self.startCapture()
        }
        
    }
    
    // MARK: - IBMethods
    
    @IBAction func tappedOnView(_ sender: UITapGestureRecognizer) {
        self.focus()
    }
    
    // MARK: - Methods
    
    fileprivate func setUpNavigationItem() {
        
    }
    
    fileprivate func setUpCameraAccess() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if cameraStatus != .authorized {
            self.requestAccess()
        } else {
            self.setScannerOutput()
            self.createMask()
            self.startCapture()
        }
    }
    
    fileprivate func createMask() {
        
        self.maskView = UIView()
        self.maskView?.backgroundColor = UIColor(white: 0, alpha: 0.5) //you can modify this to whatever you need
        self.maskView?.frame = self.view.bounds
        self.view.addSubview(self.maskView!)
        
        let cameraLineViewRect = CGRect(x: 32, y: self.view.frame.height/4, width: self.view.frame.width - 64, height: self.view.frame.height/2)
        
        // Set the mask in the created view
        setMask(with: cameraLineViewRect, in: maskView!)
        
        let redLineRect = CGRect(x: 32, y: self.view.frame.height/2 - 1, width:self.view.frame.width - 64, height: 1)
        let redLiveView = UIView(frame: redLineRect)
        redLiveView.backgroundColor = UIColor.red
        self.view.addSubview(redLiveView)
    }
    
    fileprivate func setMask(with hole: CGRect, in view: UIView){
        
        // Create a mutable path and add a rectangle that will be h
        let mutablePath = CGMutablePath()
        mutablePath.addRect(view.bounds)
        mutablePath.addRect(hole)
        
        // Create a shape layer and cut out the intersection
        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        
        // Add the mask to the view
        view.layer.mask = mask
    }
    
    fileprivate func focus() {
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            if device.isFocusPointOfInterestSupported {
                do {
                    try device.lockForConfiguration()
                    let center = CGPoint(x: 0.5, y: 0.5)
                    device.focusPointOfInterest = center
                    if device.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus) {
                        device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                    }
                } catch _ {
                    return
                }
            }
        }
    }
    
}

extension ScannerViewController {
    
    fileprivate func requestAccess() {
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
            
            if !granted {
                
                DispatchQueue.main.async {
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.cameraAccessView.alpha = 1
                    })
                    
                    return
                }
            } else {
                
                DispatchQueue.main.async {
                    
                    self.setScannerOutput()
                    self.createMask()
                    self.startCapture()
                    
                }
                
            }
        })
        
    }
    
    fileprivate func setScannerOutput() {
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            captureSession = AVCaptureSession()
            
            captureSession?.addInput(input)
        
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            guard let captureSession = captureSession else {
                
                return
            }

            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                
            videoPreviewLayer.videoGravity  = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame         = view.layer.bounds
            let cameraView = UIView()
            cameraView.frame = view.bounds
            cameraView.backgroundColor = UIColor.black
            cameraView.alpha = 0
            
            cameraView.layer.addSublayer(videoPreviewLayer)
            self.view.addSubview(cameraView)
            UIView.animate(withDuration: 0.5, animations: {
                cameraView.alpha = 1
            })
            
            
        } catch {
            
        }
    }
    
    fileprivate func startCapture() {
        self.isSendingData = false
        if captureSession?.isRunning == false {
            self.captureSession?.startRunning()
        }
    }
    
    fileprivate func stopCapture() {
        self.isSendingData = true
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
    
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        guard !isSendingData else {
            return
        }
        
        guard metadataObjects.count > 0 else {
            return
        }
        
        guard let meta = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            
            return
        }
        
        guard supportedBarCodes.contains(meta.type) else {
            
            return
        }
        
        guard let barcode = meta.stringValue else {
            
            return
        }
        
        stopCapture()
        
        
    }

    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!) {
       
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
   fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
       return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
   }
