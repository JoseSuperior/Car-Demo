//
//  CustomButton.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var style: ButtonStyle = .primary
    var size: ButtonSize = .medium
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    enum ButtonStyle {
        case primary
        case secondary
        case outline
        case ghost
    }
    
    enum ButtonSize {
        case small
        case medium
        case large
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(fontSize)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .scaleEffect(isDisabled ? 0.95 : 1.0)
            .opacity(isDisabled ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isDisabled)
        }
        .disabled(isDisabled || isLoading)
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Computed Properties
    
    private var buttonHeight: CGFloat {
        switch size {
        case .small: return 40
        case .medium: return 50
        case .large: return 56
        }
    }
    
    private var fontSize: Font {
        switch size {
        case .small: return .system(size: 14, weight: .semibold)
        case .medium: return .system(size: 16, weight: .semibold)
        case .large: return .system(size: 18, weight: .semibold)
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return Color.carPrimary
        case .secondary:
            return Color.gray.opacity(0.2)
        case .outline:
            return Color.clear
        case .ghost:
            return Color.clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .primary
        case .outline:
            return .carPrimary
        case .ghost:
            return .carPrimary
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary, .secondary, .ghost:
            return Color.clear
        case .outline:
            return Color.carPrimary
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outline:
            return 2
        default:
            return 0
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomButton(title: "Primary Button", action: {})
        CustomButton(title: "Secondary Button", action: {}, style: .secondary)
        CustomButton(title: "Outline Button", action: {}, style: .outline)
        CustomButton(title: "Ghost Button", action: {}, style: .ghost)
        CustomButton(title: "Loading Button", action: {}, isLoading: true)
        CustomButton(title: "Disabled Button", action: {}, isDisabled: true)
    }
    .padding()
}
