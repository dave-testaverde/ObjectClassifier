//
//  CameraService.swift
//  ObjectClassifier
//
//  Created by Dave on 22/07/24.
//

import Foundation
import CoreGraphics
import AVFoundation
import CoreImage

@Observable
class CameraService: NSObject {
    
    var cameraFrame: CGImage?
    
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let captureQueue = DispatchQueue.init(label: "Camera.service", qos: .userInitiated)
    
    override init() {
        super.init()
        addCameraInput()
        addVideoOutput()
        startSession()
    }
    
    private func addCameraInput() {
       if let device = AVCaptureDevice.default(for: .video) {
           do {
               let cameraInput = try AVCaptureDeviceInput(device: device)
               self.captureSession.addInput(cameraInput)
           } catch let error {
               print("Error: \(error.localizedDescription)")
           }
       }
    }
    
    private func addVideoOutput() {
       self.videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
       self.videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
       self.captureSession.addOutput(videoOutput)
    }
    
    private func startSession() {
       DispatchQueue.global(qos: .background).async {
         [weak self] in
             guard let self = self else { return }
             self.captureSession.startRunning()
       }
    }
        
    func stopSession() {
       DispatchQueue.global(qos: .background).async {
         [weak self] in
             guard let self = self else { return }
             self.captureSession.stopRunning()
       }
    }
    
}

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            let ciiImage = CIImage(cvPixelBuffer: imageBuffer!)
            if let cgImage = self.getCGImage(ciiImage) {
                self.cameraFrame = cgImage
            }
        }
    }
    
    func getCGImage(_ inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
    
}
