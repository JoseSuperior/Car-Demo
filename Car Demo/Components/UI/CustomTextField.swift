//
//  CustomTextField.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences
    var errorMessage: String? = nil
    
    @FocusState private var isFocused: Bool
    @State private var isSecureVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            if !title.isEmpty {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            // Text Field Container
            HStack {
                Group {
                    if isSecure && !isSecureVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                            .textInputAutocapitalization(autocapitalization)
                    }
                }
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .focused($isFocused)
                
                // Show/Hide Password Button
                if isSecure {
                    Button(action: {
                        isSecureVisible.toggle()
                    }) {
                        Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            // Error Message
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var borderColor: Color {
        if let errorMessage = errorMessage, !errorMessage.isEmpty {
            return .red
        } else if isFocused {
            return .carPrimary
        } else {
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        if let errorMessage = errorMessage, !errorMessage.isEmpty {
            return 2
        } else if isFocused {
            return 2
        } else {
            return 0
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomTextField(
            title: "Email",
            placeholder: "Enter your email",
            text: .constant(""),
            keyboardType: .emailAddress,
            autocapitalization: .never
        )
        
        CustomTextField(
            title: "Password",
            placeholder: "Enter your password",
            text: .constant(""),
            isSecure: true
        )
        
        CustomTextField(
            title: "Name",
            placeholder: "Enter your name",
            text: .constant("John Doe")
        )
        
        CustomTextField(
            title: "Email with Error",
            placeholder: "Enter your email",
            text: .constant("invalid-email"),
            keyboardType: .emailAddress,
            autocapitalization: .never,
            errorMessage: "Please enter a valid email address"
        )
    }
    .padding()
}
