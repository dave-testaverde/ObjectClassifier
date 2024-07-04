//
//  VersionIssuesView.swift
//  ObjectClassifier
//
//  Created by dave on 04/07/24.
//

import SwiftUI
import CoreML

struct VersionIssuesView: View {
    var body: some View {
        VStack {
            HStack{
                Text("This app need iOS 17+")
                    .padding()
                    .font(.body)
            }
        }
    }
}

#Preview {
    VersionIssuesView()
}
