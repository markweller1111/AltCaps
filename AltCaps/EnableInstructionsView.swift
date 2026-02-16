//
//  EnableInstructionsView.swift
//  AltCaps
//
//  Created by Mark Weller on 2/16/26.
//


import SwiftUI

struct EnableInstructionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("How to Enable AltCaps Keyboard")
                .font(.title)
                .fontWeight(.bold)

            Group {
                Text("1. Open the Settings app")
                Text("2. Go to General → Keyboard → Keyboards")
                Text("3. Tap 'Add New Keyboard'")
                Text("4. Select 'AltCaps'")
                Text("5. Switch keyboards using the 🌐 globe key")
            }
            .font(.body)

            Spacer()
        }
        .padding()
    }
}
