//
//  ContentView.swift
//  rclaw
//
//  Main app view handling authentication and navigation flow
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authService = AuthService()
    @StateObject private var companyService = CompanyService()
    @StateObject private var receiptService = ReceiptService()

    var body: some View {
        Group {
            if authService.isAuthenticated {
                // User is logged in
                if companyService.currentCompany == nil {
                    // Admin needs to create company
                    CompanyOnboardingView(
                        authService: authService,
                        companyService: companyService
                    )
                } else {
                    // Show main chat interface
                    ChatView(
                        authService: authService,
                        companyService: companyService,
                        receiptService: receiptService
                    )
                }
            } else {
                // Show login/signup
                LoginView(authService: authService)
            }
        }
    }
}

#Preview {
    ContentView()
}
