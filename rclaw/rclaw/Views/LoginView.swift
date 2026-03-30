//
//  LoginView.swift
//  rclaw
//
//  User authentication view with sign in and sign up capabilities
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var isSignUp = false
    @State private var isLoading = false
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // App Logo/Title
            VStack(spacing: 10) {
                Image(systemName: "receipt.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Text("Receipt Claw")
                    .font(.system(size: 34, weight: .bold))

                Text(isSignUp ? "Create your account" : "Welcome back")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 40)

            // Auth Form
            VStack(spacing: 20) {
                if isSignUp {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        TextField("John Doe", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .disabled(isLoading)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    TextField("you@example.com", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disabled(isLoading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    SecureField("Enter your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(isLoading)
                }
            }
            .padding(.horizontal, 30)

            // Auth Button
            Button(action: handleAuth) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text(isSignUp ? "Create Account" : "Sign In")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isFormValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!isFormValid || isLoading)
            .padding(.horizontal, 30)
            .padding(.top, 20)

            Spacer()

            // Toggle Sign Up/Sign In
            HStack {
                Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                    .foregroundColor(.gray)

                Button(action: {
                    withAnimation {
                        isSignUp.toggle()
                    }
                }) {
                    Text(isSignUp ? "Sign In" : "Sign Up")
                        .foregroundColor(.blue)
                }
            }
            .font(.subheadline)
            .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    private var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        password.count >= 6 &&
        (!isSignUp || !fullName.isEmpty)
    }

    private func handleAuth() {
        isLoading = true

        Task {
            do {
                if isSignUp {
                    try await authService.signUp(
                        email: email,
                        password: password,
                        fullName: fullName,
                        role: .admin // First user is admin
                    )
                } else {
                    try await authService.signIn(
                        email: email,
                        password: password
                    )
                }
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
                isLoading = false
            }
        }
    }
}

#Preview {
    LoginView(authService: AuthService())
}
