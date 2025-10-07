//
//  TenantSelectorView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct TenantSelectorView: View {
    @EnvironmentObject var userSession: UserSession
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedTenant: Tenant?
    
    private var filteredTenants: [Tenant] {
        if searchText.isEmpty {
            return MockData.tenants
        } else {
            return MockData.tenants.filter { tenant in
                tenant.practiceName.localizedCaseInsensitiveContains(searchText) ||
                tenant.mainUser.fullName.localizedCaseInsensitiveContains(searchText) ||
                tenant.mainUser.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Select Tenant")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Choose a tenant to view their dashboard")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)
                            .font(.system(size: 16, weight: .medium))
                        
                        TextField("Search tenants...", text: $searchText)
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
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(Color.backgroundPrimary)
                
                // Tenants List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTenants) { tenant in
                            TenantSelectorRowView(
                                tenant: tenant,
                                isSelected: selectedTenant?.id == tenant.id
                            )
                            .onTapGesture {
                                selectedTenant = tenant
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }
                .background(Color.backgroundPrimary)
                
                // Action Buttons
                VStack(spacing: 12) {
                    CustomButton(
                        title: "View Tenant Dashboard",
                        action: {
                            if let tenant = selectedTenant {
                                if userSession.switchToTenantView(tenant: tenant) {
                                    dismiss()
                                }
                            }
                        },
                        style: .primary,
                        size: .large,
                        isDisabled: selectedTenant == nil
                    )
                    
                    CustomButton(
                        title: "Cancel",
                        action: {
                            dismiss()
                        },
                        style: .secondary,
                        size: .large
                    )
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(Color.white)
                .overlay(
                    Rectangle()
                        .fill(Color.gray200)
                        .frame(height: 1),
                    alignment: .top
                )
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Tenant Selector Row View
struct TenantSelectorRowView: View {
    let tenant: Tenant
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Selection Indicator
            ZStack {
                Circle()
                    .stroke(isSelected ? Color.carPrimary : Color.gray300, lineWidth: 2)
                    .frame(width: 20, height: 20)
                
                if isSelected {
                    Circle()
                        .fill(Color.carPrimary)
                        .frame(width: 12, height: 12)
                }
            }
            
            // Tenant Logo/Avatar
            AsyncImage(url: URL(string: tenant.logoUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.carPrimary.opacity(0.1))
                    .overlay(
                        Text(tenant.practiceName.prefix(1).uppercased())
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.carPrimary)
                    )
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            
            // Tenant Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(tenant.practiceName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    // Account Type Badge
                    Text(tenant.accountType.displayName)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(tenant.accountType == .trial ? Color.warning : Color.carPrimary)
                        .cornerRadius(6)
                }
                
                Text(tenant.mainUser.fullName)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                
                HStack {
                    Text(tenant.specialty)
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                    
                    Text("•")
                        .foregroundColor(.textSecondary)
                    
                    Text("\(tenant.activeSeats) seats")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    // Payment Status
                    if tenant.missedPayment {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.error)
                            
                            Text("Payment Issue")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.error)
                        }
                    } else {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.success)
                                .frame(width: 6, height: 6)
                            
                            Text("Active")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.success)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.carPrimary : Color.clear, lineWidth: 2)
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    TenantSelectorView()
        .environmentObject(UserSession.shared)
}
