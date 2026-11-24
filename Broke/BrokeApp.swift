//
//  BrokeApp.swift
//  Broke
//
//  Created by Oz Tamir on 19/08/2024.
//

import SwiftUI

@main
struct BrokeApp: App {
    @StateObject private var appBlocker = AppBlocker()
    @StateObject private var profileManager = ProfileManager()

    var body: some Scene {
        WindowGroup {
            BrokerView()
                .environmentObject(appBlocker)
                .environmentObject(profileManager)
                .onOpenURL { url in
                    handleIncomingURL(url)
                }
        }
    }

    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "broke" else { return }

        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let action = components?.queryItems?.first(where: { $0.name == "action" })?.value

        switch action {
        case "toggle":
            appBlocker.toggleBlocking(for: profileManager.currentProfile)

            // Handle x-callback-url response
            if let successURL = components?.queryItems?.first(where: { $0.name == "x-success" })?.value,
               let successURL = URL(string: successURL) {
                UIApplication.shared.open(successURL)
            }
        default:
            break
        }
    }
}
