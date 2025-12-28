//
//  ForceUpdateView.swift
//  MrS-Cool
//
//  Created by mohamed hammam on 09/12/2025.
//
import SwiftUI

struct ForceUpdateView: View {
//    let latestVersion: String
    let appID: String = "6737163953"

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.blue)

            Text("Update_Required".localized)
                .font(.bold(size: 26))

            Text("A new version is AvailableYou must update to continue using the app".localized)
                .font(.regular(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: openStore) {
                Text("Update_Now".localized)
                    .font(.bold(size: 18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .ignoresSafeArea()
        .interactiveDismissDisabled(true)
    }

    private func openStore() {
//        https://apps.apple.com/eg/app/mr-s-cool/id6737163953
        if let url = URL(string: "https://apps.apple.com/app/id\(appID)") {
            UIApplication.shared.open(url)
        }
    }
}
