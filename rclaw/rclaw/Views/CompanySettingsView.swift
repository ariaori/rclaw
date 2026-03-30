//
//  CompanySettingsView.swift
//  rclaw
//
//  Admin view for managing company information and members
//

import SwiftUI

struct CompanySettingsView: View {
    @ObservedObject var companyService: CompanyService
    @State private var companyName = ""
    @State private var companyAddress = ""
    @State private var taxId = ""
    @State private var isSaving = false
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        Form {
            Section("Company Information") {
                TextField("Company Name", text: $companyName)
                TextField("Address", text: $companyAddress, axis: .vertical)
                    .lineLimit(3)
                TextField("Tax ID (EIN)", text: $taxId)
                    .keyboardType(.numberPad)
            }

            Section("Members") {
                if companyService.companyMembers.isEmpty {
                    Text("No members yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(companyService.companyMembers) { member in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(member.fullName)
                                    .font(.headline)
                                Text(member.role.displayName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }

                Button("Add Member") {
                    // TODO: Implement member invitation
                }
            }

            Section {
                Button(action: saveCompany) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Save Changes")
                    }
                }
                .disabled(isSaving || !hasChanges)
            }
        }
        .navigationTitle("Company Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadCompanyData)
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    private var hasChanges: Bool {
        guard let company = companyService.currentCompany else { return false }
        return companyName != company.name ||
               companyAddress != company.address ||
               taxId != company.taxId
    }

    private func loadCompanyData() {
        guard let company = companyService.currentCompany else { return }
        companyName = company.name
        companyAddress = company.address
        taxId = company.taxId
    }

    private func saveCompany() {
        guard var company = companyService.currentCompany else { return }

        isSaving = true

        company.name = companyName
        company.address = companyAddress
        company.taxId = taxId

        Task {
            do {
                try await companyService.updateCompany(company)
                isSaving = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
                isSaving = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        CompanySettingsView(companyService: CompanyService())
    }
}
