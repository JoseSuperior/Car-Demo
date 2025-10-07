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
            // Main Header
            HStack(alignment: .center, spacing: 16) {
                // Practice Logo and Info
                HStack(spacing: 12) {
                    // Logo with shadow
                    AsyncImage(url: URL(string: currentTenant.logoUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.carPrimary.opacity(0.8),
                                            Color.carPrimary
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text(currentTenant.practiceName.prefix(1).uppercased())
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .shadow(color: Color.carPrimary.opacity(0.3), radius: 8, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentTenant.practiceName)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "building.2")
                                .font(.system(size: 11, weight: .medium))
                            
                            Text("Tenant Dashboard")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 10) {
                    // Account Type Badge (iOS style)
                    HStack(spacing: 6) {
                        Circle()
                            .fill(accountTypeColor)
                            .frame(width: 6, height: 6)
                        
                        Text(currentTenant.accountType.displayName)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.textPrimary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(accountTypeColor.opacity(0.1))
                    .cornerRadius(20)
                    
                    // Primary Action Button
                    Button(action: {
                        // Handle primary action
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: primaryActionIcon)
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text(primaryActionTitle)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.carPrimary, Color.carPrimary.opacity(0.85)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(10)
                        .shadow(color: Color.carPrimary.opacity(0.3), radius: 6, x: 0, y: 3)
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
                        HStack(spacing: 10) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.carPrimary.opacity(0.15),
                                                Color.carPrimary.opacity(0.1)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 36, height: 36)
                                
                                Text(currentTenant.mainUser.firstName.prefix(1).uppercased())
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.carPrimary)
                            }
                            
                            // Chevron
                            Image(systemName: "chevron.down")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                Color.white
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            )
            
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
