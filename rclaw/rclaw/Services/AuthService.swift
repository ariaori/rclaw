//
//  AuthService.swift
//  rclaw
//
//  Authentication service handling user login, signup, and session management
//

import Foundation
import Supabase

@MainActor
class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var userProfile: UserProfile?
    @Published var isAuthenticated = false

    private let supabase = SupabaseManager.shared

    init() {
        Task {
            await checkSession()
        }
    }

    /// Check if user has active session
    func checkSession() async {
        do {
            let session = try await supabase.client.auth.session
            self.currentUser = session.user
            self.isAuthenticated = true
            await loadUserProfile()
        } catch {
            self.isAuthenticated = false
            self.currentUser = nil
            self.userProfile = nil
        }
    }

    /// Sign up a new user
    func signUp(email: String, password: String, fullName: String, role: UserRole) async throws {
        // Pass user metadata during signup - the database trigger will create the profile
        let response = try await supabase.client.auth.signUp(
            email: email,
            password: password,
            data: [
                "full_name": .string(fullName),
                "role": .string(role.rawValue)
            ]
        )

        self.currentUser = response.user
        self.isAuthenticated = true

        // Load the profile that was automatically created by the trigger
        await loadUserProfile()
    }

    /// Sign in existing user
    func signIn(email: String, password: String) async throws {
        let response = try await supabase.client.auth.signIn(
            email: email,
            password: password
        )

        self.currentUser = response.user
        self.isAuthenticated = true
        await loadUserProfile()

        // Update last login timestamp
        try await supabase.client
            .from("user_profiles")
            .update(["last_login_at": Date()])
            .eq("id", value: response.user.id.uuidString)
            .execute()
    }

    /// Sign out current user
    func signOut() async throws {
        try await supabase.client.auth.signOut()
        self.currentUser = nil
        self.userProfile = nil
        self.isAuthenticated = false
    }

    /// Load user profile from database
    private func loadUserProfile() async {
        guard let userId = currentUser?.id else { return }

        do {
            let response: UserProfile = try await supabase.client
                .from("user_profiles")
                .select()
                .eq("id", value: userId.uuidString)
                .single()
                .execute()
                .value

            self.userProfile = response
        } catch {
            print("Error loading user profile: \(error)")
        }
    }

    /// Check if current user is admin
    var isAdmin: Bool {
        userProfile?.role == .admin
    }
}
