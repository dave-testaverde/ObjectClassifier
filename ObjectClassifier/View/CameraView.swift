//
//  CameraView.swift
//  ObjectClassifier
//
//  Created by dave on 04/07/24.
//

import SwiftUI
import PhotosUI

struct CameraView: View {
    
    let model = MobileNetV2()
    
    @State private var netResultLabel: String = ""
    @State private var showCamera = false
    @State private var imageCamera: UIImage?
    
    var body: some View {
            VStack {
                HStack{
                    if let imageCamera{
                        Image(uiImage: imageCamera)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
                HStack{
                    Button("Open camera") {
                        self.showCamera.toggle()
                    }
                    .fullScreenCover(isPresented: self.$showCamera) {
                        accessCameraView(selectedImage: self.$imageCamera)
                    }.padding()
                }
                HStack{
                    Button("Classify with MobileNetV2") {
                        classifyImage(img: imageCamera, model: model, cameraView: self)
                    }.buttonStyle(BorderlessButtonStyle())
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                HStack{
                    Text(netResultLabel)
                        .padding()
                        .font(.body)
                    Spacer()
                }
            }
            .background(Color.black)
    }
    
    func updateNetResultLabel(label: String = ""){
        self.netResultLabel = label
    }
    
}

#Preview {
    CameraView()
}
