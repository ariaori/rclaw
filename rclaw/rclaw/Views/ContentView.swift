import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                HomeView(isLoggedIn: $isLoggedIn)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

struct HomeView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 30) {
            Text("Receipt Claw")
                .font(.system(size: 34, weight: .bold))
                .padding(.top, 40)

            Text("Capture and categorize your receipts")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()

            VStack(spacing: 20) {
                NavigationLink(destination: PhotoCaptureView()) {
                    FeatureButton(
                        icon: "camera.fill",
                        title: "Capture Receipt",
                        subtitle: "Take a photo of your receipt",
                        color: .blue
                    )
                }

                NavigationLink(destination: PhotoProcessingView()) {
                    FeatureButton(
                        icon: "doc.text.magnifyingglass",
                        title: "View Receipts",
                        subtitle: "Browse and manage your receipts",
                        color: .green
                    )
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            Button(action: {
                isLoggedIn = false
            }) {
                Text("Logout")
                    .foregroundColor(.red)
                    .padding()
            }
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
    }
}

struct FeatureButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
                .background(color)
                .cornerRadius(15)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

#Preview {
    ContentView()
}
