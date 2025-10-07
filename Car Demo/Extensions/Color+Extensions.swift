//
//  Color+Extensions.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

extension Color {
    // MARK: - Primary Colors
    static let primaryBlue = Color(red: 0.0, green: 0.48, blue: 1.0) // #007AFF
    static let primaryDark = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
    static let primaryLight = Color(red: 0.98, green: 0.98, blue: 1.0) // #F9F9FF
    
    // MARK: - Semantic Colors
    static let success = Color(red: 0.20, green: 0.78, blue: 0.35) // #34C759
    static let warning = Color(red: 1.0, green: 0.58, blue: 0.0) // #FF9500
    static let error = Color(red: 1.0, green: 0.23, blue: 0.19) // #FF3B30
    
    // MARK: - Gray Scale
    static let gray50 = Color(red: 0.98, green: 0.98, blue: 0.98) // #FAFAFA
    static let gray100 = Color(red: 0.96, green: 0.96, blue: 0.96) // #F5F5F5
    static let gray200 = Color(red: 0.93, green: 0.93, blue: 0.93) // #EEEEEE
    static let gray300 = Color(red: 0.88, green: 0.88, blue: 0.88) // #E0E0E0
    static let gray400 = Color(red: 0.74, green: 0.74, blue: 0.74) // #BDBDBD
    static let gray500 = Color(red: 0.62, green: 0.62, blue: 0.62) // #9E9E9E
    static let gray600 = Color(red: 0.46, green: 0.46, blue: 0.46) // #757575
    static let gray700 = Color(red: 0.38, green: 0.38, blue: 0.38) // #616161
    static let gray800 = Color(red: 0.26, green: 0.26, blue: 0.26) // #424242
    static let gray900 = Color(red: 0.13, green: 0.13, blue: 0.13) // #212121
    
    // MARK: - Background Colors
    static let backgroundPrimary = Color(UIColor.systemBackground)
    static let backgroundSecondary = Color(UIColor.secondarySystemBackground)
    static let backgroundTertiary = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - Text Colors
    static let textPrimary = Color(UIColor.label)
    static let textSecondary = Color(UIColor.secondaryLabel)
    static let textTertiary = Color(UIColor.tertiaryLabel)
    
    // MARK: - Gradient Colors
    static let gradientStart = Color(red: 0.21, green: 0.45, blue: 0.46) // #367376 - Teal
    static let gradientEnd = Color(red: 0.29, green: 0.58, blue: 0.60) // #4a9498 - Light Teal
    
    // MARK: - Cartlann Care Specific Colors (matching car-web)
    static let carPrimary = Color(red: 0.21, green: 0.45, blue: 0.46) // #367376 - Teal (brand-green)
    static let carSecondary = Color(red: 0.95, green: 0.95, blue: 0.97) // Light Gray
    static let carAccent = Color(red: 0.29, green: 0.58, blue: 0.60) // #4a9498 - Light Teal
    
    // Additional brand colors from car-web
    static let brandGreen = Color(red: 0.21, green: 0.45, blue: 0.46) // #367376
    static let brandGreenLight = Color(red: 0.29, green: 0.58, blue: 0.60) // #4a9498
    static let brandTextPrimary = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
    static let brandTextSecondary = Color(red: 0.46, green: 0.46, blue: 0.46) // #757575
    
    // MARK: - Helper Methods
    static func hex(_ hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        return Color(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
