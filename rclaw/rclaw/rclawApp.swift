import SwiftUI

@main
struct rclawApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Handle Supabase Auth deep link callback
                    Task {
                        do {
                            try await SupabaseManager.shared.client.auth.session(from: url)
                        } catch {
                            print("Error handling auth callback: \(error)")
                        }
                    }
                }
        }
    }
}
