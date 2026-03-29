import SwiftUI

struct PhotoProcessingView: View {
    @State private var selectedCategory = "All"

    // IRS business expense categories for tax purposes
    let categories = [
        "All",
        "Meals & Entertainment",
        "Travel",
        "Auto & Mileage",
        "Office Supplies",
        "Office Expenses",
        "Utilities",
        "Rent & Lease",
        "Marketing & Advertising",
        "Professional Services",
        "Insurance",
        "Repairs & Maintenance",
        "Taxes & Licenses",
        "Equipment & Supplies",
        "Other"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        CategoryChip(
                            title: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
            }
            .background(Color(.systemBackground))

            Divider()

            // Empty State / Placeholder
            VStack(spacing: 25) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 150, height: 150)

                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                }

                // Title and Description
                VStack(spacing: 15) {
                    Text("Receipt Processing")
                        .font(.system(size: 28, weight: .bold))

                    Text("Your receipts will appear here once captured and processed")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                // Placeholder Notice
                VStack(spacing: 8) {
                    Text("AI Processing Module - To Be Implemented")
                        .font(.callout)
                        .foregroundColor(.orange)
                        .padding(.top, 20)

                    Text("This module will use AI to extract text from receipts, identify items, calculate totals, and automatically categorize transactions based on IRS business expense categories")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                // Features List
                VStack(alignment: .leading, spacing: 15) {
                    FeatureItem(icon: "text.viewfinder", text: "Text extraction from photos")
                    FeatureItem(icon: "tag.fill", text: "IRS-compliant categorization")
                    FeatureItem(icon: "dollarsign.circle.fill", text: "Total amount detection")
                    FeatureItem(icon: "calendar", text: "Date and time tracking")
                    FeatureItem(icon: "chart.bar.doc.horizontal", text: "CPA-ready tax reports")
                }
                .padding(.horizontal, 40)
                .padding(.top, 30)

                Spacer()
            }
        }
        .navigationTitle("Receipts")
        .navigationBarTitleDisplayMode(.inline)
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
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .cornerRadius(20)
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 24)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        PhotoProcessingView()
    }
}
