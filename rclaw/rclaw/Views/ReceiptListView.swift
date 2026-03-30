//
//  ReceiptListView.swift
//  rclaw
//
//  View showing all receipts with filtering and export options
//

import SwiftUI

struct ReceiptListView: View {
    @ObservedObject var receiptService: ReceiptService
    @State private var selectedCategory = "All"
    @State private var searchText = ""

    private let categories = ["All"] + ExpenseCategory.allCases.map { $0.rawValue }

    var filteredReceipts: [Receipt] {
        var filtered = receiptService.receipts

        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }

        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.merchantName?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }

        return filtered
    }

    var body: some View {
        VStack(spacing: 0) {
            // Category filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        CategoryChip(
                            title: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding()
            }

            Divider()

            // Receipt list
            if filteredReceipts.isEmpty {
                ContentUnavailableView(
                    "No Receipts",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("Upload a receipt from the chat to get started")
                )
            } else {
                List {
                    ForEach(filteredReceipts) { receipt in
                        ReceiptRow(receipt: receipt)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("All Receipts")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search receipts")
    }
}

struct ReceiptRow: View {
    let receipt: Receipt

    var body: some View {
        HStack(spacing: 12) {
            // Placeholder for image thumbnail
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(receipt.merchantName ?? "Unknown Merchant")
                    .font(.headline)

                if let date = receipt.receiptDate {
                    Text(formatDate(date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if let category = receipt.category {
                    Text(category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                }
            }

            Spacer()

            if let amount = receipt.amount {
                Text("$\\(amount)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 4)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    NavigationStack {
        ReceiptListView(receiptService: ReceiptService())
    }
}
