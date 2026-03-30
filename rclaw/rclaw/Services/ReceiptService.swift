//
//  ReceiptService.swift
//  rclaw
//
//  Service for managing receipt uploads, scanning, and categorization
//

import Foundation
import UIKit
import Vision
import VisionKit
import Supabase

@MainActor
class ReceiptService: ObservableObject {
    @Published var receipts: [Receipt] = []
    @Published var isProcessing = false

    private let supabase = SupabaseManager.shared

    /// Upload and process a receipt image
    func processReceipt(
        image: UIImage,
        userId: UUID,
        companyId: UUID
    ) async throws -> (receipt: Receipt, scanResults: ScanResults) {
        isProcessing = true
        defer { isProcessing = false }

        // Step 1: Upload image to Supabase Storage
        let imageUrl = try await uploadImage(image, companyId: companyId)

        // Step 2: Scan image using Apple Vision Framework
        let scanResults = try await scanReceiptImage(image)

        // Step 3: Create receipt record
        let receipt = Receipt(
            id: UUID(),
            userId: userId,
            companyId: companyId,
            imageUrl: imageUrl,
            merchantName: scanResults.merchantName,
            amount: scanResults.amount,
            receiptDate: scanResults.date,
            category: scanResults.suggestedCategory,
            isVerified: false,
            notes: nil,
            createdAt: Date(),
            updatedAt: Date()
        )

        try await supabase.client
            .from("receipts")
            .insert(receipt)
            .execute()

        receipts.append(receipt)

        return (receipt, scanResults)
    }

    /// Upload image to Supabase Storage
    private func uploadImage(_ image: UIImage, companyId: UUID) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ReceiptService", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Failed to convert image to JPEG"
            ])
        }

        let fileName = "\(companyId)/\(UUID().uuidString).jpg"

        try await supabase.client.storage
            .from("receipts")
            .upload(path: fileName, file: imageData, options: FileOptions(contentType: "image/jpeg"))

        let publicURL = try supabase.client.storage
            .from("receipts")
            .getPublicURL(path: fileName)

        return publicURL.absoluteString
    }

    /// Scan receipt using Apple Vision Framework
    private func scanReceiptImage(_ image: UIImage) async throws -> ScanResults {
        guard let cgImage = image.cgImage else {
            throw NSError(domain: "ReceiptService", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "Failed to get CGImage"
            ])
        }

        // Use VisionKit for text recognition
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])

        guard let observations = request.results else {
            return ScanResults()
        }

        // Extract text from observations
        let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }

        // Parse receipt data
        return parseReceiptText(recognizedStrings)
    }

    /// Parse extracted text to identify merchant, amount, date, etc.
    private func parseReceiptText(_ lines: [String]) -> ScanResults {
        var results = ScanResults()

        // Find merchant name (usually first few lines)
        if let merchantLine = lines.first {
            results.merchantName = merchantLine
        }

        // Find amount (look for currency patterns)
        let amountPattern = #"\\$?\\d+\\.\\d{2}"#
        for line in lines {
            if let range = line.range(of: amountPattern, options: .regularExpression) {
                let amountString = String(line[range]).replacingOccurrences(of: "$", with: "")
                results.amount = Decimal(string: amountString)
                break
            }
        }

        // Find date (look for date patterns)
        let datePattern = #"\\d{1,2}/\\d{1,2}/\\d{2,4}"#
        for line in lines {
            if let range = line.range(of: datePattern, options: .regularExpression) {
                let dateString = String(line[range])
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                results.date = formatter.date(from: dateString) ?? Date()
                break
            }
        }

        // Suggest category based on merchant name
        results.suggestedCategory = suggestCategory(merchantName: results.merchantName)
        results.confidence = 0.75

        return results
    }

    /// Suggest expense category based on merchant name
    private func suggestCategory(merchantName: String?) -> String {
        guard let merchant = merchantName?.lowercased() else {
            return ExpenseCategory.other.rawValue
        }

        // Simple keyword-based categorization
        if merchant.contains("restaurant") || merchant.contains("cafe") || merchant.contains("food") {
            return ExpenseCategory.mealsEntertainment.rawValue
        } else if merchant.contains("hotel") || merchant.contains("airline") || merchant.contains("uber") {
            return ExpenseCategory.travel.rawValue
        } else if merchant.contains("gas") || merchant.contains("fuel") {
            return ExpenseCategory.autoMileage.rawValue
        } else if merchant.contains("office") || merchant.contains("staples") {
            return ExpenseCategory.officeSupplies.rawValue
        } else if merchant.contains("amazon") || merchant.contains("depot") {
            return ExpenseCategory.equipmentSupplies.rawValue
        }

        return ExpenseCategory.other.rawValue
    }

    /// Load all receipts for a company
    func loadReceipts(companyId: UUID) async throws {
        let fetchedReceipts: [Receipt] = try await supabase.client
            .from("receipts")
            .select()
            .eq("company_id", value: companyId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value

        self.receipts = fetchedReceipts
    }

    /// Update a receipt
    func updateReceipt(_ receipt: Receipt) async throws {
        try await supabase.client
            .from("receipts")
            .update(receipt)
            .eq("id", value: receipt.id.uuidString)
            .execute()

        if let index = receipts.firstIndex(where: { $0.id == receipt.id }) {
            receipts[index] = receipt
        }
    }

    /// Delete a receipt
    func deleteReceipt(id: UUID) async throws {
        try await supabase.client
            .from("receipts")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()

        receipts.removeAll { $0.id == id }
    }
}
