//
//  Receipt.swift
//  rclaw
//
//  Model representing receipt data with IRS-compliant categorization
//

import Foundation

struct Receipt: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let companyId: UUID
    var imageUrl: String?
    var merchantName: String?
    var amount: Decimal?
    var receiptDate: Date?
    var category: String?
    var isVerified: Bool
    var notes: String?
    let createdAt: Date
    var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case companyId = "company_id"
        case imageUrl = "image_url"
        case merchantName = "merchant_name"
        case amount
        case receiptDate = "receipt_date"
        case category
        case isVerified = "is_verified"
        case notes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// IRS Schedule C compliant categories (matching existing PhotoProcessingView)
enum ExpenseCategory: String, CaseIterable {
    case mealsEntertainment = "Meals & Entertainment"
    case travel = "Travel"
    case autoMileage = "Auto & Mileage"
    case officeSupplies = "Office Supplies"
    case officeExpenses = "Office Expenses"
    case utilities = "Utilities"
    case rentLease = "Rent & Lease"
    case marketing = "Marketing & Advertising"
    case professionalServices = "Professional Services"
    case insurance = "Insurance"
    case repairsMaintenance = "Repairs & Maintenance"
    case taxesLicenses = "Taxes & Licenses"
    case equipmentSupplies = "Equipment & Supplies"
    case other = "Other"

    var deductionPercentage: Double {
        switch self {
        case .mealsEntertainment:
            return 0.50 // 50% deductible per IRS Pub 463
        default:
            return 1.0 // 100% deductible
        }
    }

    var description: String {
        switch self {
        case .mealsEntertainment:
            return "50% deductible (per IRS Pub 463)"
        case .travel:
            return "Flights, hotels, accommodations"
        case .autoMileage:
            return "Standard or actual method"
        case .officeSupplies:
            return "Paper, pens, basic supplies"
        case .officeExpenses:
            return "Software, phone, postage"
        case .utilities:
            return "Percentage based on business use"
        case .rentLease:
            return "Office or equipment rent"
        case .marketing:
            return "Advertising and promotion"
        case .professionalServices:
            return "CPA, legal, consulting fees"
        case .insurance:
            return "Business liability/property"
        case .repairsMaintenance:
            return "Building/equipment maintenance"
        case .taxesLicenses:
            return "Business licenses, property tax"
        case .equipmentSupplies:
            return "Tools, machinery"
        case .other:
            return "Miscellaneous expenses"
        }
    }
}
