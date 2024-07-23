//
//  Translater.swift
//  ObjectClassifier
//
//  Created by Dave on 23/07/24.
//

import Foundation

import MLKit

class Translater {
    let options: TranslatorOptions
    let translator: Translator

    let conditions : ModelDownloadConditions
    
    var languageTarget: TranslateLanguage = .italian
        
    init(){
        self.options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .spanish)
        self.translator = Translator.translator(options: options)
        self.conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
    }
    
    func translate(viewModel: StreamViewModel){
        translator.downloadModelIfNeeded(with: conditions) { [self] error in
            guard error == nil else { return }

            translator.translate(viewModel.netResultLabel) { translatedText, error in
                guard error == nil, let translatedText = translatedText
                else {
                    print(error)
                    return
                }
                viewModel.resultLabel = translatedText
            }
        }
    }
}
