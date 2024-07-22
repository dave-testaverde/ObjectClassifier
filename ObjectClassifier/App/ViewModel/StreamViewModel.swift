//
//  ViewModel.swift
//  ObjectClassifier
//
//  Created by Dave on 22/07/24.
//

import Foundation
import UIKit

@Observable
class StreamViewModel {
    
    var netResultLabel: String
    var cameraService: CameraService
    
    init(cameraService: CameraService) {
        self.netResultLabel = "Detection..."
        self.cameraService = cameraService
    }
    
    func classify(model: MobileNetV2) {
        let img : UIImage? = UIImage(cgImage: self.cameraService.cameraFrame!)
        
        guard
              let resizedImage = img!.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else { return }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            
            guard let resultFirst = results.first else { return }
            
            self.netResultLabel = "\(resultFirst.key) = \(String(format: "%.2f", resultFirst.value * 100))%"
            print(self.netResultLabel)
        }
    }
    
}
