//
//  SupabaseClient.swift
//  rclaw
//
//  Supabase client configuration and singleton instance
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        guard let supabaseURL = URL(string: "https://qczbfdvlmdaflcvlkrtx.supabase.co") else {
            fatalError("Invalid Supabase URL")
        }

        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjemJmZHZsbWRhZmxjdmxrcnR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ4MTM4OTgsImV4cCI6MjA5MDM4OTg5OH0._qQ7n9GHHFIepjSCeRw-M_9DZpj8H21-LQpc8P_1PUE"

        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}
