//
//  LandingView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct LandingView: View {
    @State private var currentPage = 0
    @State private var showingLogin = false
    @State private var showingRegister = false
    
    private let features = [
        FeatureItem(
            icon: "stethoscope",
            title: "HIPAA-Compliant Recording",
            description: "Securely record and manage medical consultations with full HIPAA compliance and encryption."
        ),
        FeatureItem(
            icon: "person.2.fill",
            title: "Multi-Provider Support",
            description: "Manage multiple healthcare providers and team members with role-based access control."
        ),
        FeatureItem(
            icon: "shield.checkered",
            title: "Enterprise Security",
            description: "Bank-level security with end-to-end encryption and secure cloud infrastructure for medical data."
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.gradientStart, Color.gradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header Section
                    headerSection
                    
                    // Features TabView
                    featuresTabView
                    
                    // Page Indicator
                    pageIndicator
                    
                    // CTA Section
                    ctaSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showingLogin) {
            LoginView()
        }
        .sheet(isPresented: $showingRegister) {
            RegisterView()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // App Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // App Title
            VStack(spacing: 8) {
                Text("Cartlann Care")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Secure Medical Recording Platform")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - Features TabView
    
    private var featuresTabView: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                FeatureCard(feature: feature)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 300)
        .onAppear {
            startAutoScroll()
        }
    }
    
    // MARK: - Page Indicator
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<features.count, id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - CTA Section
    
    private var ctaSection: some View {
        VStack(spacing: 16) {
            // Trust Indicators
            HStack(spacing: 20) {
                TrustIndicator(icon: "checkmark.shield.fill", text: "HIPAA Compliant")
                TrustIndicator(icon: "ipad", text: "iPad Native")
                TrustIndicator(icon: "stethoscope", text: "Medical Grade")
            }
            .padding(.bottom, 20)
            
            // Action Buttons
            VStack(spacing: 12) {
                CustomButton(
                    title: "Start Your Practice",
                    action: { showingRegister = true },
                    style: .primary,
                    size: .large
                )
                .background(Color.white)
                .cornerRadius(16)
                
                CustomButton(
                    title: "Sign In",
                    action: { showingLogin = true },
                    style: .ghost,
                    size: .large
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
            }
            
            // Terms Text
            Text("By continuing, you agree to our Terms of Service, Privacy Policy, and HIPAA Business Associate Agreement")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
    }
    
    // MARK: - Helper Methods
    
    private func startAutoScroll() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPage = (currentPage + 1) % features.count
            }
        }
    }
}

// MARK: - Supporting Views

struct FeatureCard: View {
    let feature: FeatureItem
    
    var body: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(spacing: 12) {
                Text(feature.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(feature.description)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct TrustIndicator: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

// MARK: - Models

struct FeatureItem {
    let icon: String
    let title: String
    let description: String
}

#Preview {
    LandingView()
}
