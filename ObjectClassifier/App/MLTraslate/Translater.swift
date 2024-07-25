//
//  Translater.swift
//  ObjectClassifier
//
//  Created by Dave on 23/07/24.
//

import Foundation
import MLKit

@Observable
class Translater {
    var options: TranslatorOptions
    var translator: Translator?

    var conditions : ModelDownloadConditions
    
    var languageTarget: TranslateLanguage
    var langTargetLabel: String = "english" {
        willSet {
            print("From \(langTargetLabel) to \(newValue)")
        }
        didSet {
            syncLanguageTarget()
        }
    }
    
    var availableLangs: [String: TranslateLanguage] = [:]
        
    init(){
        self.options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .spanish)
        self.conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        self.languageTarget = .english
        initAvailableLanguages()
    }
    
    func configLang(){
        self.options = TranslatorOptions(sourceLanguage: .english, targetLanguage: self.languageTarget)
        self.translator = Translator.translator(options: options)
    }
    
    func syncLanguageTarget(){
        if(self.availableLangs.contains(where: { $0.key == self.langTargetLabel })){
            print(self.availableLangs[langTargetLabel]!)
            self.languageTarget = self.availableLangs[langTargetLabel]!
            self.configLang()
        }
    }
    
    func initAvailableLanguages(){
        self.availableLangs = [
            "greek" : .greek,
            "german" : .german,
            "french" : .french,
            "spanish" : .spanish,
            "english" : .english,
            "chinese" : .chinese,
            "russian" : .russian,
        ]
    }
    
    func translate(viewModel: StreamViewModel){
        self.translator = Translator.translator(options: options)
        
        translator!.downloadModelIfNeeded(with: conditions) { [self] error in
            guard error == nil else { return }

            translator!.translate(viewModel.netResultLabel) { translatedText, error in
                guard error == nil, let translatedText = translatedText
                else {
                    print(error as Any)
                    return
                }
                viewModel.resultLabel = translatedText
            }
        }
    }
}
