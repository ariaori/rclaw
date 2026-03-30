//
//  Company.swift
//  rclaw
//
//  Model representing company data for multi-tenant expense tracking
//

import Foundation

struct Company: Codable, Identifiable {
    let id: UUID
    var name: String
    var address: String
    var taxId: String
    let adminUserId: UUID
    var settings: CompanySettings
    let createdAt: Date
    var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case taxId = "tax_id"
        case adminUserId = "admin_user_id"
        case settings
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct CompanySettings: Codable {
    var fiscalYearEnd: String?
    var defaultCategory: String?
    var autoCategorizationEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case fiscalYearEnd = "fiscal_year_end"
        case defaultCategory = "default_category"
        case autoCategorizationEnabled = "auto_categorization_enabled"
    }

    init() {
        self.fiscalYearEnd = nil
        self.defaultCategory = nil
        self.autoCategorizationEnabled = true
    }
}
