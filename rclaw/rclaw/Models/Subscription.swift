//
//  Subscription.swift
//  rclaw
//
//  Model representing recurring subscription expenses
//

import Foundation

struct Subscription: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let companyId: UUID
    var name: String
    var amount: Decimal
    var frequency: SubscriptionFrequency
    var startDate: Date
    var category: String
    var isActive: Bool
    var nextBillingDate: Date
    var notes: String?
    let createdAt: Date
    var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case companyId = "company_id"
        case name
        case amount
        case frequency
        case startDate = "start_date"
        case category
        case isActive = "is_active"
        case nextBillingDate = "next_billing_date"
        case notes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    /// Calculate the yearly cost for this subscription
    var yearlyAmount: Decimal {
        switch frequency {
        case .weekly:
            return amount * 52
        case .monthly:
            return amount * 12
        case .quarterly:
            return amount * 4
        case .yearly:
            return amount
        }
    }
}

enum SubscriptionFrequency: String, Codable, CaseIterable {
    case weekly
    case monthly
    case quarterly
    case yearly

    var displayName: String {
        rawValue.capitalized
    }

    var description: String {
        switch self {
        case .weekly:
            return "Every week (52 times/year)"
        case .monthly:
            return "Every month (12 times/year)"
        case .quarterly:
            return "Every quarter (4 times/year)"
        case .yearly:
            return "Once per year"
        }
    }
}
