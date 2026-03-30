//
//  CompanyOnboardingView.swift
//  rclaw
//
//  Initial company setup for new admins
//

import SwiftUI

struct CompanyOnboardingView: View {
    @ObservedObject var authService: AuthService
    @ObservedObject var companyService: CompanyService
    @State private var companyName = ""
    @State private var companyAddress = ""
    @State private var taxId = ""
    @State private var isCreating = false
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text("Set Up Your Company")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("This information is needed for CPA tax filing")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)

                // Form
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Company Name")
                            .font(.headline)
                        TextField("Acme Inc.", text: $companyName)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.words)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Business Address")
                            .font(.headline)
                        TextField("123 Main St, City, State ZIP", text: $companyAddress)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.words)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tax ID (EIN)")
                            .font(.headline)
                        TextField("12-3456789", text: $taxId)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Create button
                Button(action: createCompany) {
                    if isCreating {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Text("Create Company")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFormValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(!isFormValid || isCreating)
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .navigationTitle("Company Setup")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private var isFormValid: Bool {
        !companyName.isEmpty &&
        !companyAddress.isEmpty &&
        !taxId.isEmpty
    }

    private func createCompany() {
        guard let userId = authService.currentUser?.id else { return }

        isCreating = true

        Task {
            do {
                let _ = try await companyService.createCompany(
                    name: companyName,
                    address: companyAddress,
                    taxId: taxId,
                    adminUserId: userId
                )
                isCreating = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
                isCreating = false
            }
        }
    }
}

#Preview {
    CompanyOnboardingView(
        authService: AuthService(),
        companyService: CompanyService()
    )
}
