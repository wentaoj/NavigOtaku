//
//  SettingsView.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/10/23.
//

import SwiftUI
struct AppInfoView: View {
    @Binding var isImageTapped: Bool
    @State private var isTextTapped = false
    @StateObject private var soundManager = SoundManager()
    
    var body: some View {
        VStack {
            Spacer()
            Image("App_Icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: isImageTapped ? 240 : 200, height: isImageTapped ? 240 : 200)
                .cornerRadius(isImageTapped ? 36 : 30)
                .scaleEffect(isImageTapped ? 1.2 : 1.0)
                .rotationEffect(.degrees(isImageTapped ? 5 : 0))
                .animation(.easeInOut(duration: 0.5), value: isImageTapped)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isImageTapped = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                soundManager.playSound()
                                isImageTapped = false
                            }
                        }
                )

            Text(Bundle.main.displayName ?? "App Name")
                .font(.title)
                .padding(.top)
                .foregroundColor(isTextTapped ? .pink : .primary)
                .animation(.easeInOut(duration: 0.7), value: isTextTapped)
                .bold()
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isTextTapped = true }
                )
            Spacer()
            HStack {
                if let copyright = Bundle.main.copyright {
                    Spacer()
                    Text(copyright)
                        .font(.caption)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

struct SettingsView: View {
    @ObservedObject var settings = SettingsModel()
    @State private var isImageTapped = false
    
    var body: some View {
        VStack {
            Spacer()
            AppInfoView(isImageTapped: $isImageTapped)
            Form {
                Section(header: Text("Preference Settings")) {
                    Picker("Font Color", selection: $settings.textColorSelection) {
                        ForEach(TextColor.allCases, id: \.self) { color in
                            Text(color.rawValue).tag(color)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Toggle(isOn: $settings.isDarkMode) {
                        Text("Dark Mode")
                    }
                
                    Toggle(isOn: $settings.notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    Toggle(isOn: $settings.startupSoundEnabled) {
                        Text("Enable Sound Effects")
                    }
                }
            }
            
        }
        .navigationTitle("Settings")
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
