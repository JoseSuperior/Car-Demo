//
//  RegisterView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var isLoading = false
    @State private var acceptTerms = false
    @State private var receiveUpdates = false
    
    // Error states
    @State private var firstNameError: String? = nil
    @State private var lastNameError: String? = nil
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var phoneError: String? = nil
    
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
                
                Image(systemName: "stethoscope")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Title and Subtitle
            VStack(spacing: 8) {
                Text("Register Your Practice")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Join Cartlann Care to securely manage your medical recordings")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 30)
    }
    
    // MARK: - Form Section
    
    private var formSection: some View {
        VStack(spacing: 20) {
            // Name Fields
            HStack(spacing: 12) {
                CustomTextField(
                    title: "First Name",
                    placeholder: "First name",
                    text: $firstName,
                    autocapitalization: .words,
                    errorMessage: firstNameError
                )
                .onChange(of: firstName) {
                    validateFirstName()
                }
                
                CustomTextField(
                    title: "Last Name",
                    placeholder: "Last name",
                    text: $lastName,
                    autocapitalization: .words,
                    errorMessage: lastNameError
                )
                .onChange(of: lastName) {
                    validateLastName()
                }
            }
            
            // Email Field
            CustomTextField(
                title: "Practice Email Address",
                placeholder: "Enter your practice email",
                text: $email,
                keyboardType: .emailAddress,
                autocapitalization: .never,
                errorMessage: emailError
            )
            .onChange(of: email) {
                validateEmail()
            }
            
            // Phone Field
            CustomTextField(
                title: "Professional Phone Number",
                placeholder: "Enter your professional phone",
                text: $phoneNumber,
                keyboardType: .phonePad,
                errorMessage: phoneError
            )
            .onChange(of: phoneNumber) {
                validatePhone()
            }
            
            // Password Field
            CustomTextField(
                title: "Secure Password",
                placeholder: "Create a secure password",
                text: $password,
                isSecure: true,
                errorMessage: passwordError
            )
            .onChange(of: password) {
                validatePassword()
                validateConfirmPassword()
            }
            
            // Confirm Password Field
            CustomTextField(
                title: "Confirm Password",
                placeholder: "Confirm your password",
                text: $confirmPassword,
                isSecure: true,
                errorMessage: confirmPasswordError
            )
            .onChange(of: confirmPassword) {
                validateConfirmPassword()
            }
            
            // Password Requirements
            passwordRequirements
            
            // Terms and Conditions
            termsSection
            
            // Create Account Button
            CustomButton(
                title: "Register Practice",
                action: handleCreateAccount,
                style: .primary,
                size: .large,
                isLoading: isLoading,
                isDisabled: !isFormValid
            )
            .padding(.top, 20)
            
            // Social Registration Section
            socialRegistrationSection
        }
    }
    
    // MARK: - Password Requirements
    
    private var passwordRequirements: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password must contain:")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.textSecondary)
            
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    PasswordRequirement(
                        text: "At least 8 characters",
                        isValid: password.count >= 8
                    )
                    PasswordRequirement(
                        text: "One uppercase letter",
                        isValid: password.range(of: "[A-Z]", options: .regularExpression) != nil
                    )
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    PasswordRequirement(
                        text: "One lowercase letter",
                        isValid: password.range(of: "[a-z]", options: .regularExpression) != nil
                    )
                    PasswordRequirement(
                        text: "One number",
                        isValid: password.range(of: "[0-9]", options: .regularExpression) != nil
                    )
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.gray50)
        .cornerRadius(12)
    }
    
    // MARK: - Terms Section
    
    private var termsSection: some View {
        VStack(spacing: 12) {
            // Accept Terms
            Button(action: {
                acceptTerms.toggle()
            }) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(acceptTerms ? .carPrimary : .gray400)
                        .font(.system(size: 18))
                    
                    Text("I agree to the Terms of Service, Privacy Policy, and HIPAA Business Associate Agreement")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
            
            // Receive Updates
            Button(action: {
                receiveUpdates.toggle()
            }) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: receiveUpdates ? "checkmark.square.fill" : "square")
                        .foregroundColor(receiveUpdates ? .carPrimary : .gray400)
                        .font(.system(size: 18))
                    
                    Text("I want to receive medical platform updates and educational content")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Social Registration Section
    
    private var socialRegistrationSection: some View {
        VStack(spacing: 16) {
            // Divider
            HStack {
                Rectangle()
                    .fill(Color.gray300)
                    .frame(height: 1)
                
                Text("or sign up with")
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
                    action: { handleSocialRegistration(.apple) }
                )
                
                SocialLoginButton(
                    icon: "globe",
                    title: "Google SSO",
                    action: { handleSocialRegistration(.google) }
                )
            }
        }
    }
    
    // MARK: - Footer Section
    
    private var footerSection: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Sign In Link
            HStack {
                Text("Already registered your practice?")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
                
                Button("Sign In") {
                    dismiss()
                    // Navigate to Login
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.carPrimary)
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Computed Properties
    
    private var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        acceptTerms &&
        firstNameError == nil &&
        lastNameError == nil &&
        emailError == nil &&
        passwordError == nil &&
        confirmPasswordError == nil &&
        phoneError == nil
    }
    
    // MARK: - Validation Methods
    
    private func validateFirstName() {
        if firstName.isEmpty {
            firstNameError = nil
        } else if firstName.count < 2 {
            firstNameError = "First name must be at least 2 characters"
        } else {
            firstNameError = nil
        }
    }
    
    private func validateLastName() {
        if lastName.isEmpty {
            lastNameError = nil
        } else if lastName.count < 2 {
            lastNameError = "Last name must be at least 2 characters"
        } else {
            lastNameError = nil
        }
    }
    
    private func validateEmail() {
        if email.isEmpty {
            emailError = nil
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid email address"
        } else {
            emailError = nil
        }
    }
    
    private func validatePhone() {
        if phoneNumber.isEmpty {
            phoneError = nil
        } else if phoneNumber.count < 10 {
            phoneError = "Please enter a valid phone number"
        } else {
            phoneError = nil
        }
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = nil
        } else if !isValidPassword(password) {
            passwordError = "Password doesn't meet requirements"
        } else {
            passwordError = nil
        }
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = nil
        } else if password != confirmPassword {
            confirmPasswordError = "Passwords don't match"
        } else {
            confirmPasswordError = nil
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let hasMinLength = password.count >= 8
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        
        return hasMinLength && hasUppercase && hasLowercase && hasNumber
    }
    
    // MARK: - Action Methods
    
    private func handleCreateAccount() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isLoading = false
            // Handle successful registration
            dismiss()
        }
    }
    
    private func handleSocialRegistration(_ provider: SocialLoginProvider) {
        // Handle social registration
        print("Social registration with \(provider)")
    }
}

// MARK: - Supporting Views

struct PasswordRequirement: View {
    let text: String
    let isValid: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isValid ? .success : .gray400)
                .font(.system(size: 12))
            
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(isValid ? .success : .textTertiary)
        }
    }
}

#Preview {
    RegisterView()
}
