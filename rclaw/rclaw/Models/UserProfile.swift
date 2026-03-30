//
//  UserProfile.swift
//  rclaw
//
//  Model representing user profile data extending Supabase auth.users
//

import Foundation

struct UserProfile: Codable, Identifiable {
    let id: UUID
    var fullName: String
    var role: UserRole
    var companyId: UUID?
    let createdAt: Date
    var updatedAt: Date
    var lastLoginAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case role
        case companyId = "company_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastLoginAt = "last_login_at"
    }
}

enum UserRole: String, Codable {
    case admin
    case member

    var displayName: String {
        switch self {
        case .admin:
            return "Admin"
        case .member:
            return "Member"
        }
    }
}
