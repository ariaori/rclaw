//
//  ChatBubble.swift
//  rclaw
//
//  Individual chat message bubble component
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }

            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                // Message header
                Text(message.messageType.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)

                // Message content
                Text(message.content)
                    .padding(12)
                    .background(bubbleColor)
                    .foregroundColor(textColor)
                    .cornerRadius(16)

                // Show image thumbnail if available
                if let imageUrl = message.metadata.imageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 150)
                    }
                }

                // Timestamp
                Text(formatTime(message.createdAt))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            if !message.isFromUser {
                Spacer()
            }
        }
    }

    private var bubbleColor: Color {
        switch message.messageType {
        case .user:
            return .blue
        case .agent:
            return Color.gray.opacity(0.2)
        case .system:
            return Color.yellow.opacity(0.2)
        }
    }

    private var textColor: Color {
        message.messageType == .user ? .white : .primary
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    VStack {
        ChatBubble(message: ChatMessage(
            id: UUID(),
            userId: UUID(),
            companyId: UUID(),
            receiptId: nil,
            messageType: .user,
            content: "I just uploaded a receipt",
            metadata: MessageMetadata(),
            createdAt: Date()
        ))

        ChatBubble(message: ChatMessage(
            id: UUID(),
            userId: UUID(),
            companyId: UUID(),
            receiptId: nil,
            messageType: .agent,
            content: "Great! I've processed your receipt. Here's what I found:\\n\\n🏪 Merchant: Starbucks\\n💰 Amount: $15.50\\n📂 Category: Meals & Entertainment",
            metadata: MessageMetadata(),
            createdAt: Date()
        ))
    }
    .padding()
}
