//
//  ChatView.swift
//  rclaw
//
//  Main chat interface for receipt management with agent-based interaction
//

import SwiftUI
import PhotosUI

struct ChatView: View {
    @StateObject private var authService: AuthService
    @StateObject private var companyService: CompanyService
    @StateObject private var receiptService: ReceiptService
    @State private var messages: [ChatMessage] = []
    @State private var messageText = ""
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    @State private var isProcessing = false

    init(authService: AuthService, companyService: CompanyService, receiptService: ReceiptService) {
        _authService = StateObject(wrappedValue: authService)
        _companyService = StateObject(wrappedValue: companyService)
        _receiptService = StateObject(wrappedValue: receiptService)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Chat messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // Welcome message
                            if messages.isEmpty {
                                WelcomeView(
                                    companyName: companyService.currentCompany?.name ?? "Your Company"
                                )
                            }

                            ForEach(messages) { message in
                                ChatBubble(message: message)
                                    .id(message.id)
                            }

                            if isProcessing {
                                ProcessingIndicator()
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _, _ in
                        if let lastMessage = messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                Divider()

                // Input area
                InputArea(
                    messageText: $messageText,
                    showingImagePicker: $showingImagePicker,
                    showingCamera: $showingCamera,
                    onSend: sendMessage,
                    isEnabled: !isProcessing
                )
            }
            .navigationTitle("RClaw")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        if authService.isAdmin {
                            NavigationLink("Company Settings") {
                                CompanySettingsView(companyService: companyService)
                            }
                        }

                        NavigationLink("Subscriptions") {
                            SubscriptionListView()
                        }

                        NavigationLink("All Receipts") {
                            ReceiptListView(receiptService: receiptService)
                        }

                        Divider()

                        Button("Sign Out", role: .destructive) {
                            Task {
                                try? await authService.signOut()
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
        }
        .onChange(of: selectedImage) { _, newImage in
            if let image = newImage {
                handleImageUpload(image)
            }
        }
        .task {
            await loadInitialData()
        }
    }

    private func loadInitialData() async {
        guard let userId = authService.currentUser?.id else { return }

        do {
            try await companyService.loadCompany(for: userId)

            if let companyId = companyService.currentCompany?.id {
                try await receiptService.loadReceipts(companyId: companyId)
            }
        } catch {
            print("Error loading initial data: \\(error)")
        }
    }

    private func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let userMessage = ChatMessage(
            id: UUID(),
            userId: authService.currentUser!.id,
            companyId: companyService.currentCompany!.id,
            receiptId: nil,
            messageType: .user,
            content: text,
            metadata: MessageMetadata(),
            createdAt: Date()
        )

        messages.append(userMessage)
        messageText = ""

        // Simulate agent response
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let agentMessage = ChatMessage(
                id: UUID(),
                userId: authService.currentUser!.id,
                companyId: companyService.currentCompany!.id,
                receiptId: nil,
                messageType: .agent,
                content: "I can help you with that. Would you like to upload a receipt or manage your subscriptions?",
                metadata: MessageMetadata(),
                createdAt: Date()
            )
            messages.append(agentMessage)
        }
    }

    private func handleImageUpload(_ image: UIImage) {
        guard let userId = authService.currentUser?.id,
              let companyId = companyService.currentCompany?.id else { return }

        isProcessing = true

        Task {
            do {
                let (receipt, scanResults) = try await receiptService.processReceipt(
                    image: image,
                    userId: userId,
                    companyId: companyId
                )

                // Create user message showing the upload
                let userMessage = ChatMessage(
                    id: UUID(),
                    userId: userId,
                    companyId: companyId,
                    receiptId: receipt.id,
                    messageType: .user,
                    content: "I uploaded a receipt",
                    metadata: MessageMetadata(),
                    createdAt: Date()
                )
                messages.append(userMessage)

                // Create agent response with scan results
                let agentResponse = formatScanResults(scanResults, receipt: receipt)
                let agentMessage = ChatMessage(
                    id: UUID(),
                    userId: userId,
                    companyId: companyId,
                    receiptId: receipt.id,
                    messageType: .agent,
                    content: agentResponse,
                    metadata: MessageMetadata(scanResults: scanResults, corrections: nil, imageUrl: receipt.imageUrl),
                    createdAt: Date()
                )
                messages.append(agentMessage)

                isProcessing = false
                selectedImage = nil
            } catch {
                isProcessing = false
                print("Error processing receipt: \\(error)")
            }
        }
    }

    private func formatScanResults(_ results: ScanResults, receipt: Receipt) -> String {
        var response = "✅ Receipt uploaded successfully!\\n\\n"
        response += "Here's what I found:\\n"

        if let merchant = results.merchantName {
            response += "🏪 Merchant: \\(merchant)\\n"
        }

        if let amount = results.amount {
            response += "💰 Amount: $\\(amount)\\n"
        }

        if let date = results.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            response += "📅 Date: \\(formatter.string(from: date))\\n"
        }

        if let category = results.suggestedCategory {
            response += "📂 Category: \\(category)\\n"
        }

        response += "\\nIf anything looks wrong, just let me know and I'll update it!"

        return response
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    let companyName: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Welcome to RClaw")
                .font(.title)
                .fontWeight(.bold)

            Text(companyName)
                .font(.headline)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(icon: "camera.fill", text: "Upload or take a photo of your receipt")
                FeatureRow(icon: "doc.text.magnifyingglass", text: "AI automatically scans and categorizes")
                FeatureRow(icon: "pencil", text: "Correct any details by chatting")
                FeatureRow(icon: "calendar", text: "Set up recurring subscriptions")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

// MARK: - Input Area
struct InputArea: View {
    @Binding var messageText: String
    @Binding var showingImagePicker: Bool
    @Binding var showingCamera: Bool
    let onSend: () -> Void
    let isEnabled: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Camera/Photo buttons
            Menu {
                Button(action: { showingCamera = true }) {
                    Label("Take Photo", systemImage: "camera")
                }
                Button(action: { showingImagePicker = true }) {
                    Label("Choose Photo", systemImage: "photo")
                }
            } label: {
                Image(systemName: "paperclip.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .disabled(!isEnabled)

            // Text input
            TextField("Type a message...", text: $messageText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...5)
                .disabled(!isEnabled)

            // Send button
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(messageText.isEmpty ? .gray : .blue)
            }
            .disabled(messageText.isEmpty || !isEnabled)
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
    }
}

// MARK: - Processing Indicator
struct ProcessingIndicator: View {
    var body: some View {
        HStack {
            ProgressView()
            Text("Processing receipt...")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// Preview disabled due to @MainActor requirements
// #Preview {
//     let authService = AuthService()
//     let companyService = CompanyService()
//     let receiptService = ReceiptService()
//
//     ChatView(
//         authService: authService,
//         companyService: companyService,
//         receiptService: receiptService
//     )
// }
