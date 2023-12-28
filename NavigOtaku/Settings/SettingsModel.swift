//
//  SettingsModel.swift
//  NavigOtaku
//
//  Created by Wentao Jiang on 12/11/23.
//

import Foundation
import SwiftUI

class SettingsModel: ObservableObject {
    // DARK MODE
    @AppStorage("isDarkMode") var isDarkMode: Bool = false {
        didSet {
            objectWillChange.send()
            if textColorSelection == .defaultColor {
                objectWillChange.send()
            }
        }
    }
    
    @AppStorage("textColor") var textColorRawValue: String = TextColor.defaultColor.rawValue {
        didSet {
            objectWillChange.send()
        }
    }
    
    // TEXT COLOR
    var textColorSelection: TextColor {
        get { TextColor(rawValue: textColorRawValue) ?? .defaultColor }
        set { textColorRawValue = newValue.rawValue }
    }

    var actualTextColor: Color {
        textColorSelection.color(isDarkMode: isDarkMode)
    }
    
    // USER NOTIFICATION
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true {
        didSet {
            updateNotificationSettings()
        }
    }
    
    private func updateNotificationSettings() {
        if notificationsEnabled {
            NotificationManager.shared.requestAuth()
        } else {
            NotificationManager.shared.removeNotifications()
        }
    }
    
    // LAUNCH SOUND
    @AppStorage("startupSoundEnabled") var startupSoundEnabled: Bool = true
}

enum TextColor: String, CaseIterable {
    case defaultColor = "Default"
    case orange = "Orange"
    case pink = "Pink"

    func color(isDarkMode: Bool) -> Color {
        switch self {
        case .defaultColor:
            return isDarkMode ? .white : .black
        case .orange:
            return .orange
        case .pink:
            return .pink
        }
    }
}
