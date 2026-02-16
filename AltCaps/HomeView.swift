//
//  HomeView.swift
//  AltCaps
//
//  Created by Mark Weller on 2/16/26.
//


import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "keyboard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(.top, 20)

                Text("AltCaps Keyboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Automatically capitalizes every other letter while keeping the first letter unchanged.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                NavigationLink("How to Enable Keyboard") {
                    EnableInstructionsView()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink("Test Keyboard") {
                    KeyboardTestView()
                }
                .buttonStyle(.bordered)

                NavigationLink("Privacy & Data") {
                    PrivacyView()
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
        }
    }
}
