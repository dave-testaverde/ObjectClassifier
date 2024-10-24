//
//  StreamViewView.swift
//  ObjectClassifier
//
//  Created by Dave on 22/07/24.
//

import SwiftUI

import MLKit

struct StreamViewView: View {
    
    let model = MobileNetV2()
    
    @State var viewModel = StreamViewModel(cameraService: CameraService())
    @State var translator = MLTranslator()
    
    @State var availableLang: [String] = []
    @State var selectedLang : String = MLTranslator.langNetLabel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        @Bindable var translator = translator
        
        let availableLang = translator.availableLangs.keys.map { key in
            key
        }
        
        VStack {
            if let frame = viewModel.cameraService.cameraFrame {
                VStack {
                    Image(decorative: frame, scale: 1, orientation: .right)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth:.infinity, maxHeight: 760)
                        .ignoresSafeArea()
                    Menu {
                        Picker("Languages", selection: $translator.langTargetLabel) {
                            ForEach(availableLang, id: \.self) { lang in
                                Text(lang)
                            }
                        }
                    } label: {
                        Text(translator.langTargetLabel)
                            .padding(.all, 12)
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                    .id(translator.langTargetLabel)
                    Text(viewModel.resultLabel)
                        .padding(.all, 12)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .background(.green)
                        .cornerRadius(20)
                        .padding(.bottom, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                /*.onAppear(perform: {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        viewModel.classify(model: model)
                        if(translator.languageTarget != MLTranslator.langNet){
                            translator.translate(viewModel: viewModel)
                        } else {
                            viewModel.resultLabel = viewModel.netResultLabel
                        }
                    }
                })*/
                .onReceive(viewModel.currentTimePublisher) { newCurrentTime in
                    viewModel.classify(model: model)
                    if(translator.languageTarget != MLTranslator.langNet){
                        translator.translate(viewModel: viewModel)
                    } else {
                        viewModel.resultLabel = viewModel.netResultLabel
                    }
                }
            } else {
                VStack{
                    ProgressView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onDisappear(perform: {
            viewModel.cameraService.stopSession()
        })
    }
}
