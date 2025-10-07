//
//  LoginView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showingForgotPassword = false
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var rememberMe = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        headerSection
                        
                        // Form Section
                        formSection
                        
                        // Footer Section
                        footerSection
                    }
                    .padding(.horizontal, 24)
                    .frame(minHeight: geometry.size.height)
                }
            }
            .background(Color.backgroundPrimary)
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
        .sheet(isPresented: $showingForgotPassword) {
            ForgotPasswordView()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 24) {
            // App Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gradientStart, Color.gradientEnd]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Title and Subtitle
            VStack(spacing: 8) {
                Text("Welcome Back to Cartlann Care")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Access your secure medical recording platform")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 40)
        .padding(.bottom, 40)
    }
    
    // MARK: - Form Section
    
    private var formSection: some View {
        VStack(spacing: 20) {
            // Email Field
            CustomTextField(
                title: "Email Address",
                placeholder: "Enter your practice email",
                text: $email,
                keyboardType: .emailAddress,
                autocapitalization: .never,
                errorMessage: emailError
            )
            .onChange(of: email) {
                validateEmail()
            }
            
            // Password Field
            CustomTextField(
                title: "Password",
                placeholder: "Enter your secure password",
                text: $password,
                isSecure: true,
                errorMessage: passwordError
            )
            .onChange(of: password) {
                validatePassword()
            }
            
            // Remember Me & Forgot Password
            HStack {
                Button(action: {
                    rememberMe.toggle()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                            .foregroundColor(rememberMe ? .carPrimary : .gray400)
                            .font(.system(size: 18))
                        
                        Text("Remember me")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                Button("Forgot Password?") {
                    showingForgotPassword = true
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.carPrimary)
            }
            .padding(.top, 8)
            
            // Sign In Button
            CustomButton(
                title: "Access Dashboard",
                action: handleSignIn,
                style: .primary,
                size: .large,
                isLoading: isLoading,
                isDisabled: !isFormValid
            )
            .padding(.top, 20)
            
            // Social Login Section
            socialLoginSection
        }
    }
    
    // MARK: - Social Login Section
    
    private var socialLoginSection: some View {
        VStack(spacing: 16) {
            // Divider
            HStack {
                Rectangle()
                    .fill(Color.gray300)
                    .frame(height: 1)
                
                Text("or continue with")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color.gray300)
                    .frame(height: 1)
            }
            .padding(.vertical, 20)
            
            // Social Buttons
            HStack(spacing: 16) {
                SocialLoginButton(
                    icon: "apple.logo",
                    title: "Apple ID",
                    action: { handleSocialLogin(.apple) }
                )
                
                SocialLoginButton(
                    icon: "globe",
                    title: "Google SSO",
                    action: { handleSocialLogin(.google) }
                )
            }
        }
    }
    
    // MARK: - Footer Section
    
    private var footerSection: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Sign Up Link
            HStack {
                Text("Need to register your practice?")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
                
                Button("Start Free Trial") {
                    dismiss()
                    // Navigate to Register
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.carPrimary)
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Computed Properties
    
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && emailError == nil && passwordError == nil
    }
    
    // MARK: - Methods
    
    private func validateEmail() {
        if email.isEmpty {
            emailError = nil
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid email address"
        } else {
            emailError = nil
        }
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = nil
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
        } else {
            passwordError = nil
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func handleSignIn() {
        isLoading = true
        
        // Mock login - any email/password combination works
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            // Use the new UserSession system
            let success = UserSession.shared.login(email: email, password: password)
            
            if success {
                // Notify that login state changed
                NotificationCenter.default.post(name: .init("LoginStateChanged"), object: nil)
                dismiss()
            }
        }
    }
    
    private func handleSocialLogin(_ provider: SocialLoginProvider) {
        // Handle social login
        print("Social login with \(provider)")
    }
}

// MARK: - Supporting Views

struct SocialLoginButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.gray100)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray300, lineWidth: 1)
            )
        }
    }
}

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.carPrimary)
                    
                    Text("Reset Password")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("Enter your email address and we'll send you a link to reset your password.")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                CustomTextField(
                    title: "Email Address",
                    placeholder: "Enter your email",
                    text: $email,
                    keyboardType: .emailAddress,
                    autocapitalization: .never
                )
                
                CustomButton(
                    title: "Send Reset Link",
                    action: {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            isLoading = false
                            dismiss()
                        }
                    },
                    style: .primary,
                    size: .large,
                    isLoading: isLoading,
                    isDisabled: email.isEmpty
                )
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Enums

enum SocialLoginProvider {
    case apple
    case google
}

#Preview {
    LoginView()
}
