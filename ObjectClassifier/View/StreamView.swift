//
//  StreamViewView.swift
//  ObjectClassifier
//
//  Created by Dave on 22/07/24.
//

import SwiftUI

struct StreamViewView: View {
    
    let model = MobileNetV2()
    
    @State var viewModel = StreamViewModel(cameraService: CameraService())
    var traslater = Translater()
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack {
            if let frame = viewModel.cameraService.cameraFrame {
                VStack{
                    Image(decorative: frame, scale: 1, orientation: .right)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth:.infinity, maxHeight: 800)
                        .ignoresSafeArea()
                    Text(viewModel.resultLabel)
                        .padding(.all, 12)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .background( .green )
                        .cornerRadius(20)
                }.onAppear(perform: {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        viewModel.classify(model: model)
                        traslater.translate(viewModel: viewModel)
                    }
                })
            } else {
                VStack{
                    ProgressView()
                }
            }
        }.onDisappear(perform: {
            viewModel.cameraService.stopSession()
        })
    }
}
