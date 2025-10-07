//
//  TenantSettingsView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct TenantSettingsView: View {
    @State private var currentTenant = MockData.tenants.first!
    @State private var showingEditProfile = false
    @State private var showingChangePassword = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Practice Profile Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Practice Profile")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 16) {
                        // Practice Logo and Name
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: currentTenant.logoUrl ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.carPrimary.opacity(0.1))
                                    .overlay(
                                        Text(currentTenant.practiceName.prefix(1).uppercased())
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundColor(.carPrimary)
                                    )
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(currentTenant.practiceName)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                Text(currentTenant.email)
                                    .font(.system(size: 16))
                                    .foregroundColor(.textSecondary)
                                
                                Text(currentTenant.specialty)
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.carPrimary.opacity(0.1))
                                    .cornerRadius(6)
                            }
                            
                            Spacer()
                        }
                        
                        Button(action: { showingEditProfile = true }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 14, weight: .medium))
                                
                                Text("Edit Practice Profile")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.carPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.carPrimary.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Account Settings Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Account Settings")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 12) {
                        SettingsRow(
                            icon: "person.circle.fill",
                            title: "Personal Information",
                            subtitle: "Update your personal details",
                            action: { showingEditProfile = true }
                        )
                        
                        SettingsRow(
                            icon: "lock.fill",
                            title: "Change Password",
                            subtitle: "Update your account password",
                            action: { showingChangePassword = true }
                        )
                        
                        SettingsRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Manage notification preferences",
                            action: { /* Handle notifications */ }
                        )
                        
                        SettingsRow(
                            icon: "shield.fill",
                            title: "Privacy & Security",
                            subtitle: "Manage privacy settings",
                            action: { /* Handle privacy */ }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Subscription Info Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Subscription Information")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current Plan")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textSecondary)
                                
                                Text(currentTenant.accountType.displayName)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            Spacer()
                            
                            Text("$\(String(format: "%.0f", currentTenant.monthlyRevenue))/month")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.success)
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Active Seats")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textSecondary)
                                
                                Text("\(currentTenant.activeSeats)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            Spacer()
                            
                            if currentTenant.accountType != .trial {
                                Button("Buy More Seats") {
                                    // Handle buy seats
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.carPrimary)
                                .cornerRadius(8)
                            }
                        }
                        
                        if currentTenant.accountType == .trial {
                            Button(action: {
                                // Handle upgrade
                            }) {
                                HStack {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text("Upgrade to Premium")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.carPrimary)
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Support Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Support & Help")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 12) {
                        SettingsRow(
                            icon: "questionmark.circle.fill",
                            title: "Help Center",
                            subtitle: "Find answers to common questions",
                            action: { /* Handle help */ }
                        )
                        
                        SettingsRow(
                            icon: "envelope.fill",
                            title: "Contact Support",
                            subtitle: "Get help from our support team",
                            action: { /* Handle contact */ }
                        )
                        
                        SettingsRow(
                            icon: "doc.text.fill",
                            title: "Terms & Privacy",
                            subtitle: "Review our terms and privacy policy",
                            action: { /* Handle terms */ }
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
        .sheet(isPresented: $showingEditProfile) {
            EditPracticeProfileView(tenant: currentTenant)
        }
        .sheet(isPresented: $showingChangePassword) {
            ChangePasswordView()
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
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
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.backgroundSecondary)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Edit Practice Profile View
struct EditPracticeProfileView: View {
    @Environment(\.dismiss) private var dismiss
    let tenant: Tenant
    @State private var practiceName = ""
    @State private var email = ""
    @State private var specialty = ""
    @State private var address = ""
    @State private var phone = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Edit Practice Profile")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Update your practice information")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Practice Name",
                            placeholder: "Medical Center",
                            text: $practiceName
                        )
                        
                        CustomTextField(
                            title: "Email Address",
                            placeholder: "contact@practice.com",
                            text: $email,
                            keyboardType: .emailAddress,
                            autocapitalization: .never
                        )
                        
                        CustomTextField(
                            title: "Specialty",
                            placeholder: "Cardiology",
                            text: $specialty
                        )
                        
                        CustomTextField(
                            title: "Address",
                            placeholder: "123 Medical St, City, State",
                            text: $address
                        )
                        
                        CustomTextField(
                            title: "Phone Number",
                            placeholder: "+1 (555) 123-4567",
                            text: $phone,
                            keyboardType: .phonePad
                        )
                    }
                    
                    CustomButton(
                        title: "Save Changes",
                        action: {
                            // Mock save
                            dismiss()
                        },
                        style: .primary,
                        size: .large
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
        .onAppear {
            // Pre-populate fields
            practiceName = tenant.practiceName
            email = tenant.email
            specialty = tenant.specialty
        }
    }
}

// MARK: - Change Password View
struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Change Password")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Enter your current password and choose a new one")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Current Password",
                            placeholder: "Enter current password",
                            text: $currentPassword,
                            isSecure: true
                        )
                        
                        CustomTextField(
                            title: "New Password",
                            placeholder: "Enter new password",
                            text: $newPassword,
                            isSecure: true
                        )
                        
                        CustomTextField(
                            title: "Confirm New Password",
                            placeholder: "Confirm new password",
                            text: $confirmPassword,
                            isSecure: true
                        )
                    }
                    
                    CustomButton(
                        title: "Update Password",
                        action: {
                            // Mock update
                            dismiss()
                        },
                        style: .primary,
                        size: .large,
                        isDisabled: currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty || newPassword != confirmPassword
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

#Preview {
    TenantSettingsView()
}
