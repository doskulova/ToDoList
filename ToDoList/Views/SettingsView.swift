//
//  SettingsView.swift
//  ToDoList
//
//  Created by Alina Doskulova on 21/2/25.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.dismiss) var dismiss
    let languages = ["en": "English", "ru": "Русский"]
    
    private let primaryColor = Color.pink
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [primaryColor.opacity(0.3), primaryColor.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .blur(radius: 30)
                
                Form {
                    themeSection
                    languageSection
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("settings.title".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                doneToolbarItem
            }
        }
        .preferredColorScheme(settings.selectedTheme.colorScheme)
    }
    
    private var themeSection: some View {
        Section {
            HStack(spacing: 20) {
                ForEach(Settings.Theme.allCases, id: \.self) { theme in
                    ThemeOptionView(
                        theme: theme,
                        isSelected: theme == settings.selectedTheme,
                        primaryColor: primaryColor
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            settings.selectedTheme = theme
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .listRowBackground(Color.clear)
        } header: {
            SectionHeaderView(
                icon: "paintpalette.fill",
                text: "theme.title".localized(),
                primaryColor: primaryColor
            )
        }
    }
    
    private var languageSection: some View {
        Section {
            ForEach(Array(languages.keys.sorted()), id: \.self) { code in
                LanguageRow(
                    code: code,
                    name: languages[code]!,
                    isSelected: code == settings.selectedLanguage,
                    primaryColor: primaryColor
                )
                .onTapGesture {
                    withAnimation {
                        settings.selectedLanguage = code
            
                        UserDefaults.standard.set(code, forKey: "selectedLanguage")
                        
        
                        changeLanguage(to: code)
                    }
                }
            }
        } header: {
            SectionHeaderView(
                icon: "globe",
                text: "language.title".localized(),
                primaryColor: primaryColor
            )
        }
    }
    
    private var doneToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                dismiss()
            } label: {
                Text("done.button".localized())
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(primaryColor.opacity(0.2))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(primaryColor.opacity(0.4), lineWidth: 1)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
    
    
    private func changeLanguage(to languageCode: String) {
        _ = Locale(identifier: languageCode)
        
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let _ = Bundle(path: path) {
        }
    }
    
    struct ThemeOptionView: View {
        let theme: Settings.Theme
        let isSelected: Bool
        let primaryColor: Color
        
        var body: some View {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(theme.colorScheme == .dark ? Color.black : Color.white)
                        .frame(width: 80, height: 80)
                        .shadow(color: isSelected ? primaryColor.opacity(0.4) : .black.opacity(0.1), radius: 8)
                    
                    VStack {
                        Circle()
                            .fill(primaryColor.opacity(0.7))
                            .frame(width: 12, height: 12)
                            .padding(4)
                        Rectangle()
                            .fill(Color.secondary.opacity(0.3))
                            .frame(height: 24)
                        Spacer()
                    }
                    .padding(8)
                    .frame(width: 80, height: 80)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? primaryColor : Color.clear, lineWidth: 3)
                )
                .scaleEffect(isSelected ? 1.1 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
                
                Text(theme.rawValue.localized())
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundColor(isSelected ? primaryColor : .primary)
            }
        }
    }
    
    struct LanguageRow: View {
        let code: String
        let name: String
        let isSelected: Bool
        let primaryColor: Color
        
        var body: some View {
            HStack {
                Text(Locale.current.localizedString(forIdentifier: code) ?? name)
                    .font(.system(.body, design: .rounded))
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(primaryColor)
                        .transition(.scale.combined(with: .opacity))
                }
                
                Text(code.uppercased())
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .padding(6)
                    .background(primaryColor.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? primaryColor.opacity(0.1) : Color.clear)
            )
            .contentShape(Rectangle())
        }
    }
    
    struct SectionHeaderView: View {
        let icon: String
        let text: String
        let primaryColor: Color
        
        var body: some View {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(primaryColor)
                Text(text)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .textCase(nil)
            }
            .padding(.vertical, 8)
        }
    }
    
    struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(.spring(), value: configuration.isPressed)
        }
    }
}
