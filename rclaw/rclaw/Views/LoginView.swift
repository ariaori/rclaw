import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""

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

                Text("Login to manage your receipts")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 40)

            // Login Form (Placeholder)
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disabled(true)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    SecureField("Enter your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(true)
                }

                // Placeholder Notice
                VStack(spacing: 10) {
                    Text("Login Module - To Be Implemented")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.top, 10)

                    Text("Tap 'Demo Login' to continue")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 30)

            // Login Button (Demo)
            Button(action: {
                // Placeholder: Skip authentication for now
                isLoggedIn = true
            }) {
                Text("Demo Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)

            Spacer()

            // Sign Up Link (Placeholder)
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)

                Button(action: {
                    // Placeholder: Sign up not implemented
                }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                }
                .disabled(true)
            }
            .font(.subheadline)
            .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
