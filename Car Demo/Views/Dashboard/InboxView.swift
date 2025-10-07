//
//  InboxView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct InboxView: View {
    @State private var searchText = ""
    @State private var selectedFilter: EmailFilter = .all
    @State private var selectedMessage: EmailMessage?
    @State private var showingCompose = false
    
    private let mockMessages = MockData.emailMessages
    
    private var filteredMessages: [EmailMessage] {
        let filtered = mockMessages.filter { message in
            if !searchText.isEmpty {
                return message.subject.localizedCaseInsensitiveContains(searchText) ||
                       message.from.localizedCaseInsensitiveContains(searchText) ||
                       message.body.localizedCaseInsensitiveContains(searchText)
            }
            
            switch selectedFilter {
            case .all:
                return true
            case .unread:
                return !message.isRead
            case .important:
                return message.isImportant
            }
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Inbox")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("\(filteredMessages.count) messages")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: { showingCompose = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text("Compose")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.carPrimary)
                        .cornerRadius(10)
                    }
                }
                
                // Search and Filter
                VStack(spacing: 12) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)
                            .font(.system(size: 16, weight: .medium))
                        
                        TextField("Search messages...", text: $searchText)
                            .font(.system(size: 16))
                            .foregroundColor(.textPrimary)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.textSecondary)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(12)
                    
                    // Filter Tabs
                    HStack(spacing: 0) {
                        ForEach(EmailFilter.allCases, id: \.self) { filter in
                            Button(action: {
                                selectedFilter = filter
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: filter.icon)
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Text(filter.displayName)
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    if filter == .unread {
                                        let unreadCount = mockMessages.filter { !$0.isRead }.count
                                        if unreadCount > 0 {
                                            Text("\(unreadCount)")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.error)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .foregroundColor(selectedFilter == filter ? .carPrimary : .textSecondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    selectedFilter == filter ?
                                    Color.carPrimary.opacity(0.1) :
                                    Color.clear
                                )
                                .cornerRadius(8)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.backgroundPrimary)
            
            // Messages List
            ScrollView {
                LazyVStack(spacing: 1) {
                    ForEach(filteredMessages) { message in
                        EmailMessageRow(
                            message: message,
                            isSelected: selectedMessage?.id == message.id,
                            onTap: { selectedMessage = message }
                        )
                    }
                }
            }
            .background(Color.backgroundPrimary)
        }
        .sheet(item: $selectedMessage) { message in
            EmailDetailView(message: message)
        }
        .sheet(isPresented: $showingCompose) {
            ComposeEmailView()
        }
    }
}

// MARK: - Email Message Row
struct EmailMessageRow: View {
    let message: EmailMessage
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Sender Avatar
                Circle()
                    .fill(Color.carPrimary.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(message.from.prefix(1).uppercased())
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.carPrimary)
                    )
                
                // Message Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(message.from)
                            .font(.system(size: 16, weight: message.isRead ? .medium : .semibold))
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            if message.isImportant {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.warning)
                            }
                            
                            if !message.attachments.isEmpty {
                                Image(systemName: "paperclip")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Text(formatDate(message.date))
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Text(message.subject)
                        .font(.system(size: 15, weight: message.isRead ? .medium : .semibold))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Text(message.body)
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                }
                
                // Unread Indicator
                if !message.isRead {
                    Circle()
                        .fill(Color.carPrimary)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(isSelected ? Color.carPrimary.opacity(0.05) : Color.white)
            .onTapGesture {
                onTap()
            }
            
            Rectangle()
                .fill(Color.gray200)
                .frame(height: 1)
                .padding(.leading, 72)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "MMM d"
        }
        
        return formatter.string(from: date)
    }
}

// MARK: - Email Detail View
struct EmailDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let message: EmailMessage
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(message.subject)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("From: \(message.from)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.textPrimary)
                                
                                Text("To: \(message.to)")
                                    .font(.system(size: 16))
                                    .foregroundColor(.textSecondary)
                                
                                Text(DateFormatter.fullDateTime.string(from: message.date))
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Spacer()
                            
                            if message.isImportant {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.warning)
                            }
                        }
                    }
                    
                    // Attachments
                    if !message.attachments.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Attachments")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            ForEach(message.attachments, id: \.self) { attachment in
                                HStack {
                                    Image(systemName: "paperclip")
                                        .foregroundColor(.carPrimary)
                                    
                                    Text(attachment)
                                        .font(.system(size: 14))
                                        .foregroundColor(.carPrimary)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.carPrimary.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Body
                    Text(message.body)
                        .font(.system(size: 16))
                        .foregroundColor(.textPrimary)
                        .lineSpacing(4)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.carPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reply") {
                        // Handle reply
                        dismiss()
                    }
                    .foregroundColor(.carPrimary)
                }
            }
        }
    }
}

// MARK: - Compose Email View
struct ComposeEmailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var to = ""
    @State private var subject = ""
    @State private var messageBody = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    CustomTextField(
                        title: "To",
                        placeholder: "recipient@example.com",
                        text: $to,
                        keyboardType: .emailAddress,
                        autocapitalization: .never
                    )
                    
                    CustomTextField(
                        title: "Subject",
                        placeholder: "Email subject",
                        text: $subject
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Message")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        TextEditor(text: $messageBody)
                            .font(.system(size: 16))
                            .foregroundColor(.textPrimary)
                            .frame(minHeight: 200)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                Spacer()
                
                CustomButton(
                    title: "Send Email",
                    action: {
                        // Mock send
                        dismiss()
                    },
                    style: .primary,
                    size: .large,
                    isDisabled: to.isEmpty || subject.isEmpty || messageBody.isEmpty
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Compose")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.carPrimary)
                }
            }
        }
    }
}

// MARK: - Email Filter Enum
enum EmailFilter: CaseIterable {
    case all
    case unread
    case important
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .unread: return "Unread"
        case .important: return "Important"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "tray.fill"
        case .unread: return "envelope.badge.fill"
        case .important: return "exclamationmark.triangle.fill"
        }
    }
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let fullDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    InboxView()
}
