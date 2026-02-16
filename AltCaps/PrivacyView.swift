//
//  PrivacyView.swift
//  AltCaps
//
//  Created by Mark Weller on 2/16/26.
//


import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy & Data")
                    .font(.title)
                    .fontWeight(.bold)

                Text("AltCaps Keyboard does NOT collect, store, or transmit any personal data.")

                Text("All text processing happens locally on your device.")

                Text("We do not track keystrokes, input, or personal information.")

                Text("The keyboard does not require Full Access and does not connect to the internet.")

                Text("Your typing stays private at all times.")
                    .fontWeight(.semibold)
            }
            .padding()
        }
    }
}
