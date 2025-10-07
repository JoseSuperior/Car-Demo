//
//  TenantAdminDashboardView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct TenantAdminDashboardView: View {
    @State private var selectedTab = 0
    @State private var showingLogoutAlert = false
    @State private var switchingToSuperAdmin = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                TenantAdminHeaderView(
                    onLogout: {
                        showingLogoutAlert = true
                    },
                    onSwitchToSuperAdmin: {
                        switchingToSuperAdmin = true
                    }
                )
                
                // Tab Content
                TabView(selection: $selectedTab) {
                    TenantUsersView()
                        .tag(0)
                    
                    TenantSettingsView()
                        .tag(1)
                    
                    TenantBillingView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom Tab Bar
                TenantAdminTabBar(selectedTab: $selectedTab)
            }
            .navigationBarHidden(true)
            .background(Color.backgroundPrimary)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $switchingToSuperAdmin) {
            SuperAdminDashboardView()
        }
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                handleLogout()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
    
    private func handleLogout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "isSuperAdmin")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        NotificationCenter.default.post(name: .init("LoginStateChanged"), object: nil)
    }
}

// MARK: - Tenant Admin Header
struct TenantAdminHeaderView: View {
    let onLogout: () -> Void
    let onSwitchToSuperAdmin: () -> Void
    @State private var currentTenant = MockData.tenants.first!
    @State private var showingProfileMenu = false
    @State private var isSuperAdmin = UserDefaults.standard.bool(forKey: "isSuperAdmin")
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Header - Completely Redesigned
            HStack(alignment: .center, spacing: 16) {
                // Practice Logo and Info
                HStack(spacing: 12) {
                    // Logo
                    AsyncImage(url: URL(string: currentTenant.logoUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.carPrimary)
                            .overlay(
                                Text(currentTenant.practiceName.prefix(1).uppercased())
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(currentTenant.practiceName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "building.2")
                                .font(.system(size: 9, weight: .medium))
                            
                            Text("Tenant Dashboard")
                                .font(.system(size: 11, weight: .regular))
                        }
                        .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // Right Side Actions - Completely Simplified
                HStack(spacing: 10) {
                    // Primary Action Button
                    Button(action: {
                        // Handle primary action
                    }) {
                        Image(systemName: primaryActionIcon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.carPrimary)
                            .clipShape(Circle())
                    }
                    
                    // Profile Menu Button
                    Menu {
                        // User Info Section
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentTenant.mainUser.fullName)
                                .font(.system(size: 14, weight: .semibold))
                            Text(currentTenant.mainUser.email)
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.vertical, 8)
                        
                        Divider()
                        
                        // Account Type
                        Button {
                            // View account details
                        } label: {
                            HStack {
                                Label(currentTenant.accountType.displayName + " Plan", systemImage: "star.fill")
                                Spacer()
                                Circle()
                                    .fill(accountTypeColor)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        
                        Divider()
                        
                        // Switch to Super Admin (only if user has permissions)
                        if isSuperAdmin {
                            Button {
                                onSwitchToSuperAdmin()
                            } label: {
                                Label("Switch to Super Admin", systemImage: "crown.fill")
                            }
                            
                            Divider()
                        }
                        
                        // Settings
                        Button {
                            // Navigate to settings
                        } label: {
                            Label("Account Settings", systemImage: "gearshape")
                        }
                        
                        // Help & Support
                        Button {
                            // Handle help
                        } label: {
                            Label("Help & Support", systemImage: "questionmark.circle")
                        }
                        
                        Divider()
                        
                        // Sign Out
                        Button(role: .destructive) {
                            onLogout()
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        HStack(spacing: 6) {
                            // Avatar
                            AsyncImage(url: URL(string: currentTenant.mainUser.profileImageUrl ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Circle()
                                    .fill(Color.carPrimary.opacity(0.15))
                                    .overlay(
                                        Text(currentTenant.mainUser.firstName.prefix(1).uppercased())
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.carPrimary)
                                    )
                            }
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            
                            Text(currentTenant.mainUser.firstName)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.gray100)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            
            // Account Status Banner (if needed)
            if currentTenant.missedPayment {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.error)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Payment Issue")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.error)
                        
                        Text("Your payment failed. Please update your payment method to avoid service interruption.")
                            .font(.system(size: 13))
                            .foregroundColor(.error.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    Button("Update Payment") {
                        // Handle payment update
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.error)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(Color.error.opacity(0.08))
            }
            
            // Divider
            Rectangle()
                .fill(Color.gray200.opacity(0.5))
                .frame(height: 0.5)
        }
    }
    
    // Helper computed properties
    private var accountTypeColor: Color {
        switch currentTenant.accountType {
        case .trial:
            return Color.warning
        case .premium:
            return Color.carPrimary
        case .enterprise:
            return Color.success
        }
    }
    
    private var primaryActionIcon: String {
        currentTenant.accountType == .trial ? "sparkles" : "person.badge.plus"
    }
    
    private var primaryActionTitle: String {
        currentTenant.accountType == .trial ? "Upgrade Plan" : "Add Users"
    }
}

// MARK: - Custom Tab Bar
struct TenantAdminTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        ("Users", "person.2.fill"),
        ("Settings", "gearshape.fill"),
        ("Billing", "creditcard.fill")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: tab.1)
                            .font(.system(size: 20, weight: selectedTab == index ? .semibold : .medium))
                            .foregroundColor(selectedTab == index ? .carPrimary : .textSecondary)
                        
                        Text(tab.0)
                            .font(.system(size: 11, weight: selectedTab == index ? .semibold : .medium))
                            .foregroundColor(selectedTab == index ? .carPrimary : .textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        selectedTab == index ?
                        Color.carPrimary.opacity(0.1) :
                        Color.clear
                    )
                    .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.gray200)
                .frame(height: 1),
            alignment: .top
        )
    }
}

#Preview {
    TenantAdminDashboardView()
}
