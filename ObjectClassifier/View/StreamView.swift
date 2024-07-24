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
    @State var translater = Translater()
    
    @State var availableLang: [String] = []
    @State var selectedLang : String = "english"
    
    var body: some View {
        @Bindable var viewModel = viewModel
        @Bindable var translater = translater
        
        var availableLang = translater.availableLangs.keys.map { key in
            key
        }
        
        VStack {
            if let frame = viewModel.cameraService.cameraFrame {
                VStack {
                    Image(decorative: frame, scale: 1, orientation: .right)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth:.infinity, maxHeight: 700)
                        .ignoresSafeArea()
                    Picker("Languages", selection: $selectedLang) {
                        ForEach(availableLang, id: \.self) { lang in
                            Text(lang)
                        }
                    }.onChange(of: selectedLang) { oldValue, newValue in
                        print("switch lang from \(oldValue) to \(newValue)")
                    }.padding(.top, 15)
                    Text(viewModel.resultLabel)
                        .padding(.all, 12)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .background( .green )
                        .cornerRadius(20)
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onAppear(perform: {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        viewModel.classify(model: model)
                        translater.translate(viewModel: viewModel)
                    }
                })
            } else {
                VStack{
                    ProgressView()
                }
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .ignoresSafeArea()
        .onDisappear(perform: {
            viewModel.cameraService.stopSession()
        })
    }
}
