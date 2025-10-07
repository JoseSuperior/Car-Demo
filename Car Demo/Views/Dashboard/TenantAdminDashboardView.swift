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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                TenantAdminHeaderView(onLogout: {
                    showingLogoutAlert = true
                })
                
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
    @State private var currentTenant = MockData.tenants.first!
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Practice Logo and Info
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: currentTenant.logoUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.carPrimary.opacity(0.1))
                            .overlay(
                                Text(currentTenant.practiceName.prefix(1).uppercased())
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.carPrimary)
                            )
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(currentTenant.practiceName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Tenant Dashboard")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // Action Buttons and Profile
                HStack(spacing: 12) {
                    // File Manager Button
                    Button(action: {
                        // Handle file manager
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "folder.fill")
                                .font(.system(size: 14))
                            
                            Text("Files")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(8)
                    }
                    
                    // Buy Seats / Upgrade Button
                    if currentTenant.accountType == .trial {
                        Button(action: {
                            // Handle upgrade
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "creditcard.fill")
                                    .font(.system(size: 14))
                                
                                Text("Upgrade")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.carPrimary)
                            .cornerRadius(8)
                        }
                    } else {
                        Button(action: {
                            // Handle buy seats
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 14))
                                
                                Text("Buy Seats")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.carPrimary)
                            .cornerRadius(8)
                        }
                    }
                    
                    // Profile Button
                    Button(action: onLogout) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.carPrimary.opacity(0.1))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Text(currentTenant.mainUser.firstName.prefix(1).uppercased())
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.carPrimary)
                                )
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            
            // Account Status Banner (if needed)
            if currentTenant.missedPayment {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.error)
                    
                    Text("Payment failed - Please update your payment method")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.error)
                    
                    Spacer()
                    
                    Button("Update Payment") {
                        // Handle payment update
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.error)
                    .cornerRadius(6)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.error.opacity(0.1))
            }
            
            // Divider
            Rectangle()
                .fill(Color.gray200)
                .frame(height: 1)
        }
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
