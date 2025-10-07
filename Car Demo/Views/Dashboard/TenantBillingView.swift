//
//  TenantBillingView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct TenantBillingView: View {
    @State private var currentTenant = MockData.tenants.first!
    @State private var showingPaymentMethod = false
    @State private var showingBillingHistory = false
    
    private let mockBillingHistory = [
        BillingRecord(
            id: UUID(),
            date: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(),
            amount: 692.0,
            status: .paid,
            description: "Monthly subscription - 8 seats"
        ),
        BillingRecord(
            id: UUID(),
            date: Calendar.current.date(byAdding: .month, value: -2, to: Date()) ?? Date(),
            amount: 692.0,
            status: .paid,
            description: "Monthly subscription - 8 seats"
        ),
        BillingRecord(
            id: UUID(),
            date: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
            amount: 643.0,
            status: .paid,
            description: "Monthly subscription - 7 seats"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Current Plan Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Current Plan")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(currentTenant.accountType.displayName)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                Text("$\(String(format: "%.0f", currentTenant.monthlyRevenue)) per month")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.success)
                                
                                Text("\(currentTenant.activeSeats) active seats")
                                    .font(.system(size: 16))
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Spacer()
                            
                            if currentTenant.accountType == .trial {
                                VStack(spacing: 8) {
                                    Text("TRIAL")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.warning)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.warning.opacity(0.1))
                                        .cornerRadius(6)
                                    
                                    Text("14 days left")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.textSecondary)
                                }
                            } else {
                                VStack(spacing: 8) {
                                    Text("ACTIVE")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.success)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.success.opacity(0.1))
                                        .cornerRadius(6)
                                    
                                    if let lastPayment = currentTenant.lastPaymentDate {
                                        Text("Next billing: \(DateFormatter.shortDate.string(from: Calendar.current.date(byAdding: .month, value: 1, to: lastPayment) ?? Date()))")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.textSecondary)
                                    }
                                }
                            }
                        }
                        
                        if currentTenant.missedPayment {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.error)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Payment Failed")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.error)
                                    
                                    Text("Your last payment failed. Please update your payment method.")
                                        .font(.system(size: 12))
                                        .foregroundColor(.textSecondary)
                                }
                                
                                Spacer()
                                
                                Button("Update Payment") {
                                    showingPaymentMethod = true
                                }
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.error)
                                .cornerRadius(6)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.error.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        // Action Buttons
                        HStack(spacing: 12) {
                            if currentTenant.accountType == .trial {
                                CustomButton(
                                    title: "Upgrade Plan",
                                    action: {
                                        // Handle upgrade
                                    },
                                    style: .primary,
                                    size: .medium
                                )
                            } else {
                                CustomButton(
                                    title: "Buy More Seats",
                                    action: {
                                        // Handle buy seats
                                    },
                                    style: .primary,
                                    size: .medium
                                )
                            }
                            
                            CustomButton(
                                title: "Manage Plan",
                                action: {
                                    // Handle manage plan
                                },
                                style: .secondary,
                                size: .medium
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Payment Method Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Payment Method")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.carPrimary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("•••• •••• •••• 4242")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.textPrimary)
                                
                                Text("Expires 12/25")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Spacer()
                            
                            Button("Update") {
                                showingPaymentMethod = true
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.carPrimary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.carPrimary.opacity(0.1))
                            .cornerRadius(6)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Usage & Billing Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Usage & Billing")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button("View All") {
                            showingBillingHistory = true
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.carPrimary)
                    }
                    
                    VStack(spacing: 12) {
                        // Current Month Usage
                        VStack(spacing: 12) {
                            HStack {
                                Text("Current Month")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Text("$\(String(format: "%.0f", currentTenant.monthlyRevenue))")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.success)
                            }
                            
                            HStack {
                                Text("Active Seats")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Text("\(currentTenant.activeSeats)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            HStack {
                                Text("Base Plan")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Text("$299.00")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            HStack {
                                Text("Additional Seats")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Text("$\(String(format: "%.0f", currentTenant.monthlyRevenue - 299.0))")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                        
                        // Recent Billing History
                        VStack(spacing: 8) {
                            ForEach(mockBillingHistory.prefix(3)) { record in
                                BillingRecordRow(record: record)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Download Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Downloads")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 12) {
                        DownloadRow(
                            icon: "doc.text.fill",
                            title: "Download Invoice",
                            subtitle: "Get your latest invoice",
                            action: { /* Handle download */ }
                        )
                        
                        DownloadRow(
                            icon: "chart.bar.fill",
                            title: "Usage Report",
                            subtitle: "Download detailed usage report",
                            action: { /* Handle download */ }
                        )
                        
                        DownloadRow(
                            icon: "folder.fill",
                            title: "Tax Documents",
                            subtitle: "Access tax-related documents",
                            action: { /* Handle download */ }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color.backgroundPrimary)
        .sheet(isPresented: $showingPaymentMethod) {
            UpdatePaymentMethodView()
        }
        .sheet(isPresented: $showingBillingHistory) {
            BillingHistoryView(billingHistory: mockBillingHistory)
        }
    }
}

// MARK: - Billing Record Row
struct BillingRecordRow: View {
    let record: BillingRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(DateFormatter.mediumDate.string(from: record.date))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Text(record.description)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("$\(String(format: "%.0f", record.amount))")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text(record.status.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(record.status == .paid ? .success : .error)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background((record.status == .paid ? Color.success : Color.error).opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

// MARK: - Download Row
struct DownloadRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.carPrimary)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.carPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.backgroundSecondary)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Update Payment Method View
struct UpdatePaymentMethodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Update Payment Method")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Enter your new payment information")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Cardholder Name",
                            placeholder: "John Doe",
                            text: $cardholderName
                        )
                        
                        CustomTextField(
                            title: "Card Number",
                            placeholder: "1234 5678 9012 3456",
                            text: $cardNumber,
                            keyboardType: .numberPad
                        )
                        
                        HStack(spacing: 12) {
                            CustomTextField(
                                title: "Expiry Date",
                                placeholder: "MM/YY",
                                text: $expiryDate,
                                keyboardType: .numberPad
                            )
                            
                            CustomTextField(
                                title: "CVV",
                                placeholder: "123",
                                text: $cvv,
                                keyboardType: .numberPad
                            )
                        }
                    }
                    
                    CustomButton(
                        title: "Update Payment Method",
                        action: {
                            // Mock update
                            dismiss()
                        },
                        style: .primary,
                        size: .large,
                        isDisabled: cardNumber.isEmpty || expiryDate.isEmpty || cvv.isEmpty || cardholderName.isEmpty
                    )
                    .padding(.top, 20)
                }
                .padding(.horizontal, 24)
            }
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

// MARK: - Billing History View
struct BillingHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    let billingHistory: [BillingRecord]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(billingHistory) { record in
                        BillingRecordRow(record: record)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Billing History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.carPrimary)
                }
            }
        }
    }
}

// MARK: - Billing Record Model
struct BillingRecord: Identifiable {
    let id: UUID
    let date: Date
    let amount: Double
    let status: BillingStatus
    let description: String
}

enum BillingStatus {
    case paid
    case failed
    case pending
    
    var displayName: String {
        switch self {
        case .paid: return "Paid"
        case .failed: return "Failed"
        case .pending: return "Pending"
        }
    }
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
}

#Preview {
    TenantBillingView()
}
