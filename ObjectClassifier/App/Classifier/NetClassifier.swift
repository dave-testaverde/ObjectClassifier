//
//  Classifier.swift
//  ObjectClassifier
//
//  Created by dave on 04/07/24.
//

import Foundation
import UIKit

func classifyImage(img: UIImage?, model: MobileNetV2, cameraView: CameraView?) {
    guard let image = img,
          let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
          let buffer = resizedImage.convertToBuffer() else {
        return
    }
    
    let output = try? model.prediction(image: buffer)
    
    if let output = output {
        let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
        let result = results.map { (key, value) in
            return "\(key) = \(String(format: "%.2f", value * 100))%"
        }.joined(separator: "\n")
        
        cameraView!.updateNetResultLabel(label: result)
    }
}
