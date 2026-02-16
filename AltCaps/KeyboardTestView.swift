//
//  KeyboardTestView.swift
//  AltCaps
//
//  Created by Mark Weller on 2/16/26.
//


import SwiftUI

struct KeyboardTestView: View {
    @State private var text: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Keyboard Test")
                .font(.title)
                .fontWeight(.bold)

            Text("Tap the field below and switch to the AltCaps Keyboard using the globe icon.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            TextEditor(text: $text)
                .frame(height: 200)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(12)

            Text("Output Preview:")
                .font(.headline)

            ScrollView {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
    }
}
