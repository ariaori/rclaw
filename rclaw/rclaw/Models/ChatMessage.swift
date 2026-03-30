//
//  ChatMessage.swift
//  rclaw
//
//  Model representing chat messages in the agent-based UI
//

import Foundation

struct ChatMessage: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let companyId: UUID
    var receiptId: UUID?
    let messageType: MessageType
    var content: String
    var metadata: MessageMetadata
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case companyId = "company_id"
        case receiptId = "receipt_id"
        case messageType = "message_type"
        case content
        case metadata
        case createdAt = "created_at"
    }

    var isFromUser: Bool {
        messageType == .user
    }
}

enum MessageType: String, Codable {
    case user
    case agent
    case system

    var displayName: String {
        switch self {
        case .user:
            return "You"
        case .agent:
            return "RClaw Assistant"
        case .system:
            return "System"
        }
    }
}

struct MessageMetadata: Codable {
    var scanResults: ScanResults?
    var corrections: [String: String]?
    var imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case scanResults = "scan_results"
        case corrections
        case imageUrl = "image_url"
    }

    init() {
        self.scanResults = nil
        self.corrections = nil
        self.imageUrl = nil
    }

    init(scanResults: ScanResults? = nil, corrections: [String: String]? = nil, imageUrl: String? = nil) {
        self.scanResults = scanResults
        self.corrections = corrections
        self.imageUrl = imageUrl
    }
}

struct ScanResults: Codable {
    var merchantName: String?
    var amount: Decimal?
    var date: Date?
    var suggestedCategory: String?
    var confidence: Double?

    enum CodingKeys: String, CodingKey {
        case merchantName = "merchant_name"
        case amount
        case date
        case suggestedCategory = "suggested_category"
        case confidence
    }
}
