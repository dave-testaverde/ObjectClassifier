//
//  CoreMLwithSwiftUIApp.swift
//  CoreMLwithSwiftUI
//
//  Created by Moritz Philip Recke for Create with Swift on 24 May 2021.
//

import SwiftUI
import CoreML

@main
struct ObjectClassifierApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                CameraView()
            } else {
                VersionIssuesView()
            }
        }
    }
}
