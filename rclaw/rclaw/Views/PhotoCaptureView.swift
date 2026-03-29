import SwiftUI

struct PhotoCaptureView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingCamera = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Camera Icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 200, height: 200)

                Image(systemName: "camera.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
            }

            // Title and Description
            VStack(spacing: 15) {
                Text("Capture Receipt")
                    .font(.system(size: 28, weight: .bold))

                Text("Take a photo of your receipt to automatically extract and categorize the information")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            // Placeholder Notice
            VStack(spacing: 8) {
                Text("Camera Module - To Be Implemented")
                    .font(.callout)
                    .foregroundColor(.orange)
                    .padding(.top, 20)

                Text("This feature will integrate with the device camera to capture receipt photos")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()

            // Action Buttons
            VStack(spacing: 15) {
                Button(action: {
                    // Placeholder: Camera functionality not implemented
                    showingCamera = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.system(size: 20))

                        Text("Open Camera")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .disabled(true)
                .opacity(0.6)

                Button(action: {
                    // Placeholder: Photo library functionality not implemented
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 20))

                        Text("Choose from Library")
                            .font(.headline)
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                .disabled(true)
                .opacity(0.6)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
        .navigationTitle("Capture Receipt")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Coming Soon", isPresented: $showingCamera) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Camera integration will be implemented in a future version.")
        }
    }
}

#Preview {
    NavigationStack {
        PhotoCaptureView()
    }
}
