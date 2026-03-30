//
//  SupabaseClient.swift
//  rclaw
//
//  Supabase client configuration and singleton instance
//

import Foundation
import Supabase

enum SupabaseEnvironment {
    case staging
    case production

    // Change this to switch between staging and production
    static let current: SupabaseEnvironment = .staging
}

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        let (url, key) = SupabaseEnvironment.current == .staging
            ? ("https://qczbfdvlmdaflcvlkrtx.supabase.co",
               "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjemJmZHZsbWRhZmxjdmxrcnR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ4MTM4OTgsImV4cCI6MjA5MDM4OTg5OH0._qQ7n9GHHFIepjSCeRw-M_9DZpj8H21-LQpc8P_1PUE")
            : ("https://YOUR_PROD_PROJECT.supabase.co",
               "YOUR_PROD_ANON_KEY")

        guard let supabaseURL = URL(string: url) else {
            fatalError("Invalid Supabase URL")
        }

        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: key
        )

        #if DEBUG
        print("🔧 Supabase Environment: \(SupabaseEnvironment.current)")
        print("🌐 Supabase URL: \(url)")
        #endif
    }
}
