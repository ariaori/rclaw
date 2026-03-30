//
//  CompanyService.swift
//  rclaw
//
//  Service for managing company data and member assignments
//

import Foundation
import Supabase

@MainActor
class CompanyService: ObservableObject {
    @Published var currentCompany: Company?
    @Published var companyMembers: [UserProfile] = []

    private let supabase = SupabaseManager.shared

    /// Create a new company (admin only)
    func createCompany(name: String, address: String, taxId: String, adminUserId: UUID) async throws -> Company {
        let company = Company(
            id: UUID(),
            name: name,
            address: address,
            taxId: taxId,
            adminUserId: adminUserId,
            settings: CompanySettings(),
            createdAt: Date(),
            updatedAt: Date()
        )

        try await supabase.client
            .from("companies")
            .insert(company)
            .execute()

        // Update user profile with company_id
        try await supabase.client
            .from("user_profiles")
            .update(["company_id": company.id.uuidString])
            .eq("id", value: adminUserId.uuidString)
            .execute()

        self.currentCompany = company
        return company
    }

    /// Load company for current user
    func loadCompany(for userId: UUID) async throws {
        let profile: UserProfile = try await supabase.client
            .from("user_profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value

        guard let companyId = profile.companyId else {
            self.currentCompany = nil
            return
        }

        let company: Company = try await supabase.client
            .from("companies")
            .select()
            .eq("id", value: companyId.uuidString)
            .single()
            .execute()
            .value

        self.currentCompany = company
        await loadCompanyMembers(companyId: companyId)
    }

    /// Update company information (admin only)
    func updateCompany(_ company: Company) async throws {
        try await supabase.client
            .from("companies")
            .update(company)
            .eq("id", value: company.id.uuidString)
            .execute()

        self.currentCompany = company
    }

    /// Load all members of the company
    func loadCompanyMembers(companyId: UUID) async {
        do {
            let members: [UserProfile] = try await supabase.client
                .from("user_profiles")
                .select()
                .eq("company_id", value: companyId.uuidString)
                .execute()
                .value

            self.companyMembers = members
        } catch {
            print("Error loading company members: \(error)")
        }
    }

    /// Add a member to the company (admin only)
    func addMember(email: String, fullName: String, companyId: UUID) async throws {
        // This would typically involve inviting the user via email
        // For now, we'll just create a pending invitation
        // In production, use Supabase Auth invite functionality
    }

    /// Remove a member from the company (admin only)
    func removeMember(userId: UUID) async throws {
        try await supabase.client
            .from("user_profiles")
            .update(["company_id": Optional<String>.none])
            .eq("id", value: userId.uuidString)
            .execute()

        companyMembers.removeAll { $0.id == userId }
    }
}
