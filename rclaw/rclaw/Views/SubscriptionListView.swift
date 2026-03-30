//
//  SubscriptionListView.swift
//  rclaw
//
//  View for managing recurring subscription expenses
//

import SwiftUI

struct SubscriptionListView: View {
    @State private var subscriptions: [Subscription] = []
    @State private var showingAddSubscription = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())

    var yearlyTotal: Decimal {
        subscriptions
            .filter { $0.isActive }
            .reduce(0) { $0 + $1.yearlyAmount }
    }

    var body: some View {
        List {
            // Summary section
            Section {
                VStack(spacing: 12) {
                    HStack {
                        Text("Annual Subscription Cost")
                            .font(.headline)
                        Spacer()
                        Text("$\\(yearlyTotal)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }

                    Picker("Year", selection: $selectedYear) {
                        ForEach(Array(2020...2030), id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 8)
            }

            // Subscriptions list
            Section("Active Subscriptions") {
                if subscriptions.filter({ $0.isActive }).isEmpty {
                    Text("No active subscriptions")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(subscriptions.filter { $0.isActive }) { subscription in
                        SubscriptionRow(subscription: subscription)
                    }
                }
            }

            // Inactive subscriptions
            if !subscriptions.filter({ !$0.isActive }).isEmpty {
                Section("Inactive Subscriptions") {
                    ForEach(subscriptions.filter { !$0.isActive }) { subscription in
                        SubscriptionRow(subscription: subscription)
                    }
                }
            }
        }
        .navigationTitle("Subscriptions")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddSubscription = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSubscription) {
            AddSubscriptionView()
        }
    }
}

struct SubscriptionRow: View {
    let subscription: Subscription

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(subscription.name)
                    .font(.headline)

                Spacer()

                Text("$\\(subscription.amount)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            HStack {
                Text(subscription.frequency.displayName)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(4)

                Text(subscription.category)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text("$\\(subscription.yearlyAmount)/year")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("Next: \\(formatDate(subscription.nextBillingDate))")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
        .opacity(subscription.isActive ? 1.0 : 0.5)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct AddSubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var amount = ""
    @State private var frequency = SubscriptionFrequency.monthly
    @State private var startDate = Date()
    @State private var category = ExpenseCategory.officeExpenses.rawValue

    var body: some View {
        NavigationStack {
            Form {
                Section("Subscription Details") {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Picker("Frequency", selection: $frequency) {
                        ForEach(SubscriptionFrequency.allCases, id: \.self) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }

                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                }

                Section("Category") {
                    Picker("Expense Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat.rawValue)
                        }
                    }
                }

                if let amountDecimal = Decimal(string: amount) {
                    Section("Yearly Estimate") {
                        let yearly = amountDecimal * frequencyMultiplier(frequency)
                        Text("$\\(yearly) per year")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // TODO: Implement save
                        dismiss()
                    }
                    .disabled(name.isEmpty || amount.isEmpty)
                }
            }
        }
    }

    private func frequencyMultiplier(_ freq: SubscriptionFrequency) -> Decimal {
        switch freq {
        case .weekly: return 52
        case .monthly: return 12
        case .quarterly: return 4
        case .yearly: return 1
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionListView()
    }
}
